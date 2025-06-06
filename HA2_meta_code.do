
// PROJECT: Re-express effect of SQ-LNS as height-age
// PROGRAM: HA2_meta_code
// TASK: Meta-analyze different expressions of SQ-LNS effect
// CREATED BY: Kelly Watson, The Hospital for Sick Children
// DATE: August 15, 2024

// UPDATED: April 11, 2025
// UPDATED BY: Huma Qamar


/* Table of contents: 
PART 1: Meta-analyze effect expressed as LAZ MD (full sample, n=18)
PART 2: Meta-analyze effect expressed as HA MD (full sample, n=18)
PART 3: Meta-analyze effect expressed as PMB  (n=12)
PART 4: Meta-analyze effect expressed as Length MD (full sample, n=13)
PART 5: Meta-analyze effect expressed as HA MD (reduced sample, n=12)
PART 6: Meta-analyze effect expressed as LAZ MD (reduced sample, n=12)
PART 7: Sensitivity analysis - random effects instead of fixed effects model
PART 8: Sensitivity analysis - IPD Studies Only 
PART 9: Sensitivity analysis - IPD Studies Only, Cluster adjusted sample sizes using Cochrane guidelines


*NOTE: Before running, confirm your version of metan 

Version used for these analysis:
*! version 4.08  David Fisher  17jun2024
*! version 4.08.1  David Fisher  12jul2024
*! Current version by David Fisher
*! Previous versions by Ross Harris and Michael Bradburn



*/

global dir_fig_stata "insert file path for where you wish to save .gph Stata native figures"
global dir_fig "insert file path for where you wish to save .png figures and table"
global dir_data "insert file path where analysis dataset is located"


// import dataset
use  "$dir_data/meta_input_data_full", clear
sort Order

*****************************************
*****************************************
** PART 1: Meta-analyze effect expressed as LAZ MD (full sample, n=18)

// using the means, standard deviations and sample sizes
// format: metan n_treat mean_treat sd_treat n_ctrl mean_ctrl sd_ctrl 
preserve 
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lhaz, replace) nograph

// extract estimates to populate tables
gen n = r(n)
gen studies = r(k)
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

tostring n, replace 
tostring studies, replace
gen nPC = n + " (" + studies + ")"

gen I_sq = "59 (21, 74)"

foreach var of varlist eff lb ub {
	format `var' %5.2f
	tostring `var', replace force usedisplayformat
}
gen eff_fixed = eff + " (" + lb + ", " + ub + ")"

putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Table 2") modify

putexcel B2 = nPC 
putexcel C2 = eff_fixed 
putexcel D2 = I_sq 

putexcel clear


putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel B3 = nPC 
putexcel C3 = eff_fixed 


use metan_lhaz, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:LAZ MD (95% CI)}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white))  pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))   boxopt(mcolor(black)) boxsca(40) textsize(100) 

gr_edit .plotregion1.plot7.style.editstyle marker(fillcolor("0 0 83")) marker(linestyle(color("0 0 83"))) editcopy
gr_edit .plotregion1._xylines[1].z = 20.25


gr save "$dir_fig_stata/HA2_Figure 3_LAZMD", replace
gr export "$dir_fig/HA2_Figure 3_LAZMD.png", replace as(png)

restore

*****************************************
*****************************************

** PART 2: Meta-analyze effect expressed as HA MD (full sample, n=18)

preserve 
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C,  label(namevar = countrytrial) forestplot(dp(1))  fixed nostandard saving(metan_ha, replace) nograph

// extract estimates to populate tables
gen n = r(n)
gen studies = r(k)
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

//******NOTE - you cannot automatically extract the 95% CI of I-squared from metan, so these have been manually saved*****
gen I_sq = "60 (25, 75)"

tostring n, replace 
tostring studies, replace
gen nPC = n + " (" + studies + ")"

