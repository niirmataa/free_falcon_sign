import Source3.KeygenRev10

set_option maxRecDepth 32768
set_option maxHeartbeats 2000000

/- REV10 exactness certificate (B1.03), v4: checked-chunk decomposition
   (traps 34/45 — one kernel decide never re-parses more than 8 pinned table
   lines; the glue never re-parses at all). Model side: 32 kernel-decided
   32-entry chunks against `bitrev10` (validated green in job
   keygen_rev10_cert_003) plus the descending tail ladder. Source side: 11
   slice decides (`sNN`, at most 8 pinned lines each — measured granularity,
   probes keygen_rev10_probe_001/002) binding the literal `rowsNN` candidates
   to the pinned parse, a `mapM`/`flatten` glue over the slice facts through
   intermediate statements (`region_split`, `mapM_join`, `flat_lit`), and the
   assembly `rawTable = some ((List.range 1024).map bitrev10)`. The literal
   candidates (`tableData`, `rowsNN`) are generator output (untrusted); every
   one of them is re-checked by the kernel here. Retained failed attempts:
   jobs keygen_rev10_cert_001..003, keygen_rev10_probe_001/002. -/

namespace FT1536.Source3.KeygenRev10Cert
open KeygenRev10

def tableData : List Nat :=
  [0, 512, 256, 768, 128, 640, 384, 896, 64, 576, 320, 832, 192, 704, 448, 960, 32, 544, 288, 800, 160, 672, 416, 928, 96, 608, 352, 864, 224, 736, 480, 992, 16, 528, 272, 784, 144, 656, 400, 912, 80, 592, 336, 848, 208, 720, 464, 976, 48, 560, 304, 816, 176, 688, 432, 944, 112, 624, 368, 880, 240, 752, 496, 1008, 8, 520, 264, 776, 136, 648, 392, 904, 72, 584, 328, 840, 200, 712, 456, 968, 40, 552, 296, 808, 168, 680, 424, 936, 104, 616, 360, 872, 232, 744, 488, 1000, 24, 536, 280, 792, 152, 664, 408, 920, 88, 600, 344, 856, 216, 728, 472, 984, 56, 568, 312, 824, 184, 696, 440, 952, 120, 632, 376, 888, 248, 760, 504, 1016, 4, 516, 260, 772, 132, 644, 388, 900, 68, 580, 324, 836, 196, 708, 452, 964, 36, 548, 292, 804, 164, 676, 420, 932, 100, 612, 356, 868, 228, 740, 484, 996, 20, 532, 276, 788, 148, 660, 404, 916, 84, 596, 340, 852, 212, 724, 468, 980, 52, 564, 308, 820, 180, 692, 436, 948, 116, 628, 372, 884, 244, 756, 500, 1012, 12, 524, 268, 780, 140, 652, 396, 908, 76, 588, 332, 844, 204, 716, 460, 972, 44, 556, 300, 812, 172, 684, 428, 940, 108, 620, 364, 876, 236, 748, 492, 1004, 28, 540, 284, 796, 156, 668, 412, 924, 92, 604, 348, 860, 220, 732, 476, 988, 60, 572, 316, 828, 188, 700, 444, 956, 124, 636, 380, 892, 252, 764, 508, 1020, 2, 514, 258, 770, 130, 642, 386, 898, 66, 578, 322, 834, 194, 706, 450, 962, 34, 546, 290, 802, 162, 674, 418, 930, 98, 610, 354, 866, 226, 738, 482, 994, 18, 530, 274, 786, 146, 658, 402, 914, 82, 594, 338, 850, 210, 722, 466, 978, 50, 562, 306, 818, 178, 690, 434, 946, 114, 626, 370, 882, 242, 754, 498, 1010, 10, 522, 266, 778, 138, 650, 394, 906, 74, 586, 330, 842, 202, 714, 458, 970, 42, 554, 298, 810, 170, 682, 426, 938, 106, 618, 362, 874, 234, 746, 490, 1002, 26, 538, 282, 794, 154, 666, 410, 922, 90, 602, 346, 858, 218, 730, 474, 986, 58, 570, 314, 826, 186, 698, 442, 954, 122, 634, 378, 890, 250, 762, 506, 1018, 6, 518, 262, 774, 134, 646, 390, 902, 70, 582, 326, 838, 198, 710, 454, 966, 38, 550, 294, 806, 166, 678, 422, 934, 102, 614, 358, 870, 230, 742, 486, 998, 22, 534, 278, 790, 150, 662, 406, 918, 86, 598, 342, 854, 214, 726, 470, 982, 54, 566, 310, 822, 182, 694, 438, 950, 118, 630, 374, 886, 246, 758, 502, 1014, 14, 526, 270, 782, 142, 654, 398, 910, 78, 590, 334, 846, 206, 718, 462, 974, 46, 558, 302, 814, 174, 686, 430, 942, 110, 622, 366, 878, 238, 750, 494, 1006, 30, 542, 286, 798, 158, 670, 414, 926, 94, 606, 350, 862, 222, 734, 478, 990, 62, 574, 318, 830, 190, 702, 446, 958, 126, 638, 382, 894, 254, 766, 510, 1022, 1, 513, 257, 769, 129, 641, 385, 897, 65, 577, 321, 833, 193, 705, 449, 961, 33, 545, 289, 801, 161, 673, 417, 929, 97, 609, 353, 865, 225, 737, 481, 993, 17, 529, 273, 785, 145, 657, 401, 913, 81, 593, 337, 849, 209, 721, 465, 977, 49, 561, 305, 817, 177, 689, 433, 945, 113, 625, 369, 881, 241, 753, 497, 1009, 9, 521, 265, 777, 137, 649, 393, 905, 73, 585, 329, 841, 201, 713, 457, 969, 41, 553, 297, 809, 169, 681, 425, 937, 105, 617, 361, 873, 233, 745, 489, 1001, 25, 537, 281, 793, 153, 665, 409, 921, 89, 601, 345, 857, 217, 729, 473, 985, 57, 569, 313, 825, 185, 697, 441, 953, 121, 633, 377, 889, 249, 761, 505, 1017, 5, 517, 261, 773, 133, 645, 389, 901, 69, 581, 325, 837, 197, 709, 453, 965, 37, 549, 293, 805, 165, 677, 421, 933, 101, 613, 357, 869, 229, 741, 485, 997, 21, 533, 277, 789, 149, 661, 405, 917, 85, 597, 341, 853, 213, 725, 469, 981, 53, 565, 309, 821, 181, 693, 437, 949, 117, 629, 373, 885, 245, 757, 501, 1013, 13, 525, 269, 781, 141, 653, 397, 909, 77, 589, 333, 845, 205, 717, 461, 973, 45, 557, 301, 813, 173, 685, 429, 941, 109, 621, 365, 877, 237, 749, 493, 1005, 29, 541, 285, 797, 157, 669, 413, 925, 93, 605, 349, 861, 221, 733, 477, 989, 61, 573, 317, 829, 189, 701, 445, 957, 125, 637, 381, 893, 253, 765, 509, 1021, 3, 515, 259, 771, 131, 643, 387, 899, 67, 579, 323, 835, 195, 707, 451, 963, 35, 547, 291, 803, 163, 675, 419, 931, 99, 611, 355, 867, 227, 739, 483, 995, 19, 531, 275, 787, 147, 659, 403, 915, 83, 595, 339, 851, 211, 723, 467, 979, 51, 563, 307, 819, 179, 691, 435, 947, 115, 627, 371, 883, 243, 755, 499, 1011, 11, 523, 267, 779, 139, 651, 395, 907, 75, 587, 331, 843, 203, 715, 459, 971, 43, 555, 299, 811, 171, 683, 427, 939, 107, 619, 363, 875, 235, 747, 491, 1003, 27, 539, 283, 795, 155, 667, 411, 923, 91, 603, 347, 859, 219, 731, 475, 987, 59, 571, 315, 827, 187, 699, 443, 955, 123, 635, 379, 891, 251, 763, 507, 1019, 7, 519, 263, 775, 135, 647, 391, 903, 71, 583, 327, 839, 199, 711, 455, 967, 39, 551, 295, 807, 167, 679, 423, 935, 103, 615, 359, 871, 231, 743, 487, 999, 23, 535, 279, 791, 151, 663, 407, 919, 87, 599, 343, 855, 215, 727, 471, 983, 55, 567, 311, 823, 183, 695, 439, 951, 119, 631, 375, 887, 247, 759, 503, 1015, 15, 527, 271, 783, 143, 655, 399, 911, 79, 591, 335, 847, 207, 719, 463, 975, 47, 559, 303, 815, 175, 687, 431, 943, 111, 623, 367, 879, 239, 751, 495, 1007, 31, 543, 287, 799, 159, 671, 415, 927, 95, 607, 351, 863, 223, 735, 479, 991, 63, 575, 319, 831, 191, 703, 447, 959, 127, 639, 383, 895, 255, 767, 511, 1023]

/- Self-contained glue helpers (core List facts only). -/
theorem map_range_ext {β : Type} (f g : Nat → β) (b : Nat) (h : ∀ j, f j = g j) :
    ((List.range b).map f) = ((List.range b).map g) := by
  induction b with
  | zero => rfl
  | succ n ih =>
      rw [List.range_succ, List.map_append, List.map_append,
        List.map_singleton, List.map_singleton, ih, h n]

