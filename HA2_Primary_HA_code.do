
// PROJECT: Re-express HAZ as height-age for meta-analysis the effect of SQ-LNS intervention on linear growth
// PROGRAM: HA2_Primary Analysis Datset Generation_Derive Height-age_PMB_effect estimates_code
// TASK: Estimate height-age and PMB from reported HAZ/height
// CREATED BY: Kelly Watson, The Hospital for Sick Children
// DATE: July 29, 2024


/* Table of contents: 
PART 1: Calculate height-age using length (if available)
PART 2: Calculate height-age using LAZ if length not available
PART 3: Discontinuity adjustment for height-ages calculated at/near 2 years 
PART 4: Effect estimates 

*/

global dir_pooled "insert file path where source dataset is located"
global dir_metrics "insert file path where anlaysis dataset will be saved"

cd "$dir_metrics"

*****************************************
*****************************************
** PART 1: Calculate HA using length if available

* Calculate 95% CI if only given SD
use "$dir_pooled/HA2_ExtractDat_CombineGrps.dta", clear
gen CI_width_len=(sd_lenhei*3.92)/sqrt(n)
gen UB_lenhei = lenhei_cm+(CI_width/2)
gen LB_lenhei = lenhei_cm-(CI_width/2)

gen row_count=_n 
gen HA_days=. 
gen UBHA_days=.
gen LBHA_days=.

save "Primary.dta", replace

* Generate sex-weighted WHO-LMS table then calculate height-age (95% CI) for each study
count
local N = r(N)
foreach counter of numlist 1/`N' {
	use "Primary.dta", clear
	keep if row_count==`counter'
	scalar girls_prop=g_prop
	use "lenanthro.dta", clear 
		rename __000001 sex
		generate prop_m=m*girls_prop if sex==2 // m adjusted for proportion of girls
		replace prop_m=m*(1-girls_prop) if sex==1 // m adjusted for proportion of boys
		bysort _agedays: egen wt_m=sum(prop_m) // weighted average of "m"
		generate prop_s=s*girls_prop if sex==2 // s adjusted for proportion of girls
		replace prop_s=s*(1-girls_prop) if sex==1 // s adjusted for proportion of boys
		bysort _agedays: egen wt_s=sum(prop_s) // weighted average of "s"
	collapse (mean) l wt_m wt_s, by(_agedays) 
	rename wt_m m
	rename wt_s s
	gen merger = 1
	save "lenanthro_wt.dta", replace

