//! Spike 004 — rejection sampling w torze progowym (P0.1, kawałek empiryczny).
//!
//! **PROTOTYP / pomiar, nie Klein-sampler FT1536.** Pytanie P0.1: jak kontrolować
//! bias odrzucania na udziałach **bez ujawniania liczby prób**?
//!
//! Trzy ścieżki:
//! 1. `sample_clear` — jawny rejection (oracle / wzorzec).
//! 2. `sample_mpc_naive` — kandydaci na udziałach, **bit accept jest jawny**
//!    → liczba prób T jest publiczna (wyciek).
//! 3. `sample_mpc_fixed_window` — okno T_max prób bez pętli jawnej;
//!    nadal może zdradzać (patrz testy).
//!
//! Model akceptacji (zamierzony uproszczony stand-in dyskretnej Gaussa):
//!   x ~ Uniform{-W..=W}, accept w.p. min(1, exp(-x^2 / (2σ^2))).
//! Tu bez `exp` w zależnościach: tablica wag / porównanie do progu z RNG.

/// Parametry samplera. Wartości dobrane pod pomiar wycieku, nie pod Falcona.
#[derive(Debug, Clone, Copy)]
pub struct SamplerParams {
    /// ramię propozycji: x ∈ {-W..=W}
    pub w: i32,
    /// σ^2 (jak wagowo w wykładniku)
    pub sigma2: i32,
    /// ile maks. prób w fixed-window
    pub t_max: u32,
}

impl Default for SamplerParams {
    fn default() -> Self {
        Self {
            w: 16,
            sigma2: 25,
            t_max: 64,
        }
    }
}

/// Wynik jednego losowania: próbkowany x oraz jawna liczba prób T.
/// **T jest tu publiczne celowo** — to jest przedmiot pomiaru wycieku.
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub struct SampleOutcome {
    pub x: i32,
    pub attempts: u32,
}

/// Jawna waga akceptacji: im większe |x|, tym mniejsze prawdopodobieństwo.
/// Przybliżenie min(1, exp(-x^2/(2σ^2))) na małej siatce — nie używamy `exp`.
/// Waga akceptacji (jawna, dla oracle i dealera testowego).
pub fn accept_weight_pub(x: i32, sigma2: i32) -> u32 {
    let s2 = sigma2.max(1) as u32;
    let x2 = (x as i64 * x as i64) as u32;
    256 / (1 + x2 / s2)
}

pub(crate) fn accept_weight(x: i32, sigma2: i32) -> u32 {
    accept_weight_pub(x, sigma2)
}

/// Jednostajne na [lo, hi] — **bez biasu modulo** (rejection sampling).
/// Stare `u32 % span` faworyzowało wartości z reszty; tu odrzucamy ogon.
pub fn uniform_range_pub(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    if lo > hi {
        // fail-closed: pusty przedział nie jest „cichym" lo
        return lo;
    }
    let span64 = hi as i64 - lo as i64 + 1;
    if span64 <= 1 {
        return lo;
    }
    // pełny zakres i32: span = 2^32 — każdy next_u32 jest poprawny
    if span64 > u32::MAX as i64 {
        return lo.wrapping_add(rng.next_u32() as i32);
    }
    let span = span64 as u32;
    if span.is_power_of_two() {
        return lo + (rng.next_u32() & (span - 1)) as i32;
    }
    // największa wielokrotność span w u32: v in [0, limit) ⇒ v % span bez biasu
    let limit = (u32::MAX / span) * span;
    loop {
        let v = rng.next_u32();
        if v < limit {
            return lo + (v % span) as i32;
        }
    }
}

fn uniform_range(rng: &mut impl rand::RngCore, lo: i32, hi: i32) -> i32 {
    uniform_range_pub(rng, lo, hi)
}

/// 1) Jawny rejection (oracle). Zwraca x oraz **jawną** liczbę prób T.
pub fn sample_clear(rng: &mut impl rand::RngCore, p: &SamplerParams) -> SampleOutcome {
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range(rng, -p.w, p.w);
        let w = accept_weight(x, p.sigma2);
        let u = rng.next_u32() & 0xFF;
        if u < w {
            return SampleOutcome { x, attempts };
        }
        if attempts > 10_000 {
            // awaryjne zamknięcie — retained, nie „cichy sukces"
            return SampleOutcome { x, attempts };
        }
    }
}

/// 2) MPC-naive: kandydat na udziałach, bit accept **otwierany** co próbę.
/// W prawdziwym protokole to broadcast — przeciwnik widzi T.
/// W spiku symulujemy strony lokalnie; ujawnienie bitu = jawne T.
pub fn sample_mpc_naive(
    rng: &mut impl rand::RngCore,
    p: &SamplerParams,
) -> (SampleOutcome, Vec<bool>) {
    let mut accept_trace = Vec::new();
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range(rng, -p.w, p.w);
        let w = accept_weight(x, p.sigma2);
        let u = rng.next_u32() & 0xFF;
        let accept = u < w;
        accept_trace.push(accept); // jawny bit rundy
        if accept {
            return (SampleOutcome { x, attempts }, accept_trace);
        }
        if attempts > 10_000 {
            return (SampleOutcome { x, attempts }, accept_trace);
        }
    }
}

/// 3) Fixed-window: dokładnie `t_max` losowanych kandydatów, pierwszy accepted.
/// Brak pętli „while not accepted" — T jest z góry ustalone (t_max),
/// ale **jawny jest indeks** pierwszego przyjętego (albo brak przyjęcia).
#[derive(Debug, Clone, PartialEq, Eq)]
pub enum FixedWindowOutcome {
    /// przyjęto kandydata o indeksie `idx` (0-based) — indeks jawny
    Accepted { x: i32, idx: u32 },
    /// nikt nie przeszedł progu w oknie
    AllRejected,
}

pub fn sample_mpc_fixed_window(
    rng: &mut impl rand::RngCore,
    p: &SamplerParams,
) -> FixedWindowOutcome {
    for idx in 0..p.t_max {
        let x = uniform_range(rng, -p.w, p.w);
        let w = accept_weight(x, p.sigma2);
        let u = rng.next_u32() & 0xFF;
        if u < w {
            return FixedWindowOutcome::Accepted { x, idx };
        }
    }
    FixedWindowOutcome::AllRejected
}

// ─── Statystyka wycieku (testy / pomiar) ──────────────────────────────────