theorem map_split {β : Type} (f : Nat → β) (a : Nat) : ∀ b,
    ((List.range (a + b)).map f) =
      (List.range a).map f ++ ((List.range b).map (fun j => f (a + j))) := by
  intro b
  induction b with
  | zero =>
      have key0 : a + Nat.zero = a := Nat.add_zero a
      rw [key0]
      show (List.range a).map f = (List.range a).map f ++ ((List.range 0).map (fun j => f (a + j)))
      exact (List.append_nil _).symm
  | succ n ih =>
      have key1 : a + Nat.succ n = Nat.succ (a + n) := Nat.add_succ a n
      rw [key1, List.range_succ, List.map_append, List.map_singleton]
      rw [List.range_succ, List.map_append, List.map_singleton, ih]
      exact List.append_assoc _ _ _

theorem eq_of_split {α : Type} (t u : List α) (k : Nat)
    (head : t.take k = u.take k) (rest : t.drop k = u.drop k) : t = u := by
  rw [← List.take_append_drop k t, ← List.take_append_drop k u, head, rest]

/-- Slice decomposition of `take` over `b + c`. `Nat.add` recurses on its
   second argument, so the induction is on `b` with `Nat.zero_add`/
   `Nat.succ_add` normalization and constructor-reducing continuation. -/
theorem take_split {α : Type} (b : Nat) : ∀ (xs : List α) (c : Nat),
    xs.take (b + c) = xs.take b ++ (xs.drop b).take c := by
  induction b with
  | zero =>
      intro xs c
      rw [Nat.zero_add]
      rfl
  | succ n ih =>
      intro xs c
      rw [Nat.succ_add]
      cases xs with
      | nil => simp only [List.drop_nil, List.take_nil, List.nil_append]
      | cons x xs => exact congrArg (List.cons x) (ih xs c)

/- Model side: 32 kernel-decided chunks against bitrev10. -/
theorem chunk00 : (tableData.drop 0).take 32 =
    (List.range 32).map (fun j => bitrev10 (0 + j)) := by decide

theorem chunk01 : (tableData.drop 32).take 32 =
    (List.range 32).map (fun j => bitrev10 (32 + j)) := by decide

theorem chunk02 : (tableData.drop 64).take 32 =
    (List.range 32).map (fun j => bitrev10 (64 + j)) := by decide

theorem chunk03 : (tableData.drop 96).take 32 =
    (List.range 32).map (fun j => bitrev10 (96 + j)) := by decide

theorem chunk04 : (tableData.drop 128).take 32 =
    (List.range 32).map (fun j => bitrev10 (128 + j)) := by decide

theorem chunk05 : (tableData.drop 160).take 32 =
    (List.range 32).map (fun j => bitrev10 (160 + j)) := by decide

theorem chunk06 : (tableData.drop 192).take 32 =
    (List.range 32).map (fun j => bitrev10 (192 + j)) := by decide

theorem chunk07 : (tableData.drop 224).take 32 =
    (List.range 32).map (fun j => bitrev10 (224 + j)) := by decide

theorem chunk08 : (tableData.drop 256).take 32 =
    (List.range 32).map (fun j => bitrev10 (256 + j)) := by decide

theorem chunk09 : (tableData.drop 288).take 32 =
    (List.range 32).map (fun j => bitrev10 (288 + j)) := by decide

theorem chunk10 : (tableData.drop 320).take 32 =
    (List.range 32).map (fun j => bitrev10 (320 + j)) := by decide

theorem chunk11 : (tableData.drop 352).take 32 =
    (List.range 32).map (fun j => bitrev10 (352 + j)) := by decide

theorem chunk12 : (tableData.drop 384).take 32 =
    (List.range 32).map (fun j => bitrev10 (384 + j)) := by decide

theorem chunk13 : (tableData.drop 416).take 32 =
    (List.range 32).map (fun j => bitrev10 (416 + j)) := by decide

theorem chunk14 : (tableData.drop 448).take 32 =
    (List.range 32).map (fun j => bitrev10 (448 + j)) := by decide

theorem chunk15 : (tableData.drop 480).take 32 =
    (List.range 32).map (fun j => bitrev10 (480 + j)) := by decide

theorem chunk16 : (tableData.drop 512).take 32 =
    (List.range 32).map (fun j => bitrev10 (512 + j)) := by decide

theorem chunk17 : (tableData.drop 544).take 32 =
    (List.range 32).map (fun j => bitrev10 (544 + j)) := by decide

theorem chunk18 : (tableData.drop 576).take 32 =
    (List.range 32).map (fun j => bitrev10 (576 + j)) := by decide

theorem chunk19 : (tableData.drop 608).take 32 =
    (List.range 32).map (fun j => bitrev10 (608 + j)) := by decide

theorem chunk20 : (tableData.drop 640).take 32 =
    (List.range 32).map (fun j => bitrev10 (640 + j)) := by decide

theorem chunk21 : (tableData.drop 672).take 32 =
    (List.range 32).map (fun j => bitrev10 (672 + j)) := by decide

theorem chunk22 : (tableData.drop 704).take 32 =
    (List.range 32).map (fun j => bitrev10 (704 + j)) := by decide

theorem chunk23 : (tableData.drop 736).take 32 =
    (List.range 32).map (fun j => bitrev10 (736 + j)) := by decide

theorem chunk24 : (tableData.drop 768).take 32 =
    (List.range 32).map (fun j => bitrev10 (768 + j)) := by decide

theorem chunk25 : (tableData.drop 800).take 32 =
    (List.range 32).map (fun j => bitrev10 (800 + j)) := by decide

theorem chunk26 : (tableData.drop 832).take 32 =
    (List.range 32).map (fun j => bitrev10 (832 + j)) := by decide

theorem chunk27 : (tableData.drop 864).take 32 =
    (List.range 32).map (fun j => bitrev10 (864 + j)) := by decide

theorem chunk28 : (tableData.drop 896).take 32 =
    (List.range 32).map (fun j => bitrev10 (896 + j)) := by decide

theorem chunk29 : (tableData.drop 928).take 32 =
    (List.range 32).map (fun j => bitrev10 (928 + j)) := by decide

theorem chunk30 : (tableData.drop 960).take 32 =
    (List.range 32).map (fun j => bitrev10 (960 + j)) := by decide

theorem chunk31 : (tableData.drop 992).take 32 =
    (List.range 32).map (fun j => bitrev10 (992 + j)) := by decide


/- Source side: the pinned parse in 11 slices of at most 8 lines each
   (measured kernel granularity, probe keygen_rev10_probe_002) plus a
   mapM/flatten glue that never re-parses. rowsNN are untrusted literal
   candidates; each sNN decide re-parses only its own slice. -/

def rawTail : List String := Pinned.keygenLines.drop 2673

def region : List String := rawTail.take 86