use "Primary.dta", clear
gen merger = 1 
keep if row_count==`counter'
joinby merger using "lenanthro_wt.dta"
drop HA_days UBHA_days LBHA_days
	sort lenhei_cm
	replace lenhei_cm = lenhei_cm[1] if missing(lenhei_cm) 
	bysort _agedays: egen minabs_diff = min(abs(lenhei_cm - m))
	sort minabs_diff
	gen HA_days = _agedays[1]
	drop minabs_diff
    
	sort UB_lenhei
	replace UB_lenhei = UB_lenhei[1] if missing(UB_lenhei) 
	bysort _agedays: egen minabs_diff = min(abs(UB_lenhei - m))
	sort minabs_diff
	gen UBHA_days = _agedays[1]
	drop minabs_diff
    
	sort LB_lenhei
	replace LB_lenhei = LB_lenhei[1] if missing(LB_lenhei) 
	bysort _agedays: egen minabs_diff = min(abs(LB_lenhei - m))
	sort minabs_diff
	gen LBHA_days = _agedays[1]

drop if _n != 1
keep row_count HA_days UBHA_days LBHA_days
merge 1:1 row_count using "Primary.dta"
drop _merge
save "Primary.dta", replace
clear
}

use "Primary.dta", clear
sort row_count
order countrytrial authoryear id group time n age_days HA_days LBHA_days UBHA_days
save, replace
replace HA_days=. if lenhei_cm==.
replace LBHA_days=. if lenhei_cm==.
replace UBHA_days=. if lenhei_cm==.
save, replace


*****************************************
*****************************************
** PART 2: Calculate HA using LAZ if HA=. 

gen LHA_days=.
gen LUBHA_days=.
gen LLBHA_days=.
gen c_len=. 
gen c_UBlen=. 
gen c_LBlen=. 
gen LCI_width=(sd_lhaz*3.92)/sqrt(n)
gen LB_LHAZ = lhaz-(LCI_width/2)
gen UB_LHAZ = lhaz+(LCI_width/2)

save, replace 

count
local N = r(N)
foreach counter of numlist 1/`N' {
	use "Primary.dta", clear
	keep if row_count==`counter'
	scalar girls_prop=g_prop
	use "lenanthro.dta", clear 
		rename __000001 sex
		generate prop_m=m*girls_prop if sex==2 // m adjusted for proportion of girls
		replace prop_m=m*(1-girls_prop) if sex==1 // m adjusted for proportion of boys
		bysort _agedays: egen wt_m=sum(prop_m) // weighted average of "m"
		generate prop_s=s*girls_prop if sex==2 // s adjusted for proportion of girls
		replace prop_s=s*(1-girls_prop) if sex==1 // s adjusted for proportion of boys
		bysort _agedays: egen wt_s=sum(prop_s) // weighted average of "s"
	collapse (mean) l wt_m wt_s, by(_agedays) 
	rename wt_m m
	rename wt_s s
	gen merger = 1
	save "lenanthro_wt.dta", replace

use "Primary.dta", clear
gen merger = 1 
keep if row_count==`counter'
joinby merger using "lenanthro_wt.dta"
drop LHA_days LUBHA_days LLBHA_days c_len c_UBlen c_LBlen
	gen c_len = m*((lhaz*s)+1) if _agedays == age_days
	sort c_len
	replace c_len = c_len[1] if missing(c_len) 
	bysort _agedays: egen minabs_diff = min(abs(c_len - m))
	sort minabs_diff
	gen LHA_days = _agedays[1]
	drop minabs_diff
    gen c_UBlen = m*((UB_LHAZ*s)+1) if _agedays == age_days
	sort c_UBlen
	replace c_UBlen = c_UBlen[1] if missing(c_UBlen) 
	bysort _agedays: egen minabs_diff = min(abs(c_UBlen - m))
	sort minabs_diff
	gen LUBHA_days = _agedays[1]
	drop minabs_diff
    gen c_LBlen = m*((LB_LHAZ*s)+1) if _agedays == age_days
	sort c_LBlen
	replace c_LBlen = c_LBlen[1] if missing(c_LBlen) 
	bysort _agedays: egen minabs_diff = min(abs(c_LBlen - m))
	sort minabs_diff
	gen LLBHA_days = _agedays[1]

drop if _n != 1
keep row_count LHA_days LUBHA_days LLBHA_days c_len c_UBlen c_LBlen
merge 1:1 row_count using "Primary.dta"
drop _merge
save "Primary.dta", replace
clear
}

use "Primary.dta", clear
order countrytrial authoryear id group time n age_days HA_days LBHA_days UBHA_days
replace HA_days=LHA_days if HA_days==.
replace LBHA_days=LLBHA_days if LBHA_days==.
replace UBHA_days=LUBHA_days if UBHA_days==.
save, replace


*****************************************
*****************************************
** PART 3: Discontinuity adjustment for height-ages calculated at/near 2 years

* Convert all median values to height in the WHO-LMS table
use "lenanthro.dta", clear
rename __000001 sex
gen m2 = m-0.7 if _agedays < 731
replace m2 = m if m2==.
drop m
rename m2 m
save "lenanthro_height.dta", replace

* Identify and isolate all length/LAZ measures taken >2years
use "Primary.dta", clear
sort age_days
keep if age_days >730
drop row_count
gen row_count=_n
save "age_gt_730.dta", replace