/// Grubą korelacja |x| vs attempts (Pearson na f64).
pub fn corr_absx_attempts(samples: &[SampleOutcome]) -> f64 {
    let n = samples.len() as f64;
    if n < 2.0 {
        return 0.0;
    }
    let mut sx = 0.0;
    let mut st = 0.0;
    for s in samples {
        sx += s.x.abs() as f64;
        st += s.attempts as f64;
    }
    let mx = sx / n;
    let mt = st / n;
    let mut num = 0.0;
    let mut dx = 0.0;
    let mut dt = 0.0;
    for s in samples {
        let a = s.x.abs() as f64 - mx;
        let b = s.attempts as f64 - mt;
        num += a * b;
        dx += a * a;
        dt += b * b;
    }
    let den = (dx * dt).sqrt();
    if den == 0.0 {
        0.0
    } else {
        num / den
    }
}

/// Średnia T w zależności od |x| w kubełkach 0..=w.
pub fn mean_attempts_by_absx(samples: &[SampleOutcome], w: i32) -> Vec<f64> {
    let mut sum = vec![0.0f64; (w + 1) as usize];
    let mut cnt = vec![0.0f64; (w + 1) as usize];
    for s in samples {
        let b = (s.x.abs()).min(w) as usize;
        sum[b] += s.attempts as f64;
        cnt[b] += 1.0;
    }
    (0..=w as usize)
        .map(|i| if cnt[i] > 0.0 { sum[i] / cnt[i] } else { 0.0 })
        .collect()
}



#[cfg(test)]
mod tests {
    use super::*;
    use rand::rngs::OsRng;

    #[test]
    fn r1_clear_sampler_in_range() {
        let mut rng = OsRng;
        let p = SamplerParams::default();
        for _ in 0..200 {
            let s = sample_clear(&mut rng, &p);
            assert!(s.x.abs() <= p.w);
            assert!(s.attempts >= 1);
        }
    }

    #[test]
    fn r2_naive_exposes_attempt_trace() {
        let mut rng = OsRng;
        let p = SamplerParams::default();
        let (out, trace) = sample_mpc_naive(&mut rng, &p);
        assert_eq!(trace.len() as u32, out.attempts);
        assert!(trace.last().copied().unwrap_or(false), "last bit must be accept");
        assert!(trace.iter().filter(|&&a| !a).count() as u32 == out.attempts - 1);
    }

    #[test]
    fn r3_fixed_window_no_free_running_loop() {
        // ziarno unikalne: determinizm statystyki (F-18/F-20)
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xC35EED1);
        let p = SamplerParams {
            w: 2,
            sigma2: 1,
            t_max: 3, // małe okno → częsty AllRejected
        };
        let mut accepted = 0;
        let mut rejected = 0;
        for _ in 0..200 {
            match sample_mpc_fixed_window(&mut rng, &p) {
                FixedWindowOutcome::Accepted { idx, x } => {
                    assert!(idx < p.t_max);
                    assert!(x.abs() <= p.w);
                    accepted += 1;
                }
                FixedWindowOutcome::AllRejected => rejected += 1,
            }
        }
        // okno jest za małe żeby zawsze trafić — oba wyniki muszą wystąpić
        assert!(accepted > 0 && rejected > 0, "accepted={accepted} rejected={rejected}");
    }

    /// r4 — **RETAINED FINDING:** przy niezależnym reject (akceptacja zależy
    /// tylko od x, nie od sekretu) T jest **niezależne** od |x| (corr ≈ 0).
    /// Samo ujawnienie T nie zdradza wtedy wartości x — ale T jest jawne
    /// w transkrypcie (r2/r5) i zdradza **gdy** prawdopodobieństwo akceptacji
    /// zależy od sekretu (r6).
    #[test]
    fn r4_attempts_uncorrelated_with_absx_independent_reject() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xA11CE);
        let p = SamplerParams::default();
        let samples: Vec<SampleOutcome> =
            (0..2000).map(|_| sample_clear(&mut rng, &p)).collect();
        let c = corr_absx_attempts(&samples);
        assert!(
            c.abs() < 0.15,
            "independent reject: expect corr(|x|,T)≈0, got {c}"
        );
    }

    /// r6 — gdy prawdopodobieństwo sukcesu zależy od **sekretu** S,
    /// jawne T zdradza S (E[T] ≈ 256/(S+1)).
    fn sample_secret_bound(rng: &mut impl rand::RngCore, secret: u8) -> SampleOutcome {
        let mut attempts = 0u32;
        loop {
            attempts = attempts.saturating_add(1);
            let u = (rng.next_u32() & 0xFF) as u8;
            // sukces w.p. (secret+1)/256
            if u <= secret {
                return SampleOutcome {
                    x: secret as i32,
                    attempts,
                };
            }
            if attempts > 10_000 {
                return SampleOutcome {
                    x: secret as i32,
                    attempts,
                };
            }
        }
    }

    #[test]
    fn r6_attempts_leak_secret_accept_rate() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xC0FFEE6);
        // dwa sekrety o wyraźnie różnej stopie sukcesu
        let s_hi = 200u8; // p ≈ 201/256 → krótkie T
        let s_lo = 20u8; //  p ≈ 21/256 → długie T
        let mean_hi: f64 = (0..400)
            .map(|_| sample_secret_bound(&mut rng, s_hi).attempts as f64)
            .sum::<f64>()
            / 400.0;
        let mean_lo: f64 = (0..400)
            .map(|_| sample_secret_bound(&mut rng, s_lo).attempts as f64)
            .sum::<f64>()
            / 400.0;
        assert!(
            mean_hi * 2.0 < mean_lo,
            "E[T] must separate secrets: hi={mean_hi} lo={mean_lo}"
        );
    }

    #[test]
    fn r5_naive_trace_is_full_leak() {
        // jawny ślad bitów = jawne T i jawny moment sukcesu
        let mut rng = OsRng;
        let p = SamplerParams::default();
        for _ in 0..50 {
            let (out, trace) = sample_mpc_naive(&mut rng, &p);
            let t = trace.iter().take_while(|&&a| !a).count() as u32 + 1;
            assert_eq!(t, out.attempts);
        }
    }
}

// ─── Spike 007 — bias vs target + wektory deterministyczne ────────────────
//
// F-11 ustaliło: retry vs single = ten sam `x | accept`.
// **Prawdziwy** bias P0.1: rozkład zaakceptowanego `x` vs **docelowy**
// (ten sam, do którego dąży rejection). Tu mierzymy TV i max_rel_err
// `x | accept` względem PMF wagowego.

