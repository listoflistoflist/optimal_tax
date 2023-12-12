set more off

use "$MY_OUT_PATH\p1", clear

foreach var in bfh4805 bfh4821 bfh4811 bfh4841 bfp114u03m pglabnet pglabgro{
	replace `var'=0 if `var'<0 | `var'==.
}

/*gen dummy for east germany*/
gen east=.
replace east=1 if (bfbula>10 & bfbula<17) /*Bundesland categories*/

replace east=0 if (bfbula>0 & bfbula<11) /*Bundesland categories*/


/*mark additional hh members. keep only single households*/
bys hid: gen non_classical_hh=_N if stell>24 | stell==13 | stell==12 | stell==11
bys hid: egen non_c=total(non_classical_hh)
drop if non_c>0

/*codrop children*/
gen age=2016-bfgeburt

gen child=0
replace child=1 if stell >0
bys hid: egen no_child_help=count(pid) if child==1
replace no_child_help=0 if no_child_help==.
bys hid: egen no_child=max(no_child_help)
bys hid: egen no_pers_help=count(pid) 
replace no_pers_help=0 if no_pers_help==.
bys hid: egen no_pers=max(no_pers_help)

gen adults=no_pers-no_child
gen equiv=1 /*+0.3*(no_child)+0.5*(adults-1)*/

/*keep households with single household heads, keep only household heads*/
keep if inlist(pfamst, 3,4,5) //single household heads only

drop if stell>0
keep if inlist(bfp32,1,2,4,9) /*keep those with flexible labor supply (no FSJ , disabled etc.) */
drop if inlist(stib15,-1,11,13) /*drop pensioners and trainees*/
drop if pglabgro==0 & (bfp32==1 | bfp32 ==2 | bfp32==4) 
drop if bfp1601==1 /*drop those in apprenticeship, training, education, etc.*/
drop if inlist(bfp13,1,2) /*drop those in parental leave*/
drop if bfp13102>50 /*drop heavily disabled*/
drop if bfp114h03m >0 /*drop those receiving unemployment benefits I*/
drop if bfp114d01m ==1 /*drop pensioners*/
drop if bfh4821 ==0 & pglabgro==0 /*drop those without take-up*/
drop if age<25 | age>60
drop if pglabnet<pglabgro*0.4

replace bfp14501=100 if bfp14501==-2 /*no party affiliation*/
replace bfp14501=2 if bfp14501==3 /*csu=cdu*/
replace bfp14501=2 if bfp14501==13 /*csu=cdu*/

mvdecode _all, mv(-6=.\-5=.\-4=.\-3=.\-2=.\-1=.)


/*These transfers are added to the net incomes:
kindergeldbezug+alg2+kinderzuschlag+wohngeld+Unterhalt*/

gen inc_net=(pglabnet+ bfh4805+bfh4821+bfh4811+bfh4841+bfp114u03m)/equiv  

/*precht02: just net income
precht04: just gross income*/

/*Add transfers to just net income*/
replace precht02=(precht02+bfh4805+bfh4821+bfh4811+bfh4841+bfp114u03m)/equiv  
/*just income*/
gen inc_gross_just=.
replace inc_gross_just=precht04 if precht1a==2
replace inc_gross_just=pglabgro if precht1a==1
gen inc_net_just=.
replace inc_net_just=precht02 if precht1b==2
replace inc_net_just=inc_net if precht1b==1

label var inc_gross_just "Just gross income"
label var inc_net_just "Just net income"

/*equivalence weights for actual incomes*/
rename pglabgro inc_gross
replace inc_gross=inc_gross/equiv
replace inc_gross_just=inc_gross_just/equiv




/*Different samples*/
if ${sample}==1{ /*all without children*/
	drop if no_child>0 
}

if ${sample}==2{ /*only females*/
	drop if sex==1 
	drop if no_child>0 
}
if ${sample}==3{ /*only males*/
	drop if sex==2 
	drop if no_child>0 
}
if ${sample}==4{ /*only lone mothers*/
	keep if sex==2 & no_child==1
}

/*0: all, 100: none [1] SPD, [2] CDU/CSU , [5] Gruene Buendnis90, [6] Die Linke, [9] Green, SPD
[15] CDU/Green,  [16] Green, Left, [17]SPD, Left*/

if ${sample}==5{ /*only SPD, Left and Green supporters*/
	keep if bfp14501 ==1 | bfp14501 ==5 | bfp14501 == 6| bfp14501 ==9 | bfp14501 ==16 | bfp14501 ==17
	drop if no_child>0 
}

if ${sample}==6{ /*only CDU and SPD supporters*/
	keep if bfp14501 ==1 | bfp14501==2
	drop if no_child>0 
}

if ${sample}==7{ /*only SPD and Green supporters*/
	keep if bfp14501 ==1 | bfp14501 ==5 | bfp14501 ==9
	drop if no_child>0 
}

if ${sample}==8{ /*only CDU, FDP and Greens */
	keep if bfp14501 ==2 |bfp14501 ==4  | bfp14501 ==5 
	drop if no_child>0 
}

if ${sample}==9{ /*no party */
	keep if bfp14501 ==100 
	drop if no_child>0 
}

if ${sample}==10{ /*east*/
	keep if east==1
	drop if no_child>0 
}

if ${sample}==11{ /*west*/
	keep if east==0
	drop if no_child>0 
}
save "$MY_OUT_PATH\p2.dta", replace