* Re-calculate height-age using adjusted WHO-LMS table from height
count
local N = r(N)
foreach counter of numlist 1/`N' {
	use "age_gt_730.dta", clear
	keep if row_count==`counter'
	scalar girls_prop=g_prop
	use "lenanthro_height.dta", clear 
		generate prop_m=m*girls_prop if sex==2 // m adjusted for proportion of girls
		replace prop_m=m*(1-girls_prop) if sex==1 // m adjusted for proportion of boys
		bysort _agedays: egen wt_m=sum(prop_m) // weighted average of "m"
		generate prop_s=s*girls_prop if sex==2 // s adjusted for proportion of girls
		replace prop_s=s*(1-girls_prop) if sex==1 // s adjusted for proportion of boys
		bysort _agedays: egen wt_s=sum(prop_s) // weighted average of "s"
	collapse (mean) l wt_m wt_s, by(_agedays) 
	rename wt_m m
	rename wt_s s
	gen merger = 1
	save "lenanthro_height_wt.dta", replace

use "age_gt_730.dta", clear
gen merger = 1 
keep if row_count==`counter'
joinby merger using "lenanthro_height_wt.dta"
drop HA_days UBHA_days LBHA_days
	sort lenhei_cm
	replace lenhei_cm = lenhei_cm[1] if missing(lenhei_cm) 
	bysort _agedays: egen minabs_diff = min(abs(lenhei_cm - m))
	sort minabs_diff
	gen HA_days = _agedays[1]
	drop minabs_diff
    
	sort UB_lenhei
	replace UB_lenhei = UB_lenhei[1] if missing(UB_lenhei) 
	bysort _agedays: egen minabs_diff = min(abs(UB_lenhei - m))
	sort minabs_diff
	gen UBHA_days = _agedays[1]
	drop minabs_diff
    
	sort LB_lenhei
	replace LB_lenhei = LB_lenhei[1] if missing(LB_lenhei) 
	bysort _agedays: egen minabs_diff = min(abs(LB_lenhei - m))
	sort minabs_diff
	gen LBHA_days = _agedays[1]

drop if _n != 1
keep row_count HA_days UBHA_days LBHA_days
merge 1:1 row_count using "age_gt_730.dta"
drop _merge
save "age_gt_730.dta", replace
clear
}

use "age_gt_730.dta", clear
sort row_count
order countrytrial authoryear id group time n age_days HA_days LBHA_days UBHA_days
save, replace
replace HA_days=. if lenhei_cm==.
replace LBHA_days=. if lenhei_cm==.
replace UBHA_days=. if lenhei_cm==.
save, replace

* Re-calculate height-age using adjusted WHO-LMS table from HAZ
count
local N = r(N)
foreach counter of numlist 1/`N' {
	use "age_gt_730.dta", clear
	keep if row_count==`counter'
	scalar girls_prop=g_prop
	use "lenanthro_height.dta", clear 
		generate prop_m=m*girls_prop if sex==2 // m adjusted for proportion of girls
		replace prop_m=m*(1-girls_prop) if sex==1 // m adjusted for proportion of boys
		bysort _agedays: egen wt_m=sum(prop_m) // weighted average of "m"
		generate prop_s=s*girls_prop if sex==2 // s adjusted for proportion of girls
		replace prop_s=s*(1-girls_prop) if sex==1 // s adjusted for proportion of boys
		bysort _agedays: egen wt_s=sum(prop_s) // weighted average of "s"
	collapse (mean) l wt_m wt_s, by(_agedays) 
	rename wt_m m
	rename wt_s s
	gen merger = 1
	save "lenanthro_height_wt.dta", replace

use "age_gt_730.dta", clear
gen merger = 1 
keep if row_count==`counter'
joinby merger using "lenanthro_height_wt.dta"
drop LHA_days LUBHA_days LLBHA_days c_len c_UBlen c_LBlen
	gen c_len = m*((lhaz*s)+1) if _agedays == age_days
	sort c_len
	replace c_len = c_len[1] if missing(c_len) 
	bysort _agedays: egen minabs_diff = min(abs(c_len - m))
	sort minabs_diff
	gen LHA_days = _agedays[1]
	drop minabs_diff
    gen c_UBlen = m*((UB_LHAZ*s)+1) if _agedays == age_days
	sort c_UBlen
	replace c_UBlen = c_UBlen[1] if missing(c_UBlen) 
	bysort _agedays: egen minabs_diff = min(abs(c_UBlen - m))
	sort minabs_diff
	gen LUBHA_days = _agedays[1]
	drop minabs_diff
    gen c_LBlen = m*((LB_LHAZ*s)+1) if _agedays == age_days
	sort c_LBlen
	replace c_LBlen = c_LBlen[1] if missing(c_LBlen) 
	bysort _agedays: egen minabs_diff = min(abs(c_LBlen - m))
	sort minabs_diff
	gen LLBHA_days = _agedays[1]