/// Docelowy PMF na |x| = 0..=w: masa ∝ (liczba punktów x z danym |x|)
/// × accept_weight(x). To jest prawo `|x|` **pod warunkiem accept** przy
/// propozycji jednostajnej i akceptacji ważonej.
pub fn target_absx_pmf(w: i32, sigma2: i32) -> Vec<f64> {
    let mut pmf = vec![0.0f64; (w + 1) as usize];
    let mut z = 0.0f64;
    for b in 0..=w {
        let count = if b == 0 { 1.0 } else { 2.0 };
        let mass = count * accept_weight_pub(b, sigma2) as f64;
        pmf[b as usize] = mass;
        z += mass;
    }
    for p in pmf.iter_mut() {
        *p /= z;
    }
    pmf
}

/// Pomiar `x|accept` vs `target_absx_pmf` (TV + max_rel_err).
#[derive(Debug, Clone)]
pub struct TargetBias {
    pub samples: u32,
    pub tv_distance: f64,
    pub max_rel_err: f64,
}

pub fn measure_vs_target(
    rng: &mut impl rand::RngCore,
    p: &SamplerParams,
    samples: u32,
) -> TargetBias {
    let mut hist = vec![0.0f64; (p.w + 1) as usize];
    let mut n = 0u32;
    for _ in 0..samples {
        if let Some((x, _)) = crate::select::clear_first_accepted(&crate::select::draw_clear_window(rng, p)) {
            hist[x.abs().min(p.w) as usize] += 1.0;
            n += 1;
        }
    }
    let target = target_absx_pmf(p.w, p.sigma2);
    let mut tv = 0.0f64;
    let mut max_rel_err = 0.0f64;
    if n > 0 {
        for b in 0..=p.w as usize {
            let emp = hist[b] / n as f64;
            let exp = target[b];
            tv += (emp - exp).abs();
            if exp > 1e-9 {
                let rel = ((emp - exp) / exp).abs();
                if rel > max_rel_err {
                    max_rel_err = rel;
                }
            }
        }
    }
    TargetBias {
        samples: n,
        tv_distance: tv / 2.0,
        max_rel_err,
    }
}

/// Deterministyczny wektor: ziarno `seed`, parametry p, pierwsze `count`
/// wyników `sample_clear` (x, attempts).
pub fn deterministic_vector(
    seed: u64,
    p: &SamplerParams,
    count: usize,
) -> Vec<SampleOutcome> {
    use rand::SeedableRng;
    let mut rng = rand::rngs::StdRng::seed_from_u64(seed);
    (0..count).map(|_| sample_clear(&mut rng, p)).collect()
}

/// Skrót wektora (FNV-1a) — pin do akt/hash-wektorów.
pub fn vector_fingerprint(v: &[SampleOutcome]) -> u64 {
    let mut h = 0xcbf29ce484222325u64;
    for s in v {
        h ^= s.x as u64 as u128 as u64;
        h = h.wrapping_mul(0x100000001b3);
        h ^= s.attempts as u64;
        h = h.wrapping_mul(0x100000001b3);
    }
    h
}

#[cfg(test)]
mod tests_s007 {
    use super::*;

    #[test]
    fn s7_target_pmf_sums_to_one() {
        let pmf = target_absx_pmf(16, 25);
        let s: f64 = pmf.iter().sum();
        assert!((s - 1.0).abs() < 1e-9, "pmf sum {s}");
        assert!(pmf.iter().all(|&p| p >= 0.0));
    }

    #[test]
    fn s7_bias_vs_target_small_tv() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xB1A501);
        let p = SamplerParams {
            w: 8,
            sigma2: 16,
            t_max: 64,
        };
        let b = measure_vs_target(&mut rng, &p, 2000);
        assert!(b.samples > 1500);
        // rejection ważone ma dążyć do target — TV nie może być duży
        assert!(
            b.tv_distance < 0.15,
            "TV vs target too large: {}",
            b.tv_distance
        );
    }

    #[test]
    fn s7_deterministic_vector_stable() {
        let p = SamplerParams {
            w: 8,
            sigma2: 16,
            t_max: 16,
        };
        let a = deterministic_vector(0x5EED_0001, &p, 8);
        let b = deterministic_vector(0x5EED_0001, &p, 8);
        assert_eq!(a, b, "same seed must reproduce");
        let fp1 = vector_fingerprint(&a);
        let fp2 = vector_fingerprint(&b);
        assert_eq!(fp1, fp2);
        // inny seed → inny wektor (statystycznie)
        let c = deterministic_vector(0x5EED_0002, &p, 8);
        assert!(a != c);
    }

    #[test]
    fn s7_vector_fingerprint_pin() {
        let p = SamplerParams {
            w: 4,
            sigma2: 9,
            t_max: 8,
        };
        let v = deterministic_vector(42, &p, 4);
        let fp = vector_fingerprint(&v);
        // twarde piny z Ziarna 42 / w=4,σ²=9,t_max=8, n=4
        assert_eq!(fp, 3040856859571456136, "sample_clear vector FNV pin");
    }
}

// ─── Spike 014 / TT-40: Klein-lite — dyskretna Gaussa ─────────────────────
//
// Waga zamiast `accept_weight`: przybliżenie exp(-x²/(2σ²)) całkowicie
// (bez `exp`): W(x) = 256 / (1 + x²/σ²)². To **nie** jest Klein 73-bit.

/// Waga Gaussa (przybliżenie, 0..256). σ² > 0.
pub fn gauss_weight_pub(x: i32, sigma2: i32) -> u32 {
    let s2 = sigma2.max(1) as i64;
    let x2 = (x as i64) * (x as i64);
    let t = 1 + x2 / s2;
    (256 / (t * t)).min(256) as u32
}

/// PMF |x| dla propozycji U{-W..W} i wagi `gauss_weight`.
pub fn target_gauss_absx_pmf(w: i32, sigma2: i32) -> Vec<f64> {
    let mut pmf = vec![0.0f64; (w + 1) as usize];
    let mut z = 0.0f64;
    for b in 0..=w {
        let count = if b == 0 { 1.0 } else { 2.0 };
        let mass = count * gauss_weight_pub(b, sigma2) as f64;
        pmf[b as usize] = mass;
        z += mass;
    }
    for p in pmf.iter_mut() {
        *p /= z.max(1e-12);
    }
    pmf
}