foreach var of varlist eff lb ub {
	format `var' %5.1f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"
putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Table 2") modify

putexcel B3 = nPC 
putexcel C3 = eff_fixed 
putexcel D3 = I_sq 

putexcel clear

putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel B4 = nPC 
putexcel C4 = eff_fixed 


use metan_ha, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:Height-age MD (95% CI),}" "{bf:days }""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) dp(1) graphregion(color(white)) pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))  boxsca(85)  boxopt(mcolor(black)) textsize(100) 

gr_edit .plotregion1.plot7.style.editstyle marker(fillcolor("0 0 83")) editcopy
gr_edit .plotregion1.plot7.style.editstyle marker(linestyle(color("0 0 83"))) editcopy

gr_edit .plotregion1._xylines[1].z = 20.25

// save figure
gr save "$dir_fig_stata/HA2_Figure 4_HAMD", replace
gr export "$dir_fig/HA2_Figure 4_HAMD.png", replace as(png)

restore



*****************************************
*****************************************
** PART 3: Meta-analyze effect expressed as PMB

preserve 
keep if restricted_analysis == 1
metan PMB LB_PMB UB_PMB, label(namevar = countrytrial) forestplot(dp(1) )  fixed  saving(metan_pmb, replace) nograph

// extract estimates to populate tables
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

gen I_sq = "90 (85, 93)"

foreach var of varlist eff lb ub {
	format `var' %8.2g
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"

putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Table 2") modify

putexcel C6 = eff_fixed 
putexcel D6 = I_sq 

putexcel clear

putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel C7 = eff_fixed 

use metan_pmb, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:PMB (95% CI), %}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white)) pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))   boxopt(mcolor(black)) boxsca(40) textsize(100) 

gr_edit .plotregion1.plot7.style.editstyle marker(fillcolor("0 0 83")) marker(linestyle(color("0 0 83"))) editcopy
gr_edit .plotregion1._xylines[1].z = 14.25


gr save "$dir_fig_stata/HA2_Figure 5_PMB", replace
gr export "$dir_fig/HA2_Figure 5_PMB.png", replace as(png)

restore


*****************************************
*****************************************
** PART 4: Meta-analyze effect expressed as Length MD (full sample, n=13)


preserve 
metan N1I lenhei_cm1I sd_lenhei1I N1C lenhei_cm1C sd_lenhei1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lenhei, replace) nograph

use metan_lenhei, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:Length MD (95% CI), cm}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white)) pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))   boxopt(mcolor(black)) boxsca(70) textsize(100)

gr_edit .plotregion1.plot7.style.editstyle marker(fillcolor("0 0 83")) marker(linestyle(color("0 0 83"))) editcopy
gr_edit .plotregion1._xylines[1].z = 20.25


gr save "$dir_fig_stata/HA2_Figure_LengthMD", replace
gr export "$dir_fig/HA2_Figure_LengthMD.png", replace as(png)

restore



*****************************************
*****************************************
** PART 5: Meta-analyze effect expressed as HA MD (reduced sample, n=12***) Changed from 13 to 12 because we no longer are considering Ghana; GHANA to have a proper baseline group

preserve 
keep if restricted_analysis == 1
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C, label(namevar = countrytrial) forestplot(dp(1) )  fixed nostandard saving(metan_ha_res, replace) nograph

// extract estimates to populate tables
gen n = r(n)
gen studies = r(k)
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

gen I_sq = "69 (33, 81)"

tostring n, replace 
tostring studies, replace
gen nPC = n + " (" + studies + ")"