def sl00 : List String := rawTail.take 8
def sl01 : List String := (rawTail.drop 8).take 8
def sl02 : List String := ((rawTail.drop 8).drop 8).take 8
def sl03 : List String := (((rawTail.drop 8).drop 8).drop 8).take 8
def sl04 : List String := ((((rawTail.drop 8).drop 8).drop 8).drop 8).take 8
def sl05 : List String := (((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).take 8
def sl06 : List String := ((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 8
def sl07 : List String := (((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 8
def sl08 : List String := ((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 8
def sl09 : List String := (((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 8
def sl10 : List String := ((((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 6

def rows00 : List (List Nat) :=
    [[0, 512, 256, 768, 128, 640, 384, 896, 64, 576, 320, 832],
    [192, 704, 448, 960, 32, 544, 288, 800, 160, 672, 416, 928],
    [96, 608, 352, 864, 224, 736, 480, 992, 16, 528, 272, 784],
    [144, 656, 400, 912, 80, 592, 336, 848, 208, 720, 464, 976],
    [48, 560, 304, 816, 176, 688, 432, 944, 112, 624, 368, 880],
    [240, 752, 496, 1008, 8, 520, 264, 776, 136, 648, 392, 904],
    [72, 584, 328, 840, 200, 712, 456, 968, 40, 552, 296, 808],
    [168, 680, 424, 936, 104, 616, 360, 872, 232, 744, 488, 1000]]
def rows01 : List (List Nat) :=
    [[24, 536, 280, 792, 152, 664, 408, 920, 88, 600, 344, 856],
    [216, 728, 472, 984, 56, 568, 312, 824, 184, 696, 440, 952],
    [120, 632, 376, 888, 248, 760, 504, 1016, 4, 516, 260, 772],
    [132, 644, 388, 900, 68, 580, 324, 836, 196, 708, 452, 964],
    [36, 548, 292, 804, 164, 676, 420, 932, 100, 612, 356, 868],
    [228, 740, 484, 996, 20, 532, 276, 788, 148, 660, 404, 916],
    [84, 596, 340, 852, 212, 724, 468, 980, 52, 564, 308, 820],
    [180, 692, 436, 948, 116, 628, 372, 884, 244, 756, 500, 1012]]
def rows02 : List (List Nat) :=
    [[12, 524, 268, 780, 140, 652, 396, 908, 76, 588, 332, 844],
    [204, 716, 460, 972, 44, 556, 300, 812, 172, 684, 428, 940],
    [108, 620, 364, 876, 236, 748, 492, 1004, 28, 540, 284, 796],
    [156, 668, 412, 924, 92, 604, 348, 860, 220, 732, 476, 988],
    [60, 572, 316, 828, 188, 700, 444, 956, 124, 636, 380, 892],
    [252, 764, 508, 1020, 2, 514, 258, 770, 130, 642, 386, 898],
    [66, 578, 322, 834, 194, 706, 450, 962, 34, 546, 290, 802],
    [162, 674, 418, 930, 98, 610, 354, 866, 226, 738, 482, 994]]
def rows03 : List (List Nat) :=
    [[18, 530, 274, 786, 146, 658, 402, 914, 82, 594, 338, 850],
    [210, 722, 466, 978, 50, 562, 306, 818, 178, 690, 434, 946],
    [114, 626, 370, 882, 242, 754, 498, 1010, 10, 522, 266, 778],
    [138, 650, 394, 906, 74, 586, 330, 842, 202, 714, 458, 970],
    [42, 554, 298, 810, 170, 682, 426, 938, 106, 618, 362, 874],
    [234, 746, 490, 1002, 26, 538, 282, 794, 154, 666, 410, 922],
    [90, 602, 346, 858, 218, 730, 474, 986, 58, 570, 314, 826],
    [186, 698, 442, 954, 122, 634, 378, 890, 250, 762, 506, 1018]]
def rows04 : List (List Nat) :=
    [[6, 518, 262, 774, 134, 646, 390, 902, 70, 582, 326, 838],
    [198, 710, 454, 966, 38, 550, 294, 806, 166, 678, 422, 934],
    [102, 614, 358, 870, 230, 742, 486, 998, 22, 534, 278, 790],
    [150, 662, 406, 918, 86, 598, 342, 854, 214, 726, 470, 982],
    [54, 566, 310, 822, 182, 694, 438, 950, 118, 630, 374, 886],
    [246, 758, 502, 1014, 14, 526, 270, 782, 142, 654, 398, 910],
    [78, 590, 334, 846, 206, 718, 462, 974, 46, 558, 302, 814],
    [174, 686, 430, 942, 110, 622, 366, 878, 238, 750, 494, 1006]]
def rows05 : List (List Nat) :=
    [[30, 542, 286, 798, 158, 670, 414, 926, 94, 606, 350, 862],
    [222, 734, 478, 990, 62, 574, 318, 830, 190, 702, 446, 958],
    [126, 638, 382, 894, 254, 766, 510, 1022, 1, 513, 257, 769],
    [129, 641, 385, 897, 65, 577, 321, 833, 193, 705, 449, 961],
    [33, 545, 289, 801, 161, 673, 417, 929, 97, 609, 353, 865],
    [225, 737, 481, 993, 17, 529, 273, 785, 145, 657, 401, 913],
    [81, 593, 337, 849, 209, 721, 465, 977, 49, 561, 305, 817],
    [177, 689, 433, 945, 113, 625, 369, 881, 241, 753, 497, 1009]]
def rows06 : List (List Nat) :=
    [[9, 521, 265, 777, 137, 649, 393, 905, 73, 585, 329, 841],
    [201, 713, 457, 969, 41, 553, 297, 809, 169, 681, 425, 937],
    [105, 617, 361, 873, 233, 745, 489, 1001, 25, 537, 281, 793],
    [153, 665, 409, 921, 89, 601, 345, 857, 217, 729, 473, 985],
    [57, 569, 313, 825, 185, 697, 441, 953, 121, 633, 377, 889],
    [249, 761, 505, 1017, 5, 517, 261, 773, 133, 645, 389, 901],
    [69, 581, 325, 837, 197, 709, 453, 965, 37, 549, 293, 805],
    [165, 677, 421, 933, 101, 613, 357, 869, 229, 741, 485, 997]]
def rows07 : List (List Nat) :=
    [[21, 533, 277, 789, 149, 661, 405, 917, 85, 597, 341, 853],
    [213, 725, 469, 981, 53, 565, 309, 821, 181, 693, 437, 949],
    [117, 629, 373, 885, 245, 757, 501, 1013, 13, 525, 269, 781],
    [141, 653, 397, 909, 77, 589, 333, 845, 205, 717, 461, 973],
    [45, 557, 301, 813, 173, 685, 429, 941, 109, 621, 365, 877],
    [237, 749, 493, 1005, 29, 541, 285, 797, 157, 669, 413, 925],
    [93, 605, 349, 861, 221, 733, 477, 989, 61, 573, 317, 829],
    [189, 701, 445, 957, 125, 637, 381, 893, 253, 765, 509, 1021]]
def rows08 : List (List Nat) :=
    [[3, 515, 259, 771, 131, 643, 387, 899, 67, 579, 323, 835],
    [195, 707, 451, 963, 35, 547, 291, 803, 163, 675, 419, 931],
    [99, 611, 355, 867, 227, 739, 483, 995, 19, 531, 275, 787],
    [147, 659, 403, 915, 83, 595, 339, 851, 211, 723, 467, 979],
    [51, 563, 307, 819, 179, 691, 435, 947, 115, 627, 371, 883],
    [243, 755, 499, 1011, 11, 523, 267, 779, 139, 651, 395, 907],
    [75, 587, 331, 843, 203, 715, 459, 971, 43, 555, 299, 811],
    [171, 683, 427, 939, 107, 619, 363, 875, 235, 747, 491, 1003]]
def rows09 : List (List Nat) :=
    [[27, 539, 283, 795, 155, 667, 411, 923, 91, 603, 347, 859],
    [219, 731, 475, 987, 59, 571, 315, 827, 187, 699, 443, 955],
    [123, 635, 379, 891, 251, 763, 507, 1019, 7, 519, 263, 775],
    [135, 647, 391, 903, 71, 583, 327, 839, 199, 711, 455, 967],
    [39, 551, 295, 807, 167, 679, 423, 935, 103, 615, 359, 871],
    [231, 743, 487, 999, 23, 535, 279, 791, 151, 663, 407, 919],
    [87, 599, 343, 855, 215, 727, 471, 983, 55, 567, 311, 823],
    [183, 695, 439, 951, 119, 631, 375, 887, 247, 759, 503, 1015]]
def rows10 : List (List Nat) :=
    [[15, 527, 271, 783, 143, 655, 399, 911, 79, 591, 335, 847],
    [207, 719, 463, 975, 47, 559, 303, 815, 175, 687, 431, 943],
    [111, 623, 367, 879, 239, 751, 495, 1007, 31, 543, 287, 799],
    [159, 671, 415, 927, 95, 607, 351, 863, 223, 735, 479, 991],
    [63, 575, 319, 831, 191, 703, 447, 959, 127, 639, 383, 895],
    [255, 767, 511, 1023]]

theorem s00 : (sl00.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows00 := by decide

theorem s01 : (sl01.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows01 := by decide

theorem s02 : (sl02.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows02 := by decide

theorem s03 : (sl03.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows03 := by decide

theorem s04 : (sl04.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows04 := by decide

theorem s05 : (sl05.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows05 := by decide

theorem s06 : (sl06.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows06 := by decide

theorem s07 : (sl07.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows07 := by decide

theorem s08 : (sl08.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows08 := by decide

theorem s09 : (sl09.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows09 := by decide

theorem s10 : (sl10.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some rows10 := by decide


theorem region_split : region = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ sl08 ++ sl09 ++ sl10 := by
  calc rawTail.take 86
      = rawTail.take 8 ++ (rawTail.drop 8).take 78 := take_split 8 rawTail 78
    _ = sl00 ++ sl01 ++ ((rawTail.drop 8).drop 8).take 70 :=
        congrArg (fun z => sl00 ++ z) (take_split 8 (rawTail.drop 8) 70)
    _ = sl00 ++ sl01 ++ sl02 ++ (((rawTail.drop 8).drop 8).drop 8).take 62 :=
        congrArg (fun z => sl00 ++ sl01 ++ z) (take_split 8 ((rawTail.drop 8).drop 8) 62)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ ((((rawTail.drop 8).drop 8).drop 8).drop 8).take 54 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ z) (take_split 8 (((rawTail.drop 8).drop 8).drop 8) 54)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ (((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).take 46 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ sl03 ++ z) (take_split 8 ((((rawTail.drop 8).drop 8).drop 8).drop 8) 46)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ ((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 38 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ z) (take_split 8 (((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8) 38)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ (((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 30 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ z) (take_split 8 ((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8) 30)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ ((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 22 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ z) (take_split 8 (((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8) 22)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ sl08 ++ (((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 14 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ z) (take_split 8 ((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8) 14)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ sl08 ++ sl09 ++ ((((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).take 6 :=
        congrArg (fun z => sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ sl08 ++ z) (take_split 8 (((((((((rawTail.drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8).drop 8) 6)
    _ = sl00 ++ sl01 ++ sl02 ++ sl03 ++ sl04 ++ sl05 ++ sl06 ++ sl07 ++ sl08 ++ sl09 ++ sl10 := rfl

theorem mapM_join : (region.mapM KeygenRev10.parseLine : Option (List (List Nat)))
    = some (rows00 ++ rows01 ++ rows02 ++ rows03 ++ rows04 ++ rows05 ++ rows06 ++
      rows07 ++ rows08 ++ rows09 ++ rows10) := by
  rw [region_split]
  rw [List.mapM_append, List.mapM_append, List.mapM_append, List.mapM_append,
    List.mapM_append, List.mapM_append, List.mapM_append, List.mapM_append,
    List.mapM_append, List.mapM_append]
  rw [s00, s01, s02, s03, s04, s05, s06, s07, s08, s09, s10]
  rfl

def flatLit : List Nat :=
  (rows00 ++ rows01 ++ rows02 ++ rows03 ++ rows04 ++ rows05 ++ rows06 ++
    rows07 ++ rows08 ++ rows09 ++ rows10).flatten

theorem flat00 : ((flatLit.drop 0).take 32) = ((tableData.drop 0).take 32) := by decide

theorem flat01 : ((flatLit.drop 32).take 32) = ((tableData.drop 32).take 32) := by decide

theorem flat02 : ((flatLit.drop 64).take 32) = ((tableData.drop 64).take 32) := by decide

theorem flat03 : ((flatLit.drop 96).take 32) = ((tableData.drop 96).take 32) := by decide

theorem flat04 : ((flatLit.drop 128).take 32) = ((tableData.drop 128).take 32) := by decide

theorem flat05 : ((flatLit.drop 160).take 32) = ((tableData.drop 160).take 32) := by decide

theorem flat06 : ((flatLit.drop 192).take 32) = ((tableData.drop 192).take 32) := by decide

theorem flat07 : ((flatLit.drop 224).take 32) = ((tableData.drop 224).take 32) := by decide

theorem flat08 : ((flatLit.drop 256).take 32) = ((tableData.drop 256).take 32) := by decide

theorem flat09 : ((flatLit.drop 288).take 32) = ((tableData.drop 288).take 32) := by decide

theorem flat10 : ((flatLit.drop 320).take 32) = ((tableData.drop 320).take 32) := by decide

theorem flat11 : ((flatLit.drop 352).take 32) = ((tableData.drop 352).take 32) := by decide

theorem flat12 : ((flatLit.drop 384).take 32) = ((tableData.drop 384).take 32) := by decide

theorem flat13 : ((flatLit.drop 416).take 32) = ((tableData.drop 416).take 32) := by decide

theorem flat14 : ((flatLit.drop 448).take 32) = ((tableData.drop 448).take 32) := by decide

theorem flat15 : ((flatLit.drop 480).take 32) = ((tableData.drop 480).take 32) := by decide

theorem flat16 : ((flatLit.drop 512).take 32) = ((tableData.drop 512).take 32) := by decide

theorem flat17 : ((flatLit.drop 544).take 32) = ((tableData.drop 544).take 32) := by decide

theorem flat18 : ((flatLit.drop 576).take 32) = ((tableData.drop 576).take 32) := by decide

theorem flat19 : ((flatLit.drop 608).take 32) = ((tableData.drop 608).take 32) := by decide

theorem flat20 : ((flatLit.drop 640).take 32) = ((tableData.drop 640).take 32) := by decide

theorem flat21 : ((flatLit.drop 672).take 32) = ((tableData.drop 672).take 32) := by decide

theorem flat22 : ((flatLit.drop 704).take 32) = ((tableData.drop 704).take 32) := by decide

theorem flat23 : ((flatLit.drop 736).take 32) = ((tableData.drop 736).take 32) := by decide

theorem flat24 : ((flatLit.drop 768).take 32) = ((tableData.drop 768).take 32) := by decide

theorem flat25 : ((flatLit.drop 800).take 32) = ((tableData.drop 800).take 32) := by decide

theorem flat26 : ((flatLit.drop 832).take 32) = ((tableData.drop 832).take 32) := by decide

theorem flat27 : ((flatLit.drop 864).take 32) = ((tableData.drop 864).take 32) := by decide

theorem flat28 : ((flatLit.drop 896).take 32) = ((tableData.drop 896).take 32) := by decide

theorem flat29 : ((flatLit.drop 928).take 32) = ((tableData.drop 928).take 32) := by decide

theorem flat30 : ((flatLit.drop 960).take 32) = ((tableData.drop 960).take 32) := by decide

theorem flat31 : ((flatLit.drop 992).take 32) = ((tableData.drop 992).take 32) := by decide


theorem flat_len : flatLit.length = 1024 := by decide

theorem td_len : tableData.length = 1024 := by decide

/- Literal glue: the flattened slice values are exactly tableData (pure
   32-entry comparisons; no parse is involved anywhere below). -/
theorem flat_lit : flatLit = tableData := by
  have ha : flatLit.drop 1024 = ([] : List Nat) := by
    rw [show (1024 : Nat) = flatLit.length from flat_len.symm]
    exact List.drop_length
  have hb : tableData.drop 1024 = ([] : List Nat) := by
    rw [show (1024 : Nat) = tableData.length from td_len.symm]
    exact List.drop_length

  apply eq_of_split flatLit tableData 32

  · exact flat00

  ·

    apply eq_of_split (flatLit.drop 32) (tableData.drop 32) 32

    · exact flat01

    ·

      rw [List.drop_drop, List.drop_drop]

      apply eq_of_split (flatLit.drop 64) (tableData.drop 64) 32

      · exact flat02

      ·

        rw [List.drop_drop, List.drop_drop]

        apply eq_of_split (flatLit.drop 96) (tableData.drop 96) 32

        · exact flat03

        ·

          rw [List.drop_drop, List.drop_drop]

          apply eq_of_split (flatLit.drop 128) (tableData.drop 128) 32

          · exact flat04

          ·

            rw [List.drop_drop, List.drop_drop]

            apply eq_of_split (flatLit.drop 160) (tableData.drop 160) 32

            · exact flat05

            ·

              rw [List.drop_drop, List.drop_drop]

              apply eq_of_split (flatLit.drop 192) (tableData.drop 192) 32

              · exact flat06

              ·

                rw [List.drop_drop, List.drop_drop]

                apply eq_of_split (flatLit.drop 224) (tableData.drop 224) 32

                · exact flat07

                ·

                  rw [List.drop_drop, List.drop_drop]

                  apply eq_of_split (flatLit.drop 256) (tableData.drop 256) 32

                  · exact flat08

                  ·

                    rw [List.drop_drop, List.drop_drop]

                    apply eq_of_split (flatLit.drop 288) (tableData.drop 288) 32

                    · exact flat09

                    ·

                      rw [List.drop_drop, List.drop_drop]

                      apply eq_of_split (flatLit.drop 320) (tableData.drop 320) 32

                      · exact flat10

                      ·

                        rw [List.drop_drop, List.drop_drop]

                        apply eq_of_split (flatLit.drop 352) (tableData.drop 352) 32

                        · exact flat11

                        ·

                          rw [List.drop_drop, List.drop_drop]

                          apply eq_of_split (flatLit.drop 384) (tableData.drop 384) 32

                          · exact flat12

                          ·

                            rw [List.drop_drop, List.drop_drop]

                            apply eq_of_split (flatLit.drop 416) (tableData.drop 416) 32

                            · exact flat13

                            ·

                              rw [List.drop_drop, List.drop_drop]

                              apply eq_of_split (flatLit.drop 448) (tableData.drop 448) 32

                              · exact flat14

                              ·

                                rw [List.drop_drop, List.drop_drop]

                                apply eq_of_split (flatLit.drop 480) (tableData.drop 480) 32

                                · exact flat15

                                ·

                                  rw [List.drop_drop, List.drop_drop]

                                  apply eq_of_split (flatLit.drop 512) (tableData.drop 512) 32

                                  · exact flat16

                                  ·

                                    rw [List.drop_drop, List.drop_drop]

                                    apply eq_of_split (flatLit.drop 544) (tableData.drop 544) 32

                                    · exact flat17

                                    ·

                                      rw [List.drop_drop, List.drop_drop]

                                      apply eq_of_split (flatLit.drop 576) (tableData.drop 576) 32

                                      · exact flat18

                                      ·

                                        rw [List.drop_drop, List.drop_drop]

                                        apply eq_of_split (flatLit.drop 608) (tableData.drop 608) 32

                                        · exact flat19

                                        ·

                                          rw [List.drop_drop, List.drop_drop]

                                          apply eq_of_split (flatLit.drop 640) (tableData.drop 640) 32

                                          · exact flat20

                                          ·

                                            rw [List.drop_drop, List.drop_drop]

                                            apply eq_of_split (flatLit.drop 672) (tableData.drop 672) 32

                                            · exact flat21

                                            ·

                                              rw [List.drop_drop, List.drop_drop]

                                              apply eq_of_split (flatLit.drop 704) (tableData.drop 704) 32

                                              · exact flat22

                                              ·

                                                rw [List.drop_drop, List.drop_drop]

                                                apply eq_of_split (flatLit.drop 736) (tableData.drop 736) 32

                                                · exact flat23

                                                ·

                                                  rw [List.drop_drop, List.drop_drop]

                                                  apply eq_of_split (flatLit.drop 768) (tableData.drop 768) 32

                                                  · exact flat24

                                                  ·

                                                    rw [List.drop_drop, List.drop_drop]

                                                    apply eq_of_split (flatLit.drop 800) (tableData.drop 800) 32

                                                    · exact flat25

                                                    ·

                                                      rw [List.drop_drop, List.drop_drop]

                                                      apply eq_of_split (flatLit.drop 832) (tableData.drop 832) 32

                                                      · exact flat26

                                                      ·

                                                        rw [List.drop_drop, List.drop_drop]

                                                        apply eq_of_split (flatLit.drop 864) (tableData.drop 864) 32

                                                        · exact flat27

                                                        ·

                                                          rw [List.drop_drop, List.drop_drop]

                                                          apply eq_of_split (flatLit.drop 896) (tableData.drop 896) 32

                                                          · exact flat28

                                                          ·

                                                            rw [List.drop_drop, List.drop_drop]

                                                            apply eq_of_split (flatLit.drop 928) (tableData.drop 928) 32

                                                            · exact flat29

                                                            ·

                                                              rw [List.drop_drop, List.drop_drop]

                                                              apply eq_of_split (flatLit.drop 960) (tableData.drop 960) 32

                                                              · exact flat30

                                                              ·

                                                                rw [List.drop_drop, List.drop_drop]

                                                                apply eq_of_split (flatLit.drop 992) (tableData.drop 992) 32

                                                                · exact flat31

                                                                ·

                                                                  rw [List.drop_drop, List.drop_drop]

                                                                  exact ha.trans hb.symm


/- The parsed list is exactly tableData: the source binding (mapM_join) then
   the literal glue (flat_lit) through `congrArg some`, no re-parse. -/
theorem table_data : rawTable = some tableData := by
  show (region.mapM KeygenRev10.parseLine : Option (List (List Nat))).map List.flatten
    = some tableData
  rw [mapM_join]
  show some flatLit = some tableData
  exact congrArg some flat_lit

/- Descending tail glue: reassemble the model equation. -/
theorem tail1024 : tableData.drop 1024 =
    (List.range 0).map (fun j => bitrev10 (1024 + j)) := by decide

theorem tail992 : tableData.drop 992 =
    (List.range 32).map (fun j => bitrev10 (992 + j)) := by
  have take32 : (tableData.drop 992).take 32 =
      (List.range 32).map (fun j => bitrev10 (992 + j)) := chunk31
  have rest : (tableData.drop 992).drop 32 =
      (List.range 0).map (fun j => bitrev10 (1024 + j)) := by
    rw [List.drop_drop, show 992 + 32 = 1024 by decide]
    exact tail1024
  calc tableData.drop 992
      = (tableData.drop 992).take 32 ++ (tableData.drop 992).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 992)).symm
    _ = (List.range 32).map (fun j => bitrev10 (992 + j)) ++
        (List.range 0).map (fun j => bitrev10 (1024 + j)) := by
        rw [take32, rest]
    _ = (List.range 32).map (fun j => bitrev10 (992 + j)) :=
        List.append_nil _

theorem tail960 : tableData.drop 960 =
    (List.range 64).map (fun j => bitrev10 (960 + j)) := by
  have take32 : (tableData.drop 960).take 32 =
      (List.range 32).map (fun j => bitrev10 (960 + j)) := chunk30
  have rest : (tableData.drop 960).drop 32 =
      (List.range 32).map (fun j => bitrev10 (992 + j)) := by
    rw [List.drop_drop, show 960 + 32 = 992 by decide]
    exact tail992
  calc tableData.drop 960
      = (tableData.drop 960).take 32 ++ (tableData.drop 960).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 960)).symm
    _ = (List.range 32).map (fun j => bitrev10 (960 + j)) ++
        (List.range 32).map (fun j => bitrev10 (992 + j)) := by
        rw [take32, rest]
    _ = (List.range 64).map (fun j => bitrev10 (960 + j)) := by
        rw [show 64 = 32 + 32 by decide,
          map_split (fun j => bitrev10 (960 + j)) 32 32]
        rw [show (List.range 32).map (fun j => bitrev10 (960 + (32 + j))) =
            (List.range 32).map (fun j => bitrev10 (992 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 960 + (32 + j) = 992 + j by omega])]

theorem tail928 : tableData.drop 928 =
    (List.range 96).map (fun j => bitrev10 (928 + j)) := by
  have take32 : (tableData.drop 928).take 32 =
      (List.range 32).map (fun j => bitrev10 (928 + j)) := chunk29
  have rest : (tableData.drop 928).drop 32 =
      (List.range 64).map (fun j => bitrev10 (960 + j)) := by
    rw [List.drop_drop, show 928 + 32 = 960 by decide]
    exact tail960
  calc tableData.drop 928
      = (tableData.drop 928).take 32 ++ (tableData.drop 928).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 928)).symm
    _ = (List.range 32).map (fun j => bitrev10 (928 + j)) ++
        (List.range 64).map (fun j => bitrev10 (960 + j)) := by
        rw [take32, rest]
    _ = (List.range 96).map (fun j => bitrev10 (928 + j)) := by
        rw [show 96 = 32 + 64 by decide,
          map_split (fun j => bitrev10 (928 + j)) 32 64]
        rw [show (List.range 64).map (fun j => bitrev10 (928 + (32 + j))) =
            (List.range 64).map (fun j => bitrev10 (960 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 928 + (32 + j) = 960 + j by omega])]

theorem tail896 : tableData.drop 896 =
    (List.range 128).map (fun j => bitrev10 (896 + j)) := by
  have take32 : (tableData.drop 896).take 32 =
      (List.range 32).map (fun j => bitrev10 (896 + j)) := chunk28
  have rest : (tableData.drop 896).drop 32 =
      (List.range 96).map (fun j => bitrev10 (928 + j)) := by
    rw [List.drop_drop, show 896 + 32 = 928 by decide]
    exact tail928
  calc tableData.drop 896
      = (tableData.drop 896).take 32 ++ (tableData.drop 896).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 896)).symm
    _ = (List.range 32).map (fun j => bitrev10 (896 + j)) ++
        (List.range 96).map (fun j => bitrev10 (928 + j)) := by
        rw [take32, rest]
    _ = (List.range 128).map (fun j => bitrev10 (896 + j)) := by
        rw [show 128 = 32 + 96 by decide,
          map_split (fun j => bitrev10 (896 + j)) 32 96]
        rw [show (List.range 96).map (fun j => bitrev10 (896 + (32 + j))) =
            (List.range 96).map (fun j => bitrev10 (928 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 896 + (32 + j) = 928 + j by omega])]

theorem tail864 : tableData.drop 864 =
    (List.range 160).map (fun j => bitrev10 (864 + j)) := by
  have take32 : (tableData.drop 864).take 32 =
      (List.range 32).map (fun j => bitrev10 (864 + j)) := chunk27
  have rest : (tableData.drop 864).drop 32 =
      (List.range 128).map (fun j => bitrev10 (896 + j)) := by
    rw [List.drop_drop, show 864 + 32 = 896 by decide]
    exact tail896
  calc tableData.drop 864
      = (tableData.drop 864).take 32 ++ (tableData.drop 864).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 864)).symm
    _ = (List.range 32).map (fun j => bitrev10 (864 + j)) ++
        (List.range 128).map (fun j => bitrev10 (896 + j)) := by
        rw [take32, rest]
    _ = (List.range 160).map (fun j => bitrev10 (864 + j)) := by
        rw [show 160 = 32 + 128 by decide,
          map_split (fun j => bitrev10 (864 + j)) 32 128]
        rw [show (List.range 128).map (fun j => bitrev10 (864 + (32 + j))) =
            (List.range 128).map (fun j => bitrev10 (896 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 864 + (32 + j) = 896 + j by omega])]

theorem tail832 : tableData.drop 832 =
    (List.range 192).map (fun j => bitrev10 (832 + j)) := by
  have take32 : (tableData.drop 832).take 32 =
      (List.range 32).map (fun j => bitrev10 (832 + j)) := chunk26
  have rest : (tableData.drop 832).drop 32 =
      (List.range 160).map (fun j => bitrev10 (864 + j)) := by
    rw [List.drop_drop, show 832 + 32 = 864 by decide]
    exact tail864
  calc tableData.drop 832
      = (tableData.drop 832).take 32 ++ (tableData.drop 832).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 832)).symm
    _ = (List.range 32).map (fun j => bitrev10 (832 + j)) ++
        (List.range 160).map (fun j => bitrev10 (864 + j)) := by
        rw [take32, rest]
    _ = (List.range 192).map (fun j => bitrev10 (832 + j)) := by
        rw [show 192 = 32 + 160 by decide,
          map_split (fun j => bitrev10 (832 + j)) 32 160]
        rw [show (List.range 160).map (fun j => bitrev10 (832 + (32 + j))) =
            (List.range 160).map (fun j => bitrev10 (864 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 832 + (32 + j) = 864 + j by omega])]

theorem tail800 : tableData.drop 800 =
    (List.range 224).map (fun j => bitrev10 (800 + j)) := by
  have take32 : (tableData.drop 800).take 32 =
      (List.range 32).map (fun j => bitrev10 (800 + j)) := chunk25
  have rest : (tableData.drop 800).drop 32 =
      (List.range 192).map (fun j => bitrev10 (832 + j)) := by
    rw [List.drop_drop, show 800 + 32 = 832 by decide]
    exact tail832
  calc tableData.drop 800
      = (tableData.drop 800).take 32 ++ (tableData.drop 800).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 800)).symm
    _ = (List.range 32).map (fun j => bitrev10 (800 + j)) ++
        (List.range 192).map (fun j => bitrev10 (832 + j)) := by
        rw [take32, rest]
    _ = (List.range 224).map (fun j => bitrev10 (800 + j)) := by
        rw [show 224 = 32 + 192 by decide,
          map_split (fun j => bitrev10 (800 + j)) 32 192]
        rw [show (List.range 192).map (fun j => bitrev10 (800 + (32 + j))) =
            (List.range 192).map (fun j => bitrev10 (832 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 800 + (32 + j) = 832 + j by omega])]

theorem tail768 : tableData.drop 768 =
    (List.range 256).map (fun j => bitrev10 (768 + j)) := by
  have take32 : (tableData.drop 768).take 32 =
      (List.range 32).map (fun j => bitrev10 (768 + j)) := chunk24
  have rest : (tableData.drop 768).drop 32 =
      (List.range 224).map (fun j => bitrev10 (800 + j)) := by
    rw [List.drop_drop, show 768 + 32 = 800 by decide]
    exact tail800
  calc tableData.drop 768
      = (tableData.drop 768).take 32 ++ (tableData.drop 768).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 768)).symm
    _ = (List.range 32).map (fun j => bitrev10 (768 + j)) ++
        (List.range 224).map (fun j => bitrev10 (800 + j)) := by
        rw [take32, rest]
    _ = (List.range 256).map (fun j => bitrev10 (768 + j)) := by
        rw [show 256 = 32 + 224 by decide,
          map_split (fun j => bitrev10 (768 + j)) 32 224]
        rw [show (List.range 224).map (fun j => bitrev10 (768 + (32 + j))) =
            (List.range 224).map (fun j => bitrev10 (800 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 768 + (32 + j) = 800 + j by omega])]

theorem tail736 : tableData.drop 736 =
    (List.range 288).map (fun j => bitrev10 (736 + j)) := by
  have take32 : (tableData.drop 736).take 32 =
      (List.range 32).map (fun j => bitrev10 (736 + j)) := chunk23
  have rest : (tableData.drop 736).drop 32 =
      (List.range 256).map (fun j => bitrev10 (768 + j)) := by
    rw [List.drop_drop, show 736 + 32 = 768 by decide]
    exact tail768
  calc tableData.drop 736
      = (tableData.drop 736).take 32 ++ (tableData.drop 736).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 736)).symm
    _ = (List.range 32).map (fun j => bitrev10 (736 + j)) ++
        (List.range 256).map (fun j => bitrev10 (768 + j)) := by
        rw [take32, rest]
    _ = (List.range 288).map (fun j => bitrev10 (736 + j)) := by
        rw [show 288 = 32 + 256 by decide,
          map_split (fun j => bitrev10 (736 + j)) 32 256]
        rw [show (List.range 256).map (fun j => bitrev10 (736 + (32 + j))) =
            (List.range 256).map (fun j => bitrev10 (768 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 736 + (32 + j) = 768 + j by omega])]

theorem tail704 : tableData.drop 704 =
    (List.range 320).map (fun j => bitrev10 (704 + j)) := by
  have take32 : (tableData.drop 704).take 32 =
      (List.range 32).map (fun j => bitrev10 (704 + j)) := chunk22
  have rest : (tableData.drop 704).drop 32 =
      (List.range 288).map (fun j => bitrev10 (736 + j)) := by
    rw [List.drop_drop, show 704 + 32 = 736 by decide]
    exact tail736
  calc tableData.drop 704
      = (tableData.drop 704).take 32 ++ (tableData.drop 704).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 704)).symm
    _ = (List.range 32).map (fun j => bitrev10 (704 + j)) ++
        (List.range 288).map (fun j => bitrev10 (736 + j)) := by
        rw [take32, rest]
    _ = (List.range 320).map (fun j => bitrev10 (704 + j)) := by
        rw [show 320 = 32 + 288 by decide,
          map_split (fun j => bitrev10 (704 + j)) 32 288]
        rw [show (List.range 288).map (fun j => bitrev10 (704 + (32 + j))) =
            (List.range 288).map (fun j => bitrev10 (736 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 704 + (32 + j) = 736 + j by omega])]

theorem tail672 : tableData.drop 672 =
    (List.range 352).map (fun j => bitrev10 (672 + j)) := by
  have take32 : (tableData.drop 672).take 32 =
      (List.range 32).map (fun j => bitrev10 (672 + j)) := chunk21
  have rest : (tableData.drop 672).drop 32 =
      (List.range 320).map (fun j => bitrev10 (704 + j)) := by
    rw [List.drop_drop, show 672 + 32 = 704 by decide]
    exact tail704
  calc tableData.drop 672
      = (tableData.drop 672).take 32 ++ (tableData.drop 672).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 672)).symm
    _ = (List.range 32).map (fun j => bitrev10 (672 + j)) ++
        (List.range 320).map (fun j => bitrev10 (704 + j)) := by
        rw [take32, rest]
    _ = (List.range 352).map (fun j => bitrev10 (672 + j)) := by
        rw [show 352 = 32 + 320 by decide,
          map_split (fun j => bitrev10 (672 + j)) 32 320]
        rw [show (List.range 320).map (fun j => bitrev10 (672 + (32 + j))) =
            (List.range 320).map (fun j => bitrev10 (704 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 672 + (32 + j) = 704 + j by omega])]

theorem tail640 : tableData.drop 640 =
    (List.range 384).map (fun j => bitrev10 (640 + j)) := by
  have take32 : (tableData.drop 640).take 32 =
      (List.range 32).map (fun j => bitrev10 (640 + j)) := chunk20
  have rest : (tableData.drop 640).drop 32 =
      (List.range 352).map (fun j => bitrev10 (672 + j)) := by
    rw [List.drop_drop, show 640 + 32 = 672 by decide]
    exact tail672
  calc tableData.drop 640
      = (tableData.drop 640).take 32 ++ (tableData.drop 640).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 640)).symm
    _ = (List.range 32).map (fun j => bitrev10 (640 + j)) ++
        (List.range 352).map (fun j => bitrev10 (672 + j)) := by
        rw [take32, rest]
    _ = (List.range 384).map (fun j => bitrev10 (640 + j)) := by
        rw [show 384 = 32 + 352 by decide,
          map_split (fun j => bitrev10 (640 + j)) 32 352]
        rw [show (List.range 352).map (fun j => bitrev10 (640 + (32 + j))) =
            (List.range 352).map (fun j => bitrev10 (672 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 640 + (32 + j) = 672 + j by omega])]

theorem tail608 : tableData.drop 608 =
    (List.range 416).map (fun j => bitrev10 (608 + j)) := by
  have take32 : (tableData.drop 608).take 32 =
      (List.range 32).map (fun j => bitrev10 (608 + j)) := chunk19
  have rest : (tableData.drop 608).drop 32 =
      (List.range 384).map (fun j => bitrev10 (640 + j)) := by
    rw [List.drop_drop, show 608 + 32 = 640 by decide]
    exact tail640
  calc tableData.drop 608
      = (tableData.drop 608).take 32 ++ (tableData.drop 608).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 608)).symm
    _ = (List.range 32).map (fun j => bitrev10 (608 + j)) ++
        (List.range 384).map (fun j => bitrev10 (640 + j)) := by
        rw [take32, rest]
    _ = (List.range 416).map (fun j => bitrev10 (608 + j)) := by
        rw [show 416 = 32 + 384 by decide,
          map_split (fun j => bitrev10 (608 + j)) 32 384]
        rw [show (List.range 384).map (fun j => bitrev10 (608 + (32 + j))) =
            (List.range 384).map (fun j => bitrev10 (640 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 608 + (32 + j) = 640 + j by omega])]

theorem tail576 : tableData.drop 576 =
    (List.range 448).map (fun j => bitrev10 (576 + j)) := by
  have take32 : (tableData.drop 576).take 32 =
      (List.range 32).map (fun j => bitrev10 (576 + j)) := chunk18
  have rest : (tableData.drop 576).drop 32 =
      (List.range 416).map (fun j => bitrev10 (608 + j)) := by
    rw [List.drop_drop, show 576 + 32 = 608 by decide]
    exact tail608
  calc tableData.drop 576
      = (tableData.drop 576).take 32 ++ (tableData.drop 576).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 576)).symm
    _ = (List.range 32).map (fun j => bitrev10 (576 + j)) ++
        (List.range 416).map (fun j => bitrev10 (608 + j)) := by
        rw [take32, rest]
    _ = (List.range 448).map (fun j => bitrev10 (576 + j)) := by
        rw [show 448 = 32 + 416 by decide,
          map_split (fun j => bitrev10 (576 + j)) 32 416]
        rw [show (List.range 416).map (fun j => bitrev10 (576 + (32 + j))) =
            (List.range 416).map (fun j => bitrev10 (608 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 576 + (32 + j) = 608 + j by omega])]

theorem tail544 : tableData.drop 544 =
    (List.range 480).map (fun j => bitrev10 (544 + j)) := by
  have take32 : (tableData.drop 544).take 32 =
      (List.range 32).map (fun j => bitrev10 (544 + j)) := chunk17
  have rest : (tableData.drop 544).drop 32 =
      (List.range 448).map (fun j => bitrev10 (576 + j)) := by
    rw [List.drop_drop, show 544 + 32 = 576 by decide]
    exact tail576
  calc tableData.drop 544
      = (tableData.drop 544).take 32 ++ (tableData.drop 544).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 544)).symm
    _ = (List.range 32).map (fun j => bitrev10 (544 + j)) ++
        (List.range 448).map (fun j => bitrev10 (576 + j)) := by
        rw [take32, rest]
    _ = (List.range 480).map (fun j => bitrev10 (544 + j)) := by
        rw [show 480 = 32 + 448 by decide,
          map_split (fun j => bitrev10 (544 + j)) 32 448]
        rw [show (List.range 448).map (fun j => bitrev10 (544 + (32 + j))) =
            (List.range 448).map (fun j => bitrev10 (576 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 544 + (32 + j) = 576 + j by omega])]

theorem tail512 : tableData.drop 512 =
    (List.range 512).map (fun j => bitrev10 (512 + j)) := by
  have take32 : (tableData.drop 512).take 32 =
      (List.range 32).map (fun j => bitrev10 (512 + j)) := chunk16
  have rest : (tableData.drop 512).drop 32 =
      (List.range 480).map (fun j => bitrev10 (544 + j)) := by
    rw [List.drop_drop, show 512 + 32 = 544 by decide]
    exact tail544
  calc tableData.drop 512
      = (tableData.drop 512).take 32 ++ (tableData.drop 512).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 512)).symm
    _ = (List.range 32).map (fun j => bitrev10 (512 + j)) ++
        (List.range 480).map (fun j => bitrev10 (544 + j)) := by
        rw [take32, rest]
    _ = (List.range 512).map (fun j => bitrev10 (512 + j)) := by
        rw [show 512 = 32 + 480 by decide,
          map_split (fun j => bitrev10 (512 + j)) 32 480]
        rw [show (List.range 480).map (fun j => bitrev10 (512 + (32 + j))) =
            (List.range 480).map (fun j => bitrev10 (544 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 512 + (32 + j) = 544 + j by omega])]

theorem tail480 : tableData.drop 480 =
    (List.range 544).map (fun j => bitrev10 (480 + j)) := by
  have take32 : (tableData.drop 480).take 32 =
      (List.range 32).map (fun j => bitrev10 (480 + j)) := chunk15
  have rest : (tableData.drop 480).drop 32 =
      (List.range 512).map (fun j => bitrev10 (512 + j)) := by
    rw [List.drop_drop, show 480 + 32 = 512 by decide]
    exact tail512
  calc tableData.drop 480
      = (tableData.drop 480).take 32 ++ (tableData.drop 480).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 480)).symm
    _ = (List.range 32).map (fun j => bitrev10 (480 + j)) ++
        (List.range 512).map (fun j => bitrev10 (512 + j)) := by
        rw [take32, rest]
    _ = (List.range 544).map (fun j => bitrev10 (480 + j)) := by
        rw [show 544 = 32 + 512 by decide,
          map_split (fun j => bitrev10 (480 + j)) 32 512]
        rw [show (List.range 512).map (fun j => bitrev10 (480 + (32 + j))) =
            (List.range 512).map (fun j => bitrev10 (512 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 480 + (32 + j) = 512 + j by omega])]

theorem tail448 : tableData.drop 448 =
    (List.range 576).map (fun j => bitrev10 (448 + j)) := by
  have take32 : (tableData.drop 448).take 32 =
      (List.range 32).map (fun j => bitrev10 (448 + j)) := chunk14
  have rest : (tableData.drop 448).drop 32 =
      (List.range 544).map (fun j => bitrev10 (480 + j)) := by
    rw [List.drop_drop, show 448 + 32 = 480 by decide]
    exact tail480
  calc tableData.drop 448
      = (tableData.drop 448).take 32 ++ (tableData.drop 448).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 448)).symm
    _ = (List.range 32).map (fun j => bitrev10 (448 + j)) ++
        (List.range 544).map (fun j => bitrev10 (480 + j)) := by
        rw [take32, rest]
    _ = (List.range 576).map (fun j => bitrev10 (448 + j)) := by
        rw [show 576 = 32 + 544 by decide,
          map_split (fun j => bitrev10 (448 + j)) 32 544]
        rw [show (List.range 544).map (fun j => bitrev10 (448 + (32 + j))) =
            (List.range 544).map (fun j => bitrev10 (480 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 448 + (32 + j) = 480 + j by omega])]

theorem tail416 : tableData.drop 416 =
    (List.range 608).map (fun j => bitrev10 (416 + j)) := by
  have take32 : (tableData.drop 416).take 32 =
      (List.range 32).map (fun j => bitrev10 (416 + j)) := chunk13
  have rest : (tableData.drop 416).drop 32 =
      (List.range 576).map (fun j => bitrev10 (448 + j)) := by
    rw [List.drop_drop, show 416 + 32 = 448 by decide]
    exact tail448
  calc tableData.drop 416
      = (tableData.drop 416).take 32 ++ (tableData.drop 416).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 416)).symm
    _ = (List.range 32).map (fun j => bitrev10 (416 + j)) ++
        (List.range 576).map (fun j => bitrev10 (448 + j)) := by
        rw [take32, rest]
    _ = (List.range 608).map (fun j => bitrev10 (416 + j)) := by
        rw [show 608 = 32 + 576 by decide,
          map_split (fun j => bitrev10 (416 + j)) 32 576]
        rw [show (List.range 576).map (fun j => bitrev10 (416 + (32 + j))) =
            (List.range 576).map (fun j => bitrev10 (448 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 416 + (32 + j) = 448 + j by omega])]

theorem tail384 : tableData.drop 384 =
    (List.range 640).map (fun j => bitrev10 (384 + j)) := by
  have take32 : (tableData.drop 384).take 32 =
      (List.range 32).map (fun j => bitrev10 (384 + j)) := chunk12
  have rest : (tableData.drop 384).drop 32 =
      (List.range 608).map (fun j => bitrev10 (416 + j)) := by
    rw [List.drop_drop, show 384 + 32 = 416 by decide]
    exact tail416
  calc tableData.drop 384
      = (tableData.drop 384).take 32 ++ (tableData.drop 384).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 384)).symm
    _ = (List.range 32).map (fun j => bitrev10 (384 + j)) ++
        (List.range 608).map (fun j => bitrev10 (416 + j)) := by
        rw [take32, rest]
    _ = (List.range 640).map (fun j => bitrev10 (384 + j)) := by
        rw [show 640 = 32 + 608 by decide,
          map_split (fun j => bitrev10 (384 + j)) 32 608]
        rw [show (List.range 608).map (fun j => bitrev10 (384 + (32 + j))) =
            (List.range 608).map (fun j => bitrev10 (416 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 384 + (32 + j) = 416 + j by omega])]

theorem tail352 : tableData.drop 352 =
    (List.range 672).map (fun j => bitrev10 (352 + j)) := by
  have take32 : (tableData.drop 352).take 32 =
      (List.range 32).map (fun j => bitrev10 (352 + j)) := chunk11
  have rest : (tableData.drop 352).drop 32 =
      (List.range 640).map (fun j => bitrev10 (384 + j)) := by
    rw [List.drop_drop, show 352 + 32 = 384 by decide]
    exact tail384
  calc tableData.drop 352
      = (tableData.drop 352).take 32 ++ (tableData.drop 352).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 352)).symm
    _ = (List.range 32).map (fun j => bitrev10 (352 + j)) ++
        (List.range 640).map (fun j => bitrev10 (384 + j)) := by
        rw [take32, rest]
    _ = (List.range 672).map (fun j => bitrev10 (352 + j)) := by
        rw [show 672 = 32 + 640 by decide,
          map_split (fun j => bitrev10 (352 + j)) 32 640]
        rw [show (List.range 640).map (fun j => bitrev10 (352 + (32 + j))) =
            (List.range 640).map (fun j => bitrev10 (384 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 352 + (32 + j) = 384 + j by omega])]

theorem tail320 : tableData.drop 320 =
    (List.range 704).map (fun j => bitrev10 (320 + j)) := by
  have take32 : (tableData.drop 320).take 32 =
      (List.range 32).map (fun j => bitrev10 (320 + j)) := chunk10
  have rest : (tableData.drop 320).drop 32 =
      (List.range 672).map (fun j => bitrev10 (352 + j)) := by
    rw [List.drop_drop, show 320 + 32 = 352 by decide]
    exact tail352
  calc tableData.drop 320
      = (tableData.drop 320).take 32 ++ (tableData.drop 320).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 320)).symm
    _ = (List.range 32).map (fun j => bitrev10 (320 + j)) ++
        (List.range 672).map (fun j => bitrev10 (352 + j)) := by
        rw [take32, rest]
    _ = (List.range 704).map (fun j => bitrev10 (320 + j)) := by
        rw [show 704 = 32 + 672 by decide,
          map_split (fun j => bitrev10 (320 + j)) 32 672]
        rw [show (List.range 672).map (fun j => bitrev10 (320 + (32 + j))) =
            (List.range 672).map (fun j => bitrev10 (352 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 320 + (32 + j) = 352 + j by omega])]

theorem tail288 : tableData.drop 288 =
    (List.range 736).map (fun j => bitrev10 (288 + j)) := by
  have take32 : (tableData.drop 288).take 32 =
      (List.range 32).map (fun j => bitrev10 (288 + j)) := chunk09
  have rest : (tableData.drop 288).drop 32 =
      (List.range 704).map (fun j => bitrev10 (320 + j)) := by
    rw [List.drop_drop, show 288 + 32 = 320 by decide]
    exact tail320
  calc tableData.drop 288
      = (tableData.drop 288).take 32 ++ (tableData.drop 288).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 288)).symm
    _ = (List.range 32).map (fun j => bitrev10 (288 + j)) ++
        (List.range 704).map (fun j => bitrev10 (320 + j)) := by
        rw [take32, rest]
    _ = (List.range 736).map (fun j => bitrev10 (288 + j)) := by
        rw [show 736 = 32 + 704 by decide,
          map_split (fun j => bitrev10 (288 + j)) 32 704]
        rw [show (List.range 704).map (fun j => bitrev10 (288 + (32 + j))) =
            (List.range 704).map (fun j => bitrev10 (320 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 288 + (32 + j) = 320 + j by omega])]

theorem tail256 : tableData.drop 256 =
    (List.range 768).map (fun j => bitrev10 (256 + j)) := by
  have take32 : (tableData.drop 256).take 32 =
      (List.range 32).map (fun j => bitrev10 (256 + j)) := chunk08
  have rest : (tableData.drop 256).drop 32 =
      (List.range 736).map (fun j => bitrev10 (288 + j)) := by
    rw [List.drop_drop, show 256 + 32 = 288 by decide]
    exact tail288
  calc tableData.drop 256
      = (tableData.drop 256).take 32 ++ (tableData.drop 256).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 256)).symm
    _ = (List.range 32).map (fun j => bitrev10 (256 + j)) ++
        (List.range 736).map (fun j => bitrev10 (288 + j)) := by
        rw [take32, rest]
    _ = (List.range 768).map (fun j => bitrev10 (256 + j)) := by
        rw [show 768 = 32 + 736 by decide,
          map_split (fun j => bitrev10 (256 + j)) 32 736]
        rw [show (List.range 736).map (fun j => bitrev10 (256 + (32 + j))) =
            (List.range 736).map (fun j => bitrev10 (288 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 256 + (32 + j) = 288 + j by omega])]

theorem tail224 : tableData.drop 224 =
    (List.range 800).map (fun j => bitrev10 (224 + j)) := by
  have take32 : (tableData.drop 224).take 32 =
      (List.range 32).map (fun j => bitrev10 (224 + j)) := chunk07
  have rest : (tableData.drop 224).drop 32 =
      (List.range 768).map (fun j => bitrev10 (256 + j)) := by
    rw [List.drop_drop, show 224 + 32 = 256 by decide]
    exact tail256
  calc tableData.drop 224
      = (tableData.drop 224).take 32 ++ (tableData.drop 224).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 224)).symm
    _ = (List.range 32).map (fun j => bitrev10 (224 + j)) ++
        (List.range 768).map (fun j => bitrev10 (256 + j)) := by
        rw [take32, rest]
    _ = (List.range 800).map (fun j => bitrev10 (224 + j)) := by
        rw [show 800 = 32 + 768 by decide,
          map_split (fun j => bitrev10 (224 + j)) 32 768]
        rw [show (List.range 768).map (fun j => bitrev10 (224 + (32 + j))) =
            (List.range 768).map (fun j => bitrev10 (256 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 224 + (32 + j) = 256 + j by omega])]

