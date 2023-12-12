set more off

use "$MY_OUT_PATH\p2.dta", clear

************************************************
/*Summary Statistics*/
************************************************
replace pgtatzt=pgtatzt/10

sum inc_gross inc_net inc_gross_just inc_net_just sex pgtatzt age east  [aw=bfphrf]
sutex inc_gross inc_net inc_gross_just inc_net_just sex pgtatzt age east  [aw=bfphrf], file("${MY_OUT_PATH}\sumstats.tex") replace minmax digits(3) labels 


*Table 1 - singles
tab precht1a precht1b if inlist(precht1a,1,2) & inlist(precht1b,1,2), cell nof
*sutex precht1a precht1b if inlist(precht1a,1,2) & inlist(precht1b,1,2), cell nof


/*gross = fair gross*/
gen justgross=1 if inc_gross==inc_gross_just & !missing(inc_gross)

/*Calculate average just net income for those whose just gross income is close to 
the average of the group means of gross income*/

gen h=.
gen group=.
gen inc_net_just_mean=.
gen inc_net_mean=.
gen f_abs_just_mean=.
gen f_rel_just_mean=.
*set trace off

/*create variable showing quantile of gross income. This variable defines the groups*/
xtile [aw=bfphrf] quant_gross = inc_gross if inc_gross>0 , nq($groups)
replace quant_gross=0 if inc_gross==0 
replace justgross=1 if quant_gross==0

if $sample==12{
	keep if justgross==1
}


/*calculate group shares*/
/*create variables with average net income for quantile*/
forv groups=0/$groups {	
		/*save scalars for entire population*/
		if $justgross==0 | `groups'==0{
			sum inc_net [aw=bfphrf] if quant_gross==`groups' 
		}
		if $justgross==1 & `groups'>0{
			sum inc_net [aw=bfphrf] if quant_gross==`groups' /*& justgross==1*/ 
		}
		scalar Inc_net`groups'=r(mean)
		sum inc_gross [aw=bfphrf] if quant_gross==`groups'
		scalar rmin=r(min)
		scalar rmax=r(max)
		scalar Inc_gross`groups'=r(mean)
		*replace group=0 if inc_gross_just>= r(min) & inc_gross_just <=r(max)
		if $justgross==0{
			sum  inc_net_just [aw=bfphrf] if inc_gross_just>= rmin & inc_gross_just <=rmax	
		}
		if $justgross==1{
			sum  inc_gross_just [aw=bfphrf] if inc_gross>= rmin & inc_gross <=rmax & justgross==1 
			scalar Inc_gross_just`groups'=r(mean)
			sum  inc_net_just [aw=bfphrf] if inc_gross>= rmin & inc_gross <=rmax & justgross==1 
			scalar Inc_net_just`groups'=r(mean)
			replace inc_net_just_mean=r(mean) if quant_gross==`groups'
			sum f_abs_just [aw=bfphrf] if inc_gross>= rmin & inc_gross <=rmax & justgross==1
			scalar F_abs_just`groups'=r(mean)
			replace f_abs_just_mean=r(mean) if quant_gross==`groups'
			sum f_rel_just [aw=bfphrf] if inc_gross>= rmin & inc_gross <=rmax & justgross==1
			scalar F_rel_just`groups'=r(mean)
			replace f_rel_just_mean=r(mean) if quant_gross==`groups'
		}
				
		/*weights*/
		sum pid [aw=bfphrf]  if quant_gross==`groups' 
		scalar H0`groups'=r(sum_w)
		sum pid [aw=bfphrf] 
		scalar H0`groups'=H0`groups'/r(sum_w)

	sum pid [aw=bfphrf]  if quant_gross==`groups' 
	replace h=r(sum_w)  if quant_gross==`groups' 
	sum pid [aw=bfphrf] 
	replace h=h/r(sum_w) if  quant_gross==`groups'
}
*subj. justness only for indiv. with just gross==gross
replace inc_net_just=. if precht1a!=1 

*************************
*create the excel sheet for mathematica
************************
preserve
/*collapse is used only to obtain the correct number of observations*/
collapse   inc_gross  inc_gross_just inc_net inc_net_just_mean inc_net_just h ///
  [aw=bfphrf] , by(quant_gross)
cap erase "${MY_OUT_PATH}\groups.tex"

keep quant_gross* inc_gross inc_net inc_net_just_mean h 

drop if  quant_gross==.
sort quant_gross

export excel using "${MY_OUT_PATH}\groups${sample}.xls" if quant_gross!=., replace /*some individuals have weight=0, therefore there are missings in quant_gross.*/
restore



	
/***********budget graph*******************/
gen inc_gross_groups=.
gen inc_net_groups=.
gen inc_gross_just_groups=.
gen inc_net_just_groups=.
gen igroup = .

forv groups=0/$groups{
	replace igroup = `groups' if quant_gross==`groups'
	replace inc_gross_groups=Inc_gross`groups' if quant_gross==`groups'
	replace inc_net_groups=Inc_net`groups' if quant_gross==`groups'
	replace inc_gross_just_groups=Inc_gross_just`groups' if quant_gross==`groups' & quant_gross!=0
	replace inc_net_just_groups=Inc_net_just`groups' if quant_gross==`groups' & quant_gross!=0
}  	
	
scalar max_inc_gross = 6000

 gen just_tax = inc_gross_just-inc_net_just
  gen tax = inc_gross-inc_net
   gen just_tax_ = (inc_gross_just-inc_net_just)/inc_gross_just*100
  gen tax_ = (inc_gross-inc_net)/inc_gross*100
  gen dtax = tax_-just_tax_

sort inc_gross
gen  ijob1_hh = inc_gross

tw (scatter inc_net inc_gross, sort(inc_gross) color(gs12%30) m(oh) mlwidth(0.2)) ///
   (scatter inc_net_just inc_gross_just, sort(inc_gross_just) color(gs12%30) m(X) mlwidth(0.2)) ///
   (line inc_gross inc_gross if inc_gross<4800, sort(inc_gross) lw(0.6) lc(black) lpattern(dash)) ///
   (line inc_net_groups inc_gross_groups, sort(inc_gross_groups) lw(0.6) lc(black)) /// 
   /// (line net_income_hh ijob1_hh, sort(ijob1_hh) lw(0.6) lc(blue)) ///
   (line inc_net_just_groups inc_gross_groups, sort(inc_gross_groups) lw(0.6) lc(black) lpattern(longdash)) ///
   if inc_gross<max_inc_gross & (inc_gross_just<max_inc_gross | inc_gross_just==.), xlabel(#10, axis(1)) ylabel(#6, grid angle(horizontal)) ///
   xtitle("Monthly Gross Income", axis(1)) ytitle("Monthly Net Income") ///
   legend(order(3 1 2 4 5) col(1) label(3 "45 Degree Line") label(1 "Actual Income") label(2 "Just Income") label(4 "Actual Budget Line Group 0-5") label(5 "Just Budget Line Group 1-5"))
graph export "$MY_OUT_PATH\budget.pdf", as(pdf) replace




	