foreach var of varlist eff lb ub {
	format `var' %5.1f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"

putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Table 2") modify

putexcel B5 = nPC 
putexcel C5 = eff_fixed 
putexcel D5 = I_sq 

putexcel clear


putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel B6 = nPC 
putexcel C6 = eff_fixed 

use metan_ha_res, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:Height-age MD (95% CI),}" "{bf:days }""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) dp(1) graphregion(color(white))  pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))   boxopt(mcolor(black)) boxsca(50) textsize(100) 

gr_edit .plotregion1.plot7.style.editstyle marker(fillcolor("0 0 83")) editcopy
gr_edit .plotregion1.plot7.style.editstyle marker(linestyle(color("0 0 83"))) editcopy
gr_edit .plotregion1._xylines[1].z = 14.25

gr save "$dir_fig_stata/HA2_Figure Restricted_HAMD", replace
gr export "$dir_fig/HA2_Figure Restricted_HAMD.png", replace

restore



*****************************************
*****************************************
** PART 6: Meta-analyze effect expressed as LAZ MD (reduced sample, n=12***)


preserve 
keep if restricted_analysis == 1
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lhaz_res, replace) nograph

// extract estimates to populate tables
gen n = r(n)
gen studies = r(k)
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

tostring n, replace 
tostring studies, replace
gen nPC = n + " (" + studies + ")"

gen I_sq = "67 (28, 80)"

foreach var of varlist eff lb ub {
	format `var' %5.2f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"

putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Table 2") modify

putexcel B4 = nPC 
putexcel C4 = eff_fixed 
putexcel D4 = I_sq 
// also going to fill in the PMB row with the sample size since it is the same
putexcel B6 = nPC

putexcel clear


putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel B5 = nPC 
putexcel C5 = eff_fixed 
// also going to fill in the PMB row with the sample size since it is the same
putexcel B7 = nPC

use metan_lhaz_res, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:LAZ MD (95% CI)}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot,  useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white)) pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-)) boxsca(60) boxopt(mcolor(black)) boxopt(mcolor(black)) boxsca(60) textsize(100) 

gr_edit .plotregion1.plot7.style.editstyle marker(fillcolor("0 0 83")) marker(linestyle(color("0 0 83"))) editcopy
gr_edit .plotregion1._xylines[1].z = 14.25


gr save "$dir_fig_stata/HA2_Figure Restricted_LAZMD", replace
gr export "$dir_fig/HA2_Figure Restricted_LAZMD.png", replace as(png)

restore






*****************************************
*****************************************
** PART 7: Sensitivity analysis - random effects instead of fixed effects model


// Height-age, random effects
preserve
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C, label(namevar = countrytrial) random nostandard nograph

// extract estimates to populate tables
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

foreach var of varlist eff lb ub {
	format `var' %5.1f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"
putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel D4 = eff_fixed 


restore


// HAZ, random effects
preserve
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  random nostandard nograph

// extract estimates to populate tables
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

foreach var of varlist eff lb ub {
	format `var' %5.2f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"
putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel D3 = eff_fixed 

restore 


// Height-age, restricted sample size, random effects 
preserve 
keep if restricted_analysis == 1
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C, label(namevar = countrytrial) random nostandard nograph
// extract estimates for first table in additional file 4

gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

foreach var of varlist eff lb ub {
	format `var' %5.1f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"
putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel D6 = eff_fixed 

restore 


// HAZ, restricted sample size, random effects 
preserve 
keep if restricted_analysis == 1
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  random nostandard nograph

// extract estimates to populate tables
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

foreach var of varlist eff lb ub {
	format `var' %5.2f
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"
putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel D5 = eff_fixed 

restore


// PMB, restricted sample size, random effects 
preserve
keep if restricted_analysis == 1
metan PMB LB_PMB UB_PMB, label(namevar = countrytrial)  random  nograph

// extract estimates to populate tables
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

foreach var of varlist eff lb ub {
	format `var' %8.2g
	tostring `var', replace force usedisplayformat
}

gen eff_fixed = eff + " (" + lb + ", " + ub + ")"
putexcel set "$dir_fig/HA2_tables.xlsx", sheet("Random effects") modify

putexcel D7 = eff_fixed 

restore



*****************************************
*****************************************
** PART 8: Sensitivity analysis - IPD Studies Only 

// PMB
preserve 
keep if IPD == 1
metan PMB LB_PMB UB_PMB, label(namevar = countrytrial) forestplot(dp(1) )   fixed  saving(metan_pmb_ipd, replace) nograph
use metan_pmb_ipd, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:PMB (95% CI), %}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1


forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white))  pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-)) boxopt(mcolor(black)) textsize(115) 
gr_edit .plotregion1._xylines[1].z = 4.5