/// Jawny rejection z wagą Gaussa.
pub fn sample_gaussian_clear(rng: &mut impl rand::RngCore, w: i32, sigma2: i32) -> SampleOutcome {
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_pub(x, sigma2);
        let u = rng.next_u32() & 0xFF;
        if u < wt {
            return SampleOutcome { x, attempts };
        }
        if attempts > 10_000 {
            return SampleOutcome { x, attempts };
        }
    }
}

/// TV empiria vs `target_gauss_absx_pmf` (accept-conditioned).
pub fn measure_gauss_vs_target(rng: &mut impl rand::RngCore, w: i32, sigma2: i32, n: u32) -> TargetBias {
    let mut hist = vec![0.0f64; (w + 1) as usize];
    let mut got = 0u32;
    for _ in 0..n {
        let s = sample_gaussian_clear(rng, w, sigma2);
        hist[s.x.abs().min(w) as usize] += 1.0;
        got += 1;
    }
    let target = target_gauss_absx_pmf(w, sigma2);
    let mut tv = 0.0;
    let mut max_rel_err = 0.0;
    if got > 0 {
        for b in 0..=w as usize {
            let emp = hist[b] / got as f64;
            let exp = target[b];
            tv += (emp - exp).abs();
            if exp > 1e-9 {
                let rel = ((emp - exp) / exp).abs();
                if rel > max_rel_err {
                    max_rel_err = rel;
                }
            }
        }
    }
    TargetBias {
        samples: got,
        tv_distance: tv / 2.0,
        max_rel_err,
    }
}

#[cfg(test)]
mod tests_s014 {
    use super::*;

    #[test]
    fn g1_gauss_weight_decreasing() {
        let w0 = gauss_weight_pub(0, 16);
        let w4 = gauss_weight_pub(4, 16);
        let w8 = gauss_weight_pub(8, 16);
        assert!(w0 >= w4 && w4 >= w8);
    }

    #[test]
    fn g2_gaussian_sums_pmf() {
        let pmf = target_gauss_absx_pmf(16, 25);
        let s: f64 = pmf.iter().sum();
        assert!((s - 1.0).abs() < 1e-6, "sum={s}");
    }

    #[test]
    fn g3_gauss_vs_target_tv() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xBEEF);
        let b = measure_gauss_vs_target(&mut rng, 12, 36, 2000);
        assert!(b.samples > 1500);
        assert!(b.tv_distance < 0.2, "TV={}", b.tv_distance);
    }

    #[test]
    fn g4_sample_in_range() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xB1A5_01);
        for _ in 0..50 {
            let s = sample_gaussian_clear(&mut rng, 10, 20);
            assert!(s.x.abs() <= 10);
        }
    }
}

#[cfg(test)]
mod tests_gauss_edge {
    use super::*;

    #[test]
    fn gauss_w0_is_max() {
        assert_eq!(gauss_weight_pub(0, 16), 256);
    }

    #[test]
    fn sample_gauss_deterministic_seed() {
        use rand::SeedableRng;
        let mut a = rand::rngs::StdRng::seed_from_u64(1);
        let mut b = rand::rngs::StdRng::seed_from_u64(1);
        let sa = sample_gaussian_clear(&mut a, 8, 16);
        let sb = sample_gaussian_clear(&mut b, 8, 16);
        assert_eq!(sa, sb);
    }
}

// ─── X1 — Klein-lite 73-bit precision stand-in (Q16 fixed-point) ──────────
//
// **NIE jest to Klein 73-bit** (patrz X1_KLEIN_PRECISION.md). Wagi akceptacji
// jako całkowite w skali 2^16 (`GAUSS_Q_ONE`); 2^73 to motywacja precyzji exp
// z Kleina/Falcona — nie deklaracja osiągniętej precyzji. Bez `exp` i bez
// floatów w ścieżce wagi. Typy sekretów (`Share`/`MacShare`/`BeaverTriple`)
// bez `Clone` — ten tor jest jawny (oracle/pomiar) i nie dotyka udziałów.

/// Skala Q16: 1.0 ↔ `GAUSS_Q_ONE`. Wagi w [0, `GAUSS_Q_ONE`].
pub const GAUSS_Q_ONE: u64 = 1 << 16;

/// exp(-z) w Q16; `z_q16` = z · 2^16. Szereg Taylora w pośredniej Q32 (u128).
/// Bez floatów. Fail-closed: z ≳ 12 → 0 (underflow Q16); wynik clamp do Q16.
pub fn exp_neg_q16(z_q16: u64) -> u64 {
    const ONE: i128 = 1 << 16;
    // Q64 precyzja szeregu: przy z_real ~ 12 składniki sięgają ~12^k/k!
    // i u128/Q32 starcza na kancylację — retained bug X1 (W(12) > W(11)).
    const HI: i128 = 1 << 64;
    if z_q16 == 0 {
        return GAUSS_Q_ONE;
    }
    // exp(-12) ≈ 6.1e-6 < 2^-16 — dalej waga w Q16 jest zawsze 0
    if z_q16 >= 12 * GAUSS_Q_ONE {
        return 0;
    }
    let z = z_q16 as i128;
    let mut term: i128 = HI; // 1.0 w Q64
    let mut sum: i128 = HI;
    let mut k: i128 = 1;
    while k <= 60 {
        // t_k = t_{k-1} · z / k  (z w Q16 → dzielenie przez ONE)
        let Some(prod) = term.checked_mul(z) else {
            return 0; // fail-closed: przepełnienie szeregu
        };
        term = prod / (k * ONE);
        if term == 0 {
            break;
        }
        if k & 1 == 1 {
            sum -= term;
        } else {
            sum += term;
        }
        k += 1;
    }
    if sum <= 0 {
        return 0; // fail-closed: niepoprawny wynik szeregu
    }
    // Q64 → Q16 (zaokrąglenie do najbliższego, stabilne piny)
    let q = ((sum as u128) + (1u128 << 47)) >> 48;
    q.min(GAUSS_Q_ONE as u128) as u64
}