theorem tail192 : tableData.drop 192 =
    (List.range 832).map (fun j => bitrev10 (192 + j)) := by
  have take32 : (tableData.drop 192).take 32 =
      (List.range 32).map (fun j => bitrev10 (192 + j)) := chunk06
  have rest : (tableData.drop 192).drop 32 =
      (List.range 800).map (fun j => bitrev10 (224 + j)) := by
    rw [List.drop_drop, show 192 + 32 = 224 by decide]
    exact tail224
  calc tableData.drop 192
      = (tableData.drop 192).take 32 ++ (tableData.drop 192).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 192)).symm
    _ = (List.range 32).map (fun j => bitrev10 (192 + j)) ++
        (List.range 800).map (fun j => bitrev10 (224 + j)) := by
        rw [take32, rest]
    _ = (List.range 832).map (fun j => bitrev10 (192 + j)) := by
        rw [show 832 = 32 + 800 by decide,
          map_split (fun j => bitrev10 (192 + j)) 32 800]
        rw [show (List.range 800).map (fun j => bitrev10 (192 + (32 + j))) =
            (List.range 800).map (fun j => bitrev10 (224 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 192 + (32 + j) = 224 + j by omega])]

theorem tail160 : tableData.drop 160 =
    (List.range 864).map (fun j => bitrev10 (160 + j)) := by
  have take32 : (tableData.drop 160).take 32 =
      (List.range 32).map (fun j => bitrev10 (160 + j)) := chunk05
  have rest : (tableData.drop 160).drop 32 =
      (List.range 832).map (fun j => bitrev10 (192 + j)) := by
    rw [List.drop_drop, show 160 + 32 = 192 by decide]
    exact tail192
  calc tableData.drop 160
      = (tableData.drop 160).take 32 ++ (tableData.drop 160).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 160)).symm
    _ = (List.range 32).map (fun j => bitrev10 (160 + j)) ++
        (List.range 832).map (fun j => bitrev10 (192 + j)) := by
        rw [take32, rest]
    _ = (List.range 864).map (fun j => bitrev10 (160 + j)) := by
        rw [show 864 = 32 + 832 by decide,
          map_split (fun j => bitrev10 (160 + j)) 32 832]
        rw [show (List.range 832).map (fun j => bitrev10 (160 + (32 + j))) =
            (List.range 832).map (fun j => bitrev10 (192 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 160 + (32 + j) = 192 + j by omega])]