drop if _n != 1
keep row_count LHA_days LUBHA_days LLBHA_days c_len c_UBlen c_LBlen
merge 1:1 row_count using "age_gt_730.dta"
drop _merge
save "age_gt_730.dta", replace
clear
}

use "age_gt_730.dta", clear
order countrytrial authoryear id group time n age_days HA_days LBHA_days UBHA_days
replace HA_days=LHA_days if HA_days==.
replace LBHA_days=LLBHA_days if LBHA_days==.
replace UBHA_days=LUBHA_days if UBHA_days==.
save, replace

* Replace height-age estimates with discontinuity adjusted estimates
merge 1:1 LCI_width using "Primary.dta"
drop _merge
save "Primary.dta", replace
save, replace


*****************************************
*****************************************
** PART 4: Effect estimates

* a) delta-HA MD, HAZ MD, Length MD

use "Primary.dta", clear
rename n N
gen SD_HA = sqrt(N)*(UBHA_days-LBHA_days)/3.92

tostring time, replace
gen timegroup = time+group
keep N SD_HA HA_days sd_lhaz lenhei_cm lhaz sd_lenhei age_days id timegroup countrytrial authoryear 
reshape wide  N SD_HA HA_days sd_lhaz lhaz lenhei_cm sd_lenhei age_days, i(countrytrial authoryear id) j(timegroup) string

gen D_HA_C01 = HA_days1C - HA_days0C
gen D_HA_I01 = HA_days1I - HA_days0I

gen corr_01_C=(0.8+(0.016*(age_days0C/30.4375))+(-0.0037*(age_days1C/30.4375)))
gen corr_01_I=(0.8+(0.016*(age_days0I/30.4375))+(-0.0037*(age_days1I/30.4375)))

gen SDc_C01 = sqrt((SD_HA0C^2+SD_HA1C^2)-(2*corr_01_C*SD_HA0C*SD_HA1C))
gen SDc_I01 = sqrt((SD_HA0I^2+SD_HA1I^2)-(2*corr_01_I*SD_HA0I*SD_HA1I))

gen D_HA_MD = D_HA_I01 - D_HA_C01 // to cross-check w/ RevMan output

// laz and length mean difference
gen laz_md = lhaz1I - lhaz1C 
gen lenhei_cm_md = lenhei_cm1I - lenhei_cm1C

order id countrytrial authoryear D_HA_I01 SDc_I01 N1I D_HA_C01 SDc_C01 N1C D_HA_MD

* b) PMB
gen optimal = age_days1I-age_days0I
gen PMB = ((D_HA_I01-D_HA_C01)/(optimal-D_HA_C01))*100