/// Waga akceptacji Q16: W(x) = 2^16 · exp(-x²/(2σ²)).
/// `sigma_q` = σ · 2^16 (Q16). Całkowicie, bez floatów.
/// Fail-closed: σ=0 → 0 (odmowa akceptacji); przepełnienie pośrednich → 0.
pub fn gauss_weight_q(x: i32, sigma_q: u64) -> u64 {
    if sigma_q == 0 {
        return 0;
    }
    let x_abs = x.unsigned_abs() as u128;
    let x2 = x_abs * x_abs;
    // z_real = x²/(2σ²); z_q16 = x² · 2^16 / (2σ²) = x² · 2^47 / σ_q²
    // (σ_q² = σ²·2^32; 2^16 · 2^32 / 2 = 2^47)
    let den = (sigma_q as u128) * (sigma_q as u128);
    if x2 > (u128::MAX >> 47) {
        return 0;
    }
    let z_q16 = (x2 << 47) / den;
    if z_q16 > u64::MAX as u128 {
        return 0;
    }
    exp_neg_q16(z_q16 as u64)
}

/// Odmowa samplera Q16 (fail-closed — bez cichej kontynuacji).
#[derive(Debug, Clone, Copy, PartialEq, Eq)]
pub enum GaussQError {
    /// σ = 0: brak sensownej Gaussy — odmowa, nie losowanie „na siłę"
    ZeroSigma,
    /// w < 1: puste ramię propozycji U{-w..=w}
    EmptyWindow,
    /// wyczerpanie limitu prób — **Err**, nigdy Ok z odrzuconym kandydatem
    AttemptsExhausted,
}

/// Jawny rejection z wagą Q16: accept iff u < W(x), u ~ U{0..2^16-1}.
/// Oracle/pomiar — bez udziałów, bez `Clone` na sekretach (brak sekretów w API).
/// Cap prób 10_000: wyczerpanie → [`GaussQError::AttemptsExhausted`] (fail-closed).
pub fn sample_gaussian_q_clear(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q: u64,
) -> Result<SampleOutcome, GaussQError> {
    if sigma_q == 0 {
        return Err(GaussQError::ZeroSigma);
    }
    if w < 1 {
        return Err(GaussQError::EmptyWindow);
    }
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_q(x, sigma_q);
        let u = (rng.next_u32() as u64) & (GAUSS_Q_ONE - 1);
        if u < wt {
            return Ok(SampleOutcome { x, attempts });
        }
        if attempts > 10_000 {
            return Err(GaussQError::AttemptsExhausted);
        }
    }
}

/// Dyskretny target |x|=0..=w w skali Q16 (suma ≈ 2^16).
/// Masa(b) ∝ multiplicity(b) × W_q(b). Brak masy → wektor zer (fail-closed,
/// nie rozkład jednostajny zamiast ciszy).
pub fn target_gaussian_q_absx_pmf_q(w: i32, sigma_q: u64) -> Vec<u64> {
    let w = w.max(0) as usize;
    let mut mass = vec![0u128; w + 1];
    let mut z = 0u128;
    for b in 0..=w {
        let count: u128 = if b == 0 { 1 } else { 2 };
        let m = count * gauss_weight_q(b as i32, sigma_q) as u128;
        mass[b] = m;
        z += m;
    }
    if z == 0 {
        return vec![0; w + 1];
    }
    let mut out = vec![0u64; w + 1];
    let mut acc = 0u64;
    for b in 0..=w {
        let p = ((mass[b] << 16) / z) as u64;
        out[b] = p;
        acc = acc.saturating_add(p);
    }
    if acc < GAUSS_Q_ONE {
        if let Some((bi, _)) = out.iter().enumerate().max_by_key(|(_, &v)| v) {
            out[bi] += GAUSS_Q_ONE - acc;
        }
    }
    out
}

/// TV empiria |x| vs `target_gaussian_q_absx_pmf_q` (accept-conditioned).
/// Statystyka na f64 (jak `measure_gauss_vs_target`) — nie ścieżka wagi.
pub fn measure_gaussian_q_vs_target(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q: u64,
    n: u32,
) -> Result<TargetBias, GaussQError> {
    if sigma_q == 0 {
        return Err(GaussQError::ZeroSigma);
    }
    if w < 1 {
        return Err(GaussQError::EmptyWindow);
    }
    let mut hist = vec![0.0f64; (w + 1) as usize];
    let mut got = 0u32;
    for _ in 0..n {
        let s = sample_gaussian_q_clear(rng, w, sigma_q)?;
        hist[s.x.abs().min(w) as usize] += 1.0;
        got += 1;
    }
    let target_q = target_gaussian_q_absx_pmf_q(w, sigma_q);
    let target: Vec<f64> = target_q
        .iter()
        .map(|&p| p as f64 / GAUSS_Q_ONE as f64)
        .collect();
    let mut tv = 0.0;
    let mut max_rel_err = 0.0;
    if got > 0 {
        for b in 0..=w as usize {
            let emp = hist[b] / got as f64;
            let exp = target[b];
            tv += (emp - exp).abs();
            if exp > 1e-9 {
                let rel = ((emp - exp) / exp).abs();
                if rel > max_rel_err {
                    max_rel_err = rel;
                }
            }
        }
    }
    Ok(TargetBias {
        samples: got,
        tv_distance: tv / 2.0,
        max_rel_err,
    })
}

/// Deterministyczny wektor Q16: pierwsze `count` wyników `sample_gaussian_q_clear`.
pub fn deterministic_vector_q(
    seed: u64,
    w: i32,
    sigma_q: u64,
    count: usize,
) -> Result<Vec<SampleOutcome>, GaussQError> {
    use rand::SeedableRng;
    let mut rng = rand::rngs::StdRng::seed_from_u64(seed);
    let mut out = Vec::with_capacity(count);
    for _ in 0..count {
        out.push(sample_gaussian_q_clear(&mut rng, w, sigma_q)?);
    }
    Ok(out)
}

/// Koszt lokalnego `gauss_weight_q` / `exp_neg_q16`: **0 Beaver, 0 reshare**
/// (arytmetyka całkowita lokalna). Dominacja toru MPC = accept_bit
/// **255 Beaver/bit** (I1, Horner P_w) — Q16 nie zmienia tej ceny.
/// Pełne zestawienie: `X1_KLEIN_PRECISION.md`.

#[cfg(test)]
mod tests_x1 {
    use super::*;

    #[test]
    fn x1_exp_neg_q16_basic() {
        assert_eq!(exp_neg_q16(0), GAUSS_Q_ONE);
        // exp(-0.5) ≈ 0.60653 · 2^16 ≈ 39744
        let half = exp_neg_q16(GAUSS_Q_ONE / 2);
        assert!(
            (39740..=39750).contains(&half),
            "exp(-0.5) Q16 = {half}"
        );
        // monotonicznie malejące
        assert!(exp_neg_q16(1000) > exp_neg_q16(10_000));
        assert!(exp_neg_q16(10_000) > exp_neg_q16(50_000));
        // underflow → 0 (fail-closed)
        assert_eq!(exp_neg_q16(12 * GAUSS_Q_ONE), 0);
        assert_eq!(exp_neg_q16(u64::MAX), 0);
    }