theorem tail128 : tableData.drop 128 =
    (List.range 896).map (fun j => bitrev10 (128 + j)) := by
  have take32 : (tableData.drop 128).take 32 =
      (List.range 32).map (fun j => bitrev10 (128 + j)) := chunk04
  have rest : (tableData.drop 128).drop 32 =
      (List.range 864).map (fun j => bitrev10 (160 + j)) := by
    rw [List.drop_drop, show 128 + 32 = 160 by decide]
    exact tail160
  calc tableData.drop 128
      = (tableData.drop 128).take 32 ++ (tableData.drop 128).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 128)).symm
    _ = (List.range 32).map (fun j => bitrev10 (128 + j)) ++
        (List.range 864).map (fun j => bitrev10 (160 + j)) := by
        rw [take32, rest]
    _ = (List.range 896).map (fun j => bitrev10 (128 + j)) := by
        rw [show 896 = 32 + 864 by decide,
          map_split (fun j => bitrev10 (128 + j)) 32 864]
        rw [show (List.range 864).map (fun j => bitrev10 (128 + (32 + j))) =
            (List.range 864).map (fun j => bitrev10 (160 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 128 + (32 + j) = 160 + j by omega])]

theorem tail96 : tableData.drop 96 =
    (List.range 928).map (fun j => bitrev10 (96 + j)) := by
  have take32 : (tableData.drop 96).take 32 =
      (List.range 32).map (fun j => bitrev10 (96 + j)) := chunk03
  have rest : (tableData.drop 96).drop 32 =
      (List.range 896).map (fun j => bitrev10 (128 + j)) := by
    rw [List.drop_drop, show 96 + 32 = 128 by decide]
    exact tail128
  calc tableData.drop 96
      = (tableData.drop 96).take 32 ++ (tableData.drop 96).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 96)).symm
    _ = (List.range 32).map (fun j => bitrev10 (96 + j)) ++
        (List.range 896).map (fun j => bitrev10 (128 + j)) := by
        rw [take32, rest]
    _ = (List.range 928).map (fun j => bitrev10 (96 + j)) := by
        rw [show 928 = 32 + 896 by decide,
          map_split (fun j => bitrev10 (96 + j)) 32 896]
        rw [show (List.range 896).map (fun j => bitrev10 (96 + (32 + j))) =
            (List.range 896).map (fun j => bitrev10 (128 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 96 + (32 + j) = 128 + j by omega])]

