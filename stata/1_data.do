set more off


use "$MY_IN_PATH\bfpbrutto.dta", clear
merge n:1 hhnr bfhhnr using "$MY_IN_PATH\bfh.dta", ///
nogen keep(master match) keepus(bfh4830 bfh4821 bfh4841  bfh4805  bfh4811 bfh4816 bfh4824 bfh4829 bfh4834 )
merge n:1 hhnr bfhhnr using "$MY_IN_PATH\bfhbrutto.dta", ///
nogen keep(master match) keepus(bfbula)
merge 1:1 persnr using "$MY_IN_PATH\bfp.dta", ///
nogen keep(master match)
merge 1:1 persnr  using "$MY_IN_PATH\phrf.dta", nogen keep(master match) keepus(bfphrf)
rename bfp147 pfamst
merge 1:1 persnr using "$MY_IN_PATH\bfpgen.dta", nogen keep(master match) keepus(labgro15 labnet15 emplst15 bffamstd stib15)

rename  bfp82 pgtatzt
rename bfp8101 pgvebzt
rename  labgro15 pglabgro 
rename  labnet15 pglabnet
*rename bfp10201 pglabgro
*rename bfp10202 pglabnet
rename bfpsex sex
rename  bfp6801 precht04 //brutto
rename  bfp7001 precht02
rename bfp67 precht1a //gross
rename bfp69 precht1b //net
rename bfstell stell
rename bfhhnr hid
rename hhnr cid
rename persnr pid


keep cid hid pid welle sample1 bfpnr ///
bfpbirthy bfpbirthm sex  precht1a precht1b  pgtatzt ///
pgvebzt precht04  precht02 pfamst bfh4830 bfh4821 ///
bfp114h03m bfh4841  bfh4805  bfh4811 bfh4816 bfh4824 ///
pglabgro pglabnet bfh4829 bfh4834 bfp9902 bfp10101 bfp1601  ///
bfp97 stell bfp114u03m bfp13  bfp13102 bfphrf  bfgeburt ///
bfp114d01m   bfp114e01m bfp14501 bfp0111 bfp32 stib15 bfbula
save "$MY_OUT_PATH\p1.dta", replace



