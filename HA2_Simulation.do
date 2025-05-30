*****************************************
// PROJECT: Examination of RTM effects on the Proportion of Maxmal Benefit (PMB)
// VERSION DATE: May 13, 2025

// Written by: Daniel Roth, Huma Qamar
***************************************** 

// set directory 
*This is where all the simulation datasets will be saved
cd "insert file path"

// this is where final figures will be saved
global dir_fig "insert file path"

*****************************************
// Simulate datasets of Randomized controlled trials 
// Baseline LAZ at 6 and endline at 18 months
// Randomly select imbalanced groups at baseline with varying level of imbalance
// Null Treatment effect and positive treatment effect scenarios
*****************************************


//  iterate through simulation scenarios

// mean - population mean HAZ 
// corr - correlation between intervention group and baseline LAZ
// effect - effect estimate/2

foreach mean of numlist 0(-0.2)-1 -2 {
	foreach corr of numlist 0.13(0.01)0.3 {
	    foreach effect of numlist 0 0.05 0.25 {

		clear all
		set seed 3462
		
		// 10,000 participants
		set obs 10000

	* Corr matrix (LAZ6, LAZ18):
	matrix C = 		(	 1, 	0.813) 		// 0.813 is from Anderson et al. correlation matrix 
	matrix C = C\	(0.813,	    1)			// correlations of LAZ6 with LAZ18
	
* Set mean LAZ at 6 and 18 mo for a population of the `mean' of current iteration at both ages 
matrix M = (`mean', `mean')			

* SD:
matrix SD = (1, 1)					// Set all SDs to 1. 

* Simulate population anthropometry dataset using parameters set above
drawnorm LAZ6 LAZ18, means(M) sds(SD) corr(C)

gen r = `corr'						// 		generates a predetermined correlation between baseline LAZ
									// 		and treatment group
								
gen k = invnorm(uniform())*1				// generates another normally distributed set of scores (k)
gen group = LAZ6*r + (k*((1-r^2)^0.5))		// transforms k into a treatment score that has a predetermined
											// correlation with the baseline score
capture drop k

pwcorr LAZ6 LAZ18 group					// confirm expected correlations

// save correlation between group and LAZ6 into dataset 
gen group_corr = `corr'
gen group_mean = `mean'
gen group_effect = `effect' * 2

// generate ages at baseline and endline in days
gen Age0 = int(30.4375*6)
gen Age1 = int(30.4375*18)

// generate treatment group variable by splitting the random group generated above in half
su group, d
gen x=0 if group < r(p50)
replace x=1 if group >= r(p50)
rename group group_dist
rename x group
label define group 0 "A" 1 "B"
label values group group

// adjust endline to induce an intervention effect 
replace LAZ18 = LAZ18 + `effect' if group == 1
replace LAZ18 = LAZ18 - `effect' if group == 0


*Check means, correlation and mean differences in simulated variables
sum LAZ6 LAZ18
ttest LAZ6 == LAZ18
ttest LAZ6, by(group)
ttest LAZ18, by(group)

*Examine RTM effects in the whole population
gen delta_LAZ = LAZ18 - LAZ6
pwcorr delta_LAZ LAZ6
pwcorr delta_LAZ LAZ6 if group==0
pwcorr delta_LAZ LAZ6 if group==1
pwcorr LAZ18 LAZ6 if group==0
pwcorr LAZ18 LAZ6 if group==1

su LAZ6 if group == 1 
gen mLAZ6_group_1 = r(mean)
su LAZ6 if group == 0
gen mLAZ6_group_0 = r(mean)

su LAZ18 if group == 1 
gen mLAZ18_group_1 = r(mean)
su LAZ18 if group == 0
gen mLAZ18_group_0 = r(mean)

*Estimate treatment effects
reg delta_LAZ group
gen effect_deltaLAZ = e(b)[1,1]

*Adjust for baseline
reg LAZ18 group LAZ6
gen effect_LAZ_adj = e(b)[1,1]

// collapsing dataset to summary estimates
collapse mLAZ* effect* Age0 Age1 group_corr group_mean group_effect

local eff = `effect' * 2

// save iteration
save "HA-RTM_6to18mo_falt`mean'-`corr'-`eff'.dta", replace

sleep 1000

copy "https://raw.githubusercontent.com/unicef-drp/igrowup_update/master/lenanthro.dta" "lenanthro.dta", replace
use "lenanthro.dta"

* Assume equal proportion of girls to boys in dataset, collapse dataset
collapse (mean) l m s, by(_agedays)
gen merger =1
save "lenanthro_collapsed.dta", replace

sleep 1000

*Calculate height-ages
local eff = `effect' * 2
use "HA-RTM_6to18mo_falt`mean'-`corr'-`eff'.dta", clear 
	gen merger = 1
	joinby merger using "lenanthro_collapsed.dta"
	
	foreach var of newlist group_1 group_0 {
		// calculate length
		gen lenhei6_`var' = m*((mLAZ6_`var'*s)+1) if _agedays == Age0 
		gen lenhei18_`var' = m*((mLAZ18_`var'*s)+1) if _agedays == Age1 
		
		// identify height-age
		sort lenhei6_`var'
		replace lenhei6_`var' = lenhei6_`var'[1] if missing(lenhei6_`var')
		bysort _agedays: egen minabs_diff = min(abs(lenhei6_`var'-m))
		sort minabs_diff
		gen HAdays6_`var' = _agedays[1]
		drop minabs_diff 
		
		sort lenhei18_`var'
		replace lenhei18_`var' = lenhei18_`var'[1] if missing(lenhei18_`var')
		bysort _agedays: egen minabs_diff = min(abs(lenhei18_`var'-m))
		sort minabs_diff
		gen HAdays18_`var' = _agedays[1]
		drop minabs_diff
		
	}
		
	collapse (max) mLAZ* effect* Age0 Age1 HAdays* group_corr group_mean group_effect lenhei*
	
	// calculate PMB 
	
	gen deltaCA0 = Age1 - Age0 

	foreach var of newlist group {

		gen deltaHA1 = HAdays18_`var'_1 - HAdays6_`var'_1
		gen deltaHA0 = HAdays18_`var'_0 - HAdays6_`var'_0
		gen PMB = ((deltaHA1 - deltaHA0)/(deltaCA0 - deltaHA0))*100 
		gen PMB_num = deltaHA1 - deltaHA0
		gen PMB_denom = deltaCA0 - deltaHA0
		
	}
		
	
	order group* PMB* effect_deltaLAZ effect_LAZ_adj lenhei*, first 
		
	local eff = `effect' * 2	
	save "HA-RTM_6to18mo_falt`mean'-`corr'-`eff'.dta", replace
	
	sleep 1000
	}
	}
}
		
// combine all simulation iterations
foreach mean of numlist 0(-0.2)-1 -2 {
		foreach corr of numlist -0.3(0.01)0.3 {
		    foreach effect of numlist 0 0.1 0.5 {

	   append using "HA-RTM_6to18mo_falt`mean'-`corr'-`effect'.dta"

}
}
}

duplicates drop 

gsort group_mean -group_corr -group_effect
gen mLAZ6_diff = mLAZ6_group_1 - mLAZ6_group_0
gen HAdays6_diff = HAdays6_group_1 - HAdays6_group_0

save "HA-RTM_6to18mo_falt_null_and_effect.dta", replace

export excel using "HA-RTM_6to18mo_falt_null_and_effect.xlsx", replace first(var) keepcellfmt


****************** END OF SIMULATION *****************


***Generate Figures***
use "HA-RTM_6to18mo_falt_null_and_effect.dta", replace

format group_mean %5.1f
tostring group_mean, gen(str_mean) usedisplayformat force

replace str_mean = "mLAZ = " + str_mean

preserve 
drop if group_mean >= -0.45
drop if HAdays6_diff < -9 
drop if HAdays6_diff >9
twoway lowess PMB HAdays6_diff if group_effect == 0 & HAdays6_diff >= -9 & HAdays6_diff <= 9 & group_mean < -0.25, lcolor(gs4) note("") ||  lowess PMB HAdays6_diff if group_effect == float(0.1)  & HAdays6_diff >= -9 & HAdays6_diff <= 9  & group_mean < -0.25, lcolor(ebblue*0.9)  ||  lowess PMB HAdays6_diff if group_effect == float(0.5)  & HAdays6_diff >= -9 & HAdays6_diff <= 9  & group_mean < -0.25, lcolor(red*0.7) by(str_mean, graphregion(color(white)) note("") note("{bf:a}", size(medlarge) position(11))) graphregion(color(white)) xtitle("Difference in baseline height-age (days)," "Intervention vs control", margin(top) size(medlarge)) ytitle("Proportion of Maximal Benefit (%)", margin(right) size(medlarge)) legend(order(1 2 3) label(1 "Null Effect") label(2 "0.1") label(3 "0.5") title("{bf:Simulated Treatment Effect (LAZ),}" "{bf:Intervention vs control}", size(small)  ) row(1)  symxsize(6) size(small) region(lcolor(none))) xline(0, lcolor(gs14) lpattern(-) ) subtitle(,bcolor(none)) note("") xsize(5) ysize(3) ylabel(,nogrid) yline(0, lcolor(gs14) lpattern(-)) name(PMB_HAdiff_scenarios, replace) 

// reference line for intervention effect == 0.1 in panel b
su PMB if HAdays6_diff == 0 & group_mean == -1 & group_effect == float(0.1)
local yline = r(mean) 

twoway lowess PMB HAdays6_diff if group_effect == 0 & HAdays6_diff >= 0 & HAdays6_diff <= 5 & group_mean == float(-1), lcolor(gs4) note("") ||  lowess PMB HAdays6_diff if group_effect == float(0.1)  & HAdays6_diff >= 0 & HAdays6_diff <= 5  & group_mean == float(-1), lcolor(ebblue*0.9) note("{bf:b}", size(medlarge) ring(20) position(11)) graphregion(color(white)) xtitle("Difference in baseline height-age (days)," "Intervention vs control", margin(top) size(medlarge)) ytitle("Proportion of Maximal Benefit (%)", margin(right) size(medlarge)) xsize(5) ysize(3) ylabel(,nogrid)  name(PMB_HAdiff_base, replace) title("mLAZ = -1.0", size(medium)) xsc(range(0 5)) xlabel(0(1)5)  xline(0, lcolor(gs14) lpattern(-) ) yline(0, lcolor(gs14) lpattern(-)) yline(`yline', lcolor(gs14) lpattern(-)) 



restore 

grc1leg2 PMB_HAdiff_scenarios PMB_HAdiff_base, row(1) graphregion(color(white)) legendfrom(PMB_HAdiff_scenarios) 
gr display, xsize(5) ysize(3)
		
graph save "$dir_fig/PMB_Simulation_HA difference vs PMB Figure_SuppFigure3_Panelled", replace
graph export "$dir_fig/PMB_Simulation_HA difference vs PMB Figure_SuppFigure3_Panelled.png", as(png) replace
	
*****************************************
************END**************************
*****************************************