gr save "$dir_fig_stata/HA2_Figure_IPD_PMB", replace
gr export "$dir_fig/HA2_Figure_IPD_PMB.png", replace as(png)
gr export "$dir_fig/HA2_Figure_IPD_PMB.emf", replace as(png)

restore

// HAZ
preserve 
keep if IPD == 1
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lhaz_ipd, replace) nograph

use metan_lhaz_ipd, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:LAZ MD (95% CI)}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot,  useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white)) pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-)) boxsca(60) boxopt(mcolor(black)) boxopt(mcolor(black)) boxsca(60) textsize(100)

gr_edit .plotregion1._xylines[1].z =8.25


gr save "$dir_fig_stata/HA2_Figure_IPD_LAZMD", replace
gr export "$dir_fig/HA2_Figure_IPD_LAZMD.png", replace as(png)
gr export "$dir_fig/HA2_Figure_IPD_LAZMD.emf", replace as(png)

restore

// Height-age
preserve 
keep if IPD == 1
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C, label(namevar = countrytrial) forestplot(dp(1) )  fixed nostandard saving(metan_ha_ipd, replace) nograph 

use metan_ha_ipd, clear 

// edit labels to make them bold, format weights to 2 significant digits
label var _EFFECT `""{bf:Height-age MD (95% CI),}" "{bf:days }""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) dp(1) graphregion(color(white))  pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))   boxopt(mcolor(black)) boxsca(50) textsize(115) 

gr_edit .plotregion1._xylines[1].z = 8.25

gr save "$dir_fig_stata/HA2_Figure IPD_HAMD", replace
gr export "$dir_fig/HA2_Figure IPD_HAMD.png", replace

restore


*****************************************
*****************************************
** PART 9: Sensitivity analysis - IPD Studies Only, Cluster adjusted sample sizes using Cochrane guidelines


preserve 
keep if IPD == 1
metan cluster_adjusted_N1I lhaz1I sd_lhaz1I cluster_adjusted_N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lhaz_ipd_cluster, replace) nograph

use metan_lhaz_ipd_cluster, clear 

// edit labels to make them bold, format weights to 2 signficant digits
label var _EFFECT `""{bf:LAZ MD (95% CI)}""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot,  useopts nostats nowt rcols(_EFFECT _WT_str) graphregion(color(white)) pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-)) boxsca(60) boxopt(mcolor(black)) boxopt(mcolor(black)) boxsca(60) textsize(100) 

gr_edit .plotregion1._xylines[1].z =8.25


gr save "$dir_fig_stata/HA2_Figure_IPD_LAZMD_ClusterAdjusted", replace
gr export "$dir_fig/HA2_Figure_IPD_LAZMD_ClusterAdjusted.png", replace as(png)

restore

preserve 
keep if IPD == 1
metan cluster_adjusted_N1I HA_days1I SD_HA1I cluster_adjusted_N1C HA_days1C SD_HA1C, label(namevar = countrytrial) forestplot(dp(1) )  fixed nostandard saving(metan_ha_ipd_cluster, replace) nograph

use metan_ha_ipd_cluster, clear 

// edit labels to make them bold, format weights to 2 signficant digits
label var _EFFECT `""{bf:Height-age MD (95% CI),}" "{bf:days }""' 
label var _LABELS `"{bf:Country; Trial}"'
label var _WT `""{bf:Weight, %}""'
format _WT %8.2g 
tostring _WT, gen(_WT_str) force usedisplayformat
replace _WT_str = "0" + _WT_str if _WT < 1
replace _WT_str = _WT_str + ".0" if strlen(_WT_str) == 1

forestplot, useopts nostats nowt rcols(_EFFECT _WT_str) dp(1) graphregion(color(white))  pointopts(msymbol(square)) oline1opts(lcolor(black) lpattern(-))   boxopt(mcolor(black)) boxsca(50) textsize(100) 

gr_edit .plotregion1._xylines[1].z = 8.25

gr save "$dir_fig_stata/HA2_Figure IPD_HAMD_ClusterAdjusted", replace
gr export "$dir_fig/HA2_Figure IPD_HAMD_ClusterAdjusted.png", replace

restore


