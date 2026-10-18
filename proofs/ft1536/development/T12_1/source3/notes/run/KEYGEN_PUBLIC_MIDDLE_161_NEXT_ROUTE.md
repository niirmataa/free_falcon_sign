# Next after161

PublicMiddleLoop161.source is reusable for every group, with
Fixed(s,a,ht,stop), USlot v start and start<=stop; it derives the end counter
and a MemoryFrame (size, writability, all written a-cells, outside bytes).
The original scalar locals/pointers are also governed by the existing
KeygenPublicTableControl.frame.

Next compose the original midGroupBody: declare v2/s; load
s=gm_square[m+u1]; set v2=v1+ht; initialize v=v1; execute the certified
inner loop; restore v2/s. PublicGroupHead162 is prepared but not yet
accepted at this checkpoint. Use table/data block separation to transport
the generated table through all groups; then increment u1 and v1.
Eight outer rounds and tripling follow; actual call binding and the whole
seed witness remain separate obligations. Do not use the FPR64 FFT
execution relation as a uint16 NTT execution theorem.