    #[test]
    fn x1_gauss_weight_q_x0_is_q_one() {
        assert_eq!(gauss_weight_q(0, 2 * GAUSS_Q_ONE), GAUSS_Q_ONE);
        assert_eq!(gauss_weight_q(0, 65536), GAUSS_Q_ONE);
    }

    #[test]
    fn x1_gauss_weight_q_monotone_in_absx() {
        let sigma_q = 3 * GAUSS_Q_ONE;
        let mut prev = gauss_weight_q(0, sigma_q);
        for x in 1..=24 {
            let w = gauss_weight_q(x, sigma_q);
            assert!(w <= prev, "W({x})={w} > prev={prev}");
            assert_eq!(w, gauss_weight_q(-x, sigma_q), "symetria");
            prev = w;
        }
        // znany punkt: σ=1 (sigma_q=2^16), x=1 → exp(-1/2)·2^16 ≈ 39744
        let w1 = gauss_weight_q(1, GAUSS_Q_ONE);
        assert!((39740..=39750).contains(&w1), "W(1,σ=1)={w1}");
    }

    #[test]
    fn x1_fail_closed_edges() {
        // σ=0 → waga 0 (nigdy nie akceptuj)
        assert_eq!(gauss_weight_q(0, 0), 0);
        assert_eq!(gauss_weight_q(5, 0), 0);
        // sample: ZeroSigma / EmptyWindow — odmowa, nie pętla
        let mut rng = rand::rngs::OsRng;
        assert_eq!(
            sample_gaussian_q_clear(&mut rng, 8, 0).unwrap_err(),
            GaussQError::ZeroSigma
        );
        assert_eq!(
            sample_gaussian_q_clear(&mut rng, 0, GAUSS_Q_ONE).unwrap_err(),
            GaussQError::EmptyWindow
        );
        // ogromne |x| / mikro-σ → underflow wagi = 0
        assert_eq!(gauss_weight_q(i32::MAX, 1), 0);
        // brak masy w target → zera, nie jednostajny
        let pmf = target_gaussian_q_absx_pmf_q(4, 0);
        assert!(pmf.iter().all(|&p| p == 0));
    }

    #[test]
    fn x1_sample_gaussian_q_vs_target_tv() {
        use rand::SeedableRng;
        let mut rng = rand::rngs::StdRng::seed_from_u64(0xC10_0001);
        // σ = 2.0 (sigma_q = 2·2^16), w = 8 — masa skupiona blisko 0
        let sigma_q = 2 * GAUSS_Q_ONE;
        let b = measure_gaussian_q_vs_target(&mut rng, 8, sigma_q, 3000).unwrap();
        assert!(b.samples > 2500, "samples={}", b.samples);
        assert!(
            b.tv_distance < 0.12,
            "TV vs discrete target = {}",
            b.tv_distance
        );
    }

    #[test]
    fn x1_sample_gaussian_q_deterministic() {
        let sigma_q = 2 * GAUSS_Q_ONE;
        let a = deterministic_vector_q(0x51EED, 8, sigma_q, 8).unwrap();
        let b = deterministic_vector_q(0x51EED, 8, sigma_q, 8).unwrap();
        assert_eq!(a, b, "same seed must reproduce");
        let c = deterministic_vector_q(0x51EED + 1, 8, sigma_q, 8).unwrap();
        assert!(a != c, "inny seed → inny wektor");
        // pin FNV na ziarnie 0x51EED (regresja stand-inu)
        let fp = vector_fingerprint(&a);
        assert_eq!(fp, 3753615015437430794, "x1 Q16 vector FNV pin");
    }

    #[test]
    fn x1_target_pmf_q_sums_to_q_one() {
        let pmf = target_gaussian_q_absx_pmf_q(12, 3 * GAUSS_Q_ONE);
        let s: u64 = pmf.iter().sum();
        assert_eq!(s, GAUSS_Q_ONE, "pmf Q16 sum = {s}");
        assert!(pmf.iter().all(|&p| p <= GAUSS_Q_ONE));
    }
}

// ─── Y4 — precyzja Q73 (Klein/Falcon 73-bit) + bias vs analityczna Gaussa ──
//
// Uzupełnienie X1 (Q16 stand-in) o **skalę 2^73** (u128) i pomiar biasu vs
// **analityczną** dyskretną Gausę (nie vs własną wagę). Ścieżka wagi dalej
// całkowita, bez floatów. To **nie** jest pełny algorytm Klein MPC
// (bit-by-bit Bernoulli) — to precyzja i rozliczenie biasu wymagane
// w `SECURITY_POSITION` pkt 3.

/// Skala Q73: 1.0 ↔ `GAUSS_Q73_ONE`. Wagi w [0, 2^73].
pub const GAUSS_Q73_ONE: u128 = 1u128 << 73;

/// exp(-z) w Q73; `z_q32` = z · 2^32. Szereg Taylora, term·z mieści i128.
/// Underflow: z ≳ 50 (73·ln2 ≈ 50.6) → 0. Bez floatów w ścieżce wagi.
pub fn exp_neg_q73(z_q32: u128) -> u128 {
    const ONE: i128 = 1i128 << 73;
    const Z_ONE: i128 = 1i128 << 32;
    if z_q32 == 0 {
        return GAUSS_Q73_ONE;
    }
    // z_real = z_q32 / 2^32; underflow gdy z_real ≳ 50
    if z_q32 >= 50 * Z_ONE as u128 {
        return 0;
    }
    let z = z_q32 as i128;
    let mut term: i128 = ONE;
    let mut sum: i128 = ONE;
    let mut k: i128 = 1;
    while k <= 80 {
        let Some(prod) = term.checked_mul(z) else {
            return 0;
        };
        term = prod / (k * Z_ONE);
        if term == 0 {
            break;
        }
        if k & 1 == 1 {
            sum -= term;
        } else {
            sum += term;
        }
        k += 1;
    }
    if sum <= 0 {
        return 0;
    }
    (sum as u128).min(GAUSS_Q73_ONE)
}

