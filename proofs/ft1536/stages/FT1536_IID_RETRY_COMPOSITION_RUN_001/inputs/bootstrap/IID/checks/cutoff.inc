static void
ft_berexp_cutoff_state(uint32_t sw, uint32_t *safe_s, uint32_t *over)
{
	*over = (63U - sw) >> 31;
	*safe_s = sw ^ ((sw ^ 63U) & (0U - *over));
}