theorem tail64 : tableData.drop 64 =
    (List.range 960).map (fun j => bitrev10 (64 + j)) := by
  have take32 : (tableData.drop 64).take 32 =
      (List.range 32).map (fun j => bitrev10 (64 + j)) := chunk02
  have rest : (tableData.drop 64).drop 32 =
      (List.range 928).map (fun j => bitrev10 (96 + j)) := by
    rw [List.drop_drop, show 64 + 32 = 96 by decide]
    exact tail96
  calc tableData.drop 64
      = (tableData.drop 64).take 32 ++ (tableData.drop 64).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 64)).symm
    _ = (List.range 32).map (fun j => bitrev10 (64 + j)) ++
        (List.range 928).map (fun j => bitrev10 (96 + j)) := by
        rw [take32, rest]
    _ = (List.range 960).map (fun j => bitrev10 (64 + j)) := by
        rw [show 960 = 32 + 928 by decide,
          map_split (fun j => bitrev10 (64 + j)) 32 928]
        rw [show (List.range 928).map (fun j => bitrev10 (64 + (32 + j))) =
            (List.range 928).map (fun j => bitrev10 (96 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 64 + (32 + j) = 96 + j by omega])]

theorem tail32 : tableData.drop 32 =
    (List.range 992).map (fun j => bitrev10 (32 + j)) := by
  have take32 : (tableData.drop 32).take 32 =
      (List.range 32).map (fun j => bitrev10 (32 + j)) := chunk01
  have rest : (tableData.drop 32).drop 32 =
      (List.range 960).map (fun j => bitrev10 (64 + j)) := by
    rw [List.drop_drop, show 32 + 32 = 64 by decide]
    exact tail64
  calc tableData.drop 32
      = (tableData.drop 32).take 32 ++ (tableData.drop 32).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 32)).symm
    _ = (List.range 32).map (fun j => bitrev10 (32 + j)) ++
        (List.range 960).map (fun j => bitrev10 (64 + j)) := by
        rw [take32, rest]
    _ = (List.range 992).map (fun j => bitrev10 (32 + j)) := by
        rw [show 992 = 32 + 960 by decide,
          map_split (fun j => bitrev10 (32 + j)) 32 960]
        rw [show (List.range 960).map (fun j => bitrev10 (32 + (32 + j))) =
            (List.range 960).map (fun j => bitrev10 (64 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 32 + (32 + j) = 64 + j by omega])]