/// Waga akceptacji Q73: W(x) = 2^73 · exp(-x²/(2σ²)).
/// `sigma_q73` = σ · 2^73. σ redukowane do Q32 (unikamy σ² overflow u128).
/// Fail-closed: σ=0 → 0.
pub fn gauss_weight_q73(x: i32, sigma_q73: u128) -> u128 {
    if sigma_q73 == 0 {
        return 0;
    }
    // s32 = σ · 2^32 (sigma_q73 = σ·2^73 → >>41)
    let s32 = sigma_q73 >> 41;
    if s32 == 0 {
        // σ < 2^-32: tylko x=0 ma niezerową wagę
        return if x == 0 { GAUSS_Q73_ONE } else { 0 };
    }
    let x2 = (x.unsigned_abs() as u128) * (x.unsigned_abs() as u128);
    // z_real = x²/(2σ²); σ = s32/2^32
    // z_real = x2·2^64 / (2·s32²) = x2·2^63 / s32²
    // z_q32 = z_real·2^32 = x2·2^95 / s32²
    let den = s32.checked_mul(s32);
    let Some(den2) = den else {
        return 0;
    };
    if x2 > (u128::MAX >> 95) {
        return 0;
    }
    let z_q32 = (x2 << 95) / den2;
    exp_neg_q73(z_q32)
}

/// Jednostajne U{0..2^73-1} z RNG (dla accept iff u < W).
pub fn uniform_q73_pub(rng: &mut impl rand::RngCore) -> u128 {
    let hi = rng.next_u64() as u128;
    let lo = rng.next_u64() as u128;
    ((hi << 9) | (lo >> 55)) & ((1u128 << 73) - 1)
}

/// Jawny rejection z wagą Q73: accept iff u < W(x), u ~ U{0..2^73-1}.
/// Cap prób 10_000: wyczerpanie → [`GaussQError::AttemptsExhausted`] (fail-closed).
pub fn sample_gaussian_q73_clear(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
) -> Result<SampleOutcome, GaussQError> {
    if sigma_q73 == 0 {
        return Err(GaussQError::ZeroSigma);
    }
    if w < 1 {
        return Err(GaussQError::EmptyWindow);
    }
    let mut attempts = 0u32;
    loop {
        attempts = attempts.saturating_add(1);
        let x = uniform_range_pub(rng, -w, w);
        let wt = gauss_weight_q73(x, sigma_q73);
        let u = uniform_q73_pub(rng);
        if u < wt {
            return Ok(SampleOutcome { x, attempts });
        }
        if attempts > 10_000 {
            return Err(GaussQError::AttemptsExhausted);
        }
    }
}

/// Analityczny target dyskretnej Gaussy |x|=0..=w (f64 — **tylko pomiar**,
/// nie ścieżka wagi). p(b) ∝ mult(b)·exp(-b²/(2σ²)).
pub fn target_gaussian_analytical_absx_pmf(w: i32, sigma: f64) -> Vec<f64> {
    let w = w.max(0) as usize;
    if !(sigma > 0.0) {
        return vec![0.0; w + 1];
    }
    let mut mass = vec![0.0f64; w + 1];
    let mut z = 0.0f64;
    for b in 0..=w {
        let count = if b == 0 { 1.0 } else { 2.0 };
        let m = count * (-(b as f64 * b as f64) / (2.0 * sigma * sigma)).exp();
        mass[b] = m;
        z += m;
    }
    if z <= 0.0 {
        return vec![0.0; w + 1];
    }
    mass.iter().map(|&m| m / z).collect()
}

/// TV empiria |x| vs **analityczna** dyskretna Gaussa (P0.1 — bias vs target,
/// nie vs własna waga). Statystyka na f64 (A6).
pub fn measure_gaussian_q73_vs_analytical(
    rng: &mut impl rand::RngCore,
    w: i32,
    sigma_q73: u128,
    sigma_real: f64,
    n: u32,
) -> Result<TargetBias, GaussQError> {
    if sigma_q73 == 0 {
        return Err(GaussQError::ZeroSigma);
    }
    if w < 1 {
        return Err(GaussQError::EmptyWindow);
    }
    let mut hist = vec![0.0f64; (w + 1) as usize];
    let mut got = 0u32;
    for _ in 0..n {
        let s = sample_gaussian_q73_clear(rng, w, sigma_q73)?;
        hist[s.x.abs().min(w) as usize] += 1.0;
        got += 1;
    }
    let target = target_gaussian_analytical_absx_pmf(w, sigma_real);
    let mut tv = 0.0f64;
    let mut max_rel_err = 0.0f64;
    if got > 0 {
        for b in 0..=w as usize {
            let emp = hist[b] / got as f64;
            let exp = target[b];
            tv += (emp - exp).abs();
            if exp > 1e-9 {
                let rel = ((emp - exp) / exp).abs();
                if rel > max_rel_err {
                    max_rel_err = rel;
                }
            }
        }
    }
    Ok(TargetBias {
        samples: got,
        tv_distance: tv / 2.0,
        max_rel_err,
    })
}

#[cfg(test)]
mod tests_y4_q73 {
    use super::*;
    use rand::SeedableRng;

    #[test]
    fn y4_exp_neg_q73_basic() {
        assert_eq!(exp_neg_q73(0), GAUSS_Q73_ONE);
        // exp(-0.5)·2^73; z_q32 = 0.5·2^32
        let half = exp_neg_q73(1u128 << 31);
        let expect = (0.6065306597126334 * (GAUSS_Q73_ONE as f64)) as u128;
        let diff = half.abs_diff(expect);
        assert!(diff < (1u128 << 55), "exp(-0.5) Q73 = {half} vs {expect}");
        assert!(exp_neg_q73(1u128 << 32) < half);
        assert_eq!(exp_neg_q73(50 * (1u128 << 32)), 0);
    }

    #[test]
    fn y4_weight_q73_monotone_and_symmetric() {
        let sigma = 3 * GAUSS_Q73_ONE;
        let mut prev = gauss_weight_q73(0, sigma);
        assert_eq!(prev, GAUSS_Q73_ONE);
        for x in 1..=20 {
            let w = gauss_weight_q73(x, sigma);
            assert!(w <= prev, "W({x}) > prev");
            assert_eq!(w, gauss_weight_q73(-x, sigma));
            prev = w;
        }
        assert_eq!(gauss_weight_q73(0, 0), 0);
    }