gen CIwidth_C01 = SDc_C01*3.92/sqrt(N1C)
gen CIwidth_I01 = SDc_I01*3.92/sqrt(N1I)
gen LB_D_HA_C01 = D_HA_C01-(CIwidth_C01/2)
gen UB_D_HA_C01 = D_HA_C01+(CIwidth_C01/2)
gen LB_D_HA_I01 = D_HA_I01-(CIwidth_I01/2)
gen UB_D_HA_I01 = D_HA_I01+(CIwidth_I01/2)

gen S_pooled = sqrt((((N1C-1)*SDc_C01^2)+((N1I-1)*SDc_I01^2))/(N1C+N1I-2))
gen se = S_pooled*sqrt((1/N1C)+(1/N1I))
gen df = N1C+N1I-2
gen tcrit = invttail(df,0.05/2)

gen LB_D_HA_MD = D_HA_MD-(tcrit*se)
gen UB_D_HA_MD = D_HA_MD+(tcrit*se)


gen LB_PMB = ((LB_D_HA_MD)/(optimal-D_HA_C01))*100
gen UB_PMB = ((UB_D_HA_MD)/(optimal-D_HA_C01))*100

egen N = rowtotal(N1I N1C N0C N0I)

order id countrytrial authoryear PMB LB_PMB UB_PMB 


// keep relevant variables for primary analysis dataset -- sample sizes, estimates and standard deviations by group

keep id countrytrial authoryear PMB LB_PMB UB_PMB N* lhaz* lenhei* sd_lenhei* sd_lhaz* HA_days* SD_HA* S_pooled se df tcrit age_days*

// order studies for final figures
generate Order=.
	replace Order=1 if countrytrial== "Bangladesh; JiVitA−4"
	replace Order=2 if countrytrial== "Bangladesh; RDNS"
	replace Order=3 if countrytrial== "Bangladesh; WASH-B"
	replace Order=4 if countrytrial== "Burkina Faso; iLiNS-Zinc" 
	replace Order=5 if countrytrial== "Burkina Faso; PROMIS"
	replace Order=6 if countrytrial== "Burkina Faso; PROMIS-CS"
	replace Order=7 if countrytrial== "Ghana; GHANA"
	replace Order=8 if countrytrial== "Ghana; iLiNS-DYAD-G"
	replace Order=9 if countrytrial== "Haiti; HAITI"
	replace Order=10 if countrytrial== "Kenya; WASH-B"
	replace Order=11 if countrytrial== "Madagascar; MAHAY"
	replace Order=12 if countrytrial== "Malawi; iLiNS−DOSE"
	replace Order=13 if countrytrial== "Malawi; iLiNS−DYAD−M"
	replace Order=14 if countrytrial== "Mali; PROMIS"
	replace Order=15 if countrytrial== "Mali; PROMIS CS"
	replace Order=16 if countrytrial== "South Africa; TSWAKA"
	replace Order=17 if countrytrial== "Zimbabwe; SHINE (HIV−)"
	replace Order=18 if countrytrial== "Zimbabwe; SHINE (HIV+)"


sort Order

// Sensitivity analysis: restricted analysis indicator variable for those with PMB (i.e. baseline and endline data)
gen restricted_analysis = 1 if PMB != . 


// baseline height-age differences 
gen baseline_HA_diff = HA_days0I - HA_days0C


// import ICC and average cluster size info
merge 1:1 countrytrial using "IPD/HA2_IPD_ICC.dta"
gen IPD = 1 if _merge == 3
drop _merge 

// generate cluster-adjusted N for sensitivity analysis

gen design_effect = 1 + ((avg_cluster - 1)*icc)

gen cluster_adjusted_N = round(N/design_effect)
gen cluster_adjusted_N0I = round(N0I/design_effect)
gen cluster_adjusted_N1I = round(N1I/design_effect)
gen cluster_adjusted_N0C = round(N0C/design_effect)
gen cluster_adjusted_N1C = round(N1C/design_effect)

save "meta_input_data_full", replace
export delimited using "meta_input_data_full.csv", replace