theorem tail0 : tableData.drop 0 =
    (List.range 1024).map (fun j => bitrev10 (0 + j)) := by
  have take32 : (tableData.drop 0).take 32 =
      (List.range 32).map (fun j => bitrev10 (0 + j)) := chunk00
  have rest : (tableData.drop 0).drop 32 =
      (List.range 992).map (fun j => bitrev10 (32 + j)) := by
    rw [List.drop_drop, show 0 + 32 = 32 by decide]
    exact tail32
  calc tableData.drop 0
      = (tableData.drop 0).take 32 ++ (tableData.drop 0).drop 32 := by
        exact (List.take_append_drop 32 (tableData.drop 0)).symm
    _ = (List.range 32).map (fun j => bitrev10 (0 + j)) ++
        (List.range 992).map (fun j => bitrev10 (32 + j)) := by
        rw [take32, rest]
    _ = (List.range 1024).map (fun j => bitrev10 (0 + j)) := by
        rw [show 1024 = 32 + 992 by decide,
          map_split (fun j => bitrev10 (0 + j)) 32 992]
        rw [show (List.range 992).map (fun j => bitrev10 (0 + (32 + j))) =
            (List.range 992).map (fun j => bitrev10 (32 + j)) from
            map_range_ext _ _ _ (fun j => by
              rw [show 0 + (32 + j) = 32 + j by omega])]

theorem tableData_exact : tableData = (List.range 1024).map bitrev10 := by
  have h := tail0
  rw [List.drop_zero] at h
  exact h.trans (map_range_ext (fun j => bitrev10 (0 + j)) bitrev10 1024
    (fun j => by rw [Nat.zero_add]))


theorem rawTable_exact : rawTable = some ((List.range 1024).map bitrev10) := by
  rw [table_data]
  exact congrArg some tableData_exact

end FT1536.Source3.KeygenRev10Cert