    #[test]
    fn y4_weight_matches_f64_exp_grid() {
        // W(x)/2^73 ≈ exp(-x²/(2σ²)) na siatce σ=2, |x|≤8
        let sigma_q73 = 2 * GAUSS_Q73_ONE;
        let expect = [
            1.0,
            0.8824969025845955,
            0.6065306597126334,
            0.32465246735834974,
            0.1353352832366127,
            0.04393693362340742,
            0.011108996538242306,
            0.002187491118182885,
            0.00033546262790251185,
        ];
        for (x, &e) in expect.iter().enumerate() {
            let w = gauss_weight_q73(x as i32, sigma_q73);
            let got = w as f64 / GAUSS_Q73_ONE as f64;
            let err = (got - e).abs();
            assert!(err < 1e-6, "W({x})={got} vs exp {e} (err={err})");
        }
    }

    #[test]
    fn y4_sample_vs_analytical_tv() {
        let mut rng = rand::rngs::StdRng::seed_from_u64(0x54_0001);
        let sigma_q73 = 2 * GAUSS_Q73_ONE;
        // n=4000: TV empiria vs analityka ma szum ~1/sqrt(n)
        let b = measure_gaussian_q73_vs_analytical(&mut rng, 8, sigma_q73, 2.0, 4000).unwrap();
        assert!(b.samples > 3500, "samples={}", b.samples);
        assert!(
            b.tv_distance < 0.12,
            "TV vs analytical Gauss = {}",
            b.tv_distance
        );
    }

    #[test]
    fn y4_fail_closed_edges() {
        let mut rng = rand::rngs::OsRng;
        assert_eq!(
            sample_gaussian_q73_clear(&mut rng, 8, 0).unwrap_err(),
            GaussQError::ZeroSigma
        );
        assert_eq!(
            sample_gaussian_q73_clear(&mut rng, 0, GAUSS_Q73_ONE).unwrap_err(),
            GaussQError::EmptyWindow
        );
        assert_eq!(gauss_weight_q73(i32::MAX, 1), 0);
        let z = target_gaussian_analytical_absx_pmf(4, 0.0);
        assert!(z.iter().all(|&p| p == 0.0));
    }

    #[test]
    fn y4_analytical_pmf_sums_to_one() {
        let pmf = target_gaussian_analytical_absx_pmf(12, 3.0);
        let s: f64 = pmf.iter().sum();
        assert!((s - 1.0).abs() < 1e-9, "sum={s}");
    }

    #[test]
    fn y4_deterministic_seed() {
        let sigma = 2 * GAUSS_Q73_ONE;
        let mut a = rand::rngs::StdRng::seed_from_u64(0x54_0002);
        let mut b = rand::rngs::StdRng::seed_from_u64(0x54_0002);
        let sa = sample_gaussian_q73_clear(&mut a, 6, sigma).unwrap();
        let sb = sample_gaussian_q73_clear(&mut b, 6, sigma).unwrap();
        assert_eq!(sa.x, sb.x);
        assert_eq!(sa.attempts, sb.attempts);
    }
}

/// T13 #16 — reject fail-open + modulo bias (naprawa realnego buga).
#[cfg(test)]
mod tests_t13_reject_fail_open {
    use super::*;
    use rand::rngs::StdRng;
    use rand::{RngCore, SeedableRng};

    /// RNG zwracający stałą 2 — kandydat ≠ 0 i małe u → wyczerpanie przy
    /// σ takim, że tylko x=0 ma niezerową wagę.
    struct ConstRng(u32);

    impl RngCore for ConstRng {
        fn next_u32(&mut self) -> u32 {
            self.0
        }
        fn next_u64(&mut self) -> u64 {
            self.0 as u64
        }
        fn fill_bytes(&mut self, dest: &mut [u8]) {
            for b in dest {
                *b = self.0 as u8;
            }
        }
        fn try_fill_bytes(&mut self, dest: &mut [u8]) -> Result<(), rand::Error> {
            self.fill_bytes(dest);
            Ok(())
        }
    }

    #[test]
    fn t13_uniform_range_no_modulo_bias() {
        // span=3: bias u32%3 dałby ~1.5× nadreprezentację reszty 0
        // przy starym kodzie na ograniczonej próbce z małego RNG.
        // Tu: rozkład empiryczny bliski 1/3 na każdej z 3 wartości.
        let mut rng = StdRng::seed_from_u64(0x13_16_00_01);
        let n = 30_000u32;
        let mut hist = [0u32; 3];
        for _ in 0..n {
            let v = uniform_range_pub(&mut rng, 0, 2);
            assert!((0..=2).contains(&v));
            hist[v as usize] += 1;
        }
        let expect = n as f64 / 3.0;
        for (i, &c) in hist.iter().enumerate() {
            let rel = (c as f64 - expect).abs() / expect;
            assert!(rel < 0.05, "bin {i}: count={c} expect={expect} rel={rel}");
        }
    }

    #[test]
    fn t13_uniform_range_covers_span() {
        let mut rng = StdRng::seed_from_u64(0x13_16_00_02);
        let mut seen = [false; 17];
        for _ in 0..20_000 {
            let v = uniform_range_pub(&mut rng, -8, 8);
            assert!((-8..=8).contains(&v));
            seen[(v + 8) as usize] = true;
        }
        assert!(seen.iter().all(|&s| s), "każda wartość [-8,8] osiągalna");
    }

    #[test]
    fn t13_q16_exhaustion_is_err() {
        // σ_q=1: tylko x=0 ma wagę > 0; ConstRng(2) daje x≠0 → cap → Err
        let mut rng = ConstRng(2);
        assert_eq!(
            sample_gaussian_q_clear(&mut rng, 8, 1),
            Err(GaussQError::AttemptsExhausted),
            "wyczerpanie Q16 → Err, nie Ok z odrzuconym kandydatem"
        );
    }

    #[test]
    fn t13_q73_exhaustion_is_err() {
        // σ_q73=1: s32=0 → waga 0 dla x≠0; ConstRng(2) → x≠0 → Err
        let mut rng = ConstRng(2);
        assert_eq!(
            sample_gaussian_q73_clear(&mut rng, 8, 1),
            Err(GaussQError::AttemptsExhausted),
            "wyczerpanie Q73 → Err, nie Ok z odrzuconym kandydatem"
        );
    }

    #[test]
    fn t13_q73_honest_path_still_ok() {
        let mut rng = StdRng::seed_from_u64(0x13_16_00_03);
        let s = sample_gaussian_q73_clear(&mut rng, 8, 2 * GAUSS_Q73_ONE).unwrap();
        assert!((-8..=8).contains(&s.x));
        assert!(s.attempts >= 1);
    }
}
