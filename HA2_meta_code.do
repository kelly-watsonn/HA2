
// PROJECT: Re-express effect of SQ-LNS as height-age
// PROGRAM: HA2_meta_code
// TASK: Meta-analyze different expressions of SQ-LNS effect
// CREATED BY: Kelly Watson, The Hospital for Sick Children
// DATE: August 15, 2024

// UPDATED: April 11, 2025
// UPDATED BY: Huma Qamar


/* Table of contents: 
PART 1: Meta-analyze effect expressed as HA MD (full sample, n=18)
PART 2: Meta-analyze effect expressed as LAZ MD (full sample, n=18)
PART 3: Meta-analyze effect expressed as Length MD (full sample, n=13)
PART 4: Meta-analyze effect expressed as HA MD (reduced sample, n=12)
PART 5: Meta-analyze effect expressed as LAZ MD (reduced sample, n=12)
PART 6: Meta-analyze effect expressed as PMB
PART 7: Sensitivity analysis - random effects instead of fixed effects model
PART 8: Sensitivity analysis - IPD Studies Only 
PART 9: Sensitivity analysis - IPD Studies Only, Cluster adjusted sample sizes using Cochrane guidelines
*/

global dir_fig_stata "insert file path for where you wish to save .gph Stata native figures"
global dir_fig "insert file path for where you wish to save .png figures and table"
global dir_data "insert file path where analysis dataset is located"


*****************************************
*****************************************
** PART 1: Meta-analyze effect expressed as HA MD (full sample, n=18)


use  "$dir_data/meta_input_data_full", clear

sort Order

// using the means, standard deviations and sample sizes
// format: metan n_treat mean_treat sd_treat n_ctrl mean_ctrl sd_ctrl 
preserve 
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C,  label(namevar = countrytrial) forestplot(dp(1))  fixed nostandard saving(metan_ha, replace) nograph

// extract estimates for first table in additional file 4
gen n = r(n)
gen studies = r(k)
gen eff = r(ovstats)[1,1]
gen lb = r(ovstats)[3,1]
gen ub = r(ovstats)[4,1]

//******NOTE - you cannot automatically extract the 95% CI of I-squared from metan, so these have been manually saved; if any changes made to the study, this will have to be updated*****
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




gr save "$dir_fig_stata/HA2_Figure 4_HAMD", replace
gr export "$dir_fig/HA2_Figure 4_HAMD.png", replace as(png)

restore

/*
Studies included: 18
Participants included: 36970

Meta-analysis pooling of  Weighted Mean Differences
using the common-effect inverse-variance model

------------------------------------------------------------------------
RevMan                   |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408      14.08
Bangladesh; RDNS         |     7.000     -0.211    14.211       7.92
Bangladesh; WASH-B       |    17.000     10.054    23.946       8.54
Burkina Faso; iLiNS-Zinc |    20.000     12.174    27.826       6.72
Burkina Faso; PROMIS     |    10.000      2.929    17.071       8.24
Burkina Faso; PROMIS-CS  |     9.000     -1.966    19.966       3.42
Ghana; GHANA             |    16.000     -2.398    34.398       1.22
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       3.60
Haiti; HAITI             |    24.000      4.552    43.448       1.09
Kenya; WASH-B            |    16.000      9.735    22.265      10.49
Madagascar; MAHAY        |    10.000     -5.700    25.700       1.67
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       4.63
Malawi; iLiNS−DYAD−M     |    -4.000    -17.601     9.601       2.23
Mali; PROMIS             |    24.000     11.979    36.021       2.85
Mali; PROMIS CS          |    18.000      7.034    28.966       3.42
South Africa; TSWAKA     |    -6.000    -18.206     6.206       2.76
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315      14.58
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       2.54
-------------------------+----------------------------------------------
Overall, IV              |    11.470      9.441    13.499     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  11.078  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     42.86       17      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.588     1.154     2.005
I² (%)                   |     60.3%     24.9%     75.1%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)



*/


*****************************************
*****************************************


*****************************************
*****************************************
** PART 2: Meta-analyze effect expressed as LAZ MD (full sample, n=18)


preserve 
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lhaz, replace) nograph

// extract estimates for first table in additional file 4
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

/*

Studies included: 18
Participants included: 36970

Meta-analysis pooling of  Weighted Mean Differences
using the common-effect inverse-variance model

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162      12.49
Bangladesh; RDNS         |     0.075     -0.004     0.154       9.04
Bangladesh; WASH-B       |     0.207      0.139     0.276      12.06
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       5.60
Burkina Faso; PROMIS     |     0.130      0.041     0.219       7.19
Burkina Faso; PROMIS-CS  |     0.055     -0.072     0.181       3.54
Ghana; GHANA             |     0.260     -0.035     0.555       0.65
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       3.37
Haiti; HAITI             |     0.040     -0.220     0.300       0.84
Kenya; WASH-B            |     0.160      0.097     0.223      14.30
Madagascar; MAHAY        |     0.097     -0.047     0.242       2.71
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       2.32
Malawi; iLiNS−DYAD−M     |    -0.055     -0.227     0.117       1.91
Mali; PROMIS             |     0.254      0.129     0.379       3.64
Mali; PROMIS CS          |     0.206      0.102     0.310       5.24
South Africa; TSWAKA     |    -0.130     -0.338     0.078       1.31
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      11.85
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       1.93
-------------------------+----------------------------------------------
Overall, IV              |     0.147      0.123     0.171     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  12.093  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     41.29       17      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.558     1.127     1.973
I² (%)                   |     58.8%     21.2%     74.3%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/

*****************************************
*****************************************
** PART 3: Meta-analyze effect expressed as Length MD (full sample, n=13)


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


/*
Studies included: 13
Participants included: 27056

Meta-analysis pooling of  Weighted Mean Differences
using the common-effect inverse-variance model

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.247      0.050     0.445      19.00
Bangladesh; WASH-B       |     0.544      0.306     0.781      13.14
Burkina Faso; iLiNS-Zinc |     0.725      0.434     1.015       8.79
Burkina Faso; PROMIS     |     0.349      0.098     0.600      11.77
Burkina Faso; PROMIS-CS  |     0.418     -0.026     0.862       3.77
Ghana; iLiNS-DYAD-G      |     0.595      0.221     0.969       5.29
Haiti; HAITI             |     1.060      0.277     1.843       1.21
Kenya; WASH-B            |     0.571      0.363     0.780      17.04
Malawi; iLiNS−DOSE       |     0.028     -0.324     0.380       5.98
Malawi; iLiNS−DYAD−M     |    -0.150     -0.654     0.354       2.92
Mali; PROMIS             |     0.800      0.409     1.192       4.83
Mali; PROMIS CS          |     0.609      0.160     1.057       3.69
South Africa; TSWAKA     |    -0.293     -0.830     0.244       2.57
-------------------------+----------------------------------------------
Overall, IV              |     0.431      0.345     0.518     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   9.822  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     34.60       12      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.698     1.170     2.200
I² (%)                   |     65.3%     27.0%     79.3%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)

*/


*****************************************
*****************************************
** PART 4: Meta-analyze effect expressed as HA MD (reduced sample, n=12***) Changed from 13 to 12 because we no longer are considering Ghana; GHANA to have a proper baseline group

preserve 
keep if restricted_analysis == 1
metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C, label(namevar = countrytrial) forestplot(dp(1) )  fixed nostandard saving(metan_ha_res, replace) nograph

// extract estimates for first table in additional file 4
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

/*

Studies included: 12
Participants included: 19768

Meta-analysis pooling of  Weighted Mean Differences
using the common-effect inverse-variance model

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408      19.77
Bangladesh; RDNS         |     7.000     -0.211    14.211      11.12
Burkina Faso; iLiNS-Zinc |    20.000     12.174    27.826       9.44
Burkina Faso; PROMIS     |    10.000      2.929    17.071      11.56
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       5.05
Haiti; HAITI             |    24.000      4.552    43.448       1.53
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       6.50
Malawi; iLiNS−DYAD−M     |    -4.000    -17.601     9.601       3.13
Mali; PROMIS             |    24.000     11.979    36.021       4.00
South Africa; TSWAKA     |    -6.000    -18.206     6.206       3.88
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315      20.47
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       3.57
-------------------------+----------------------------------------------
Overall, IV              |     9.902      7.498    12.307     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   8.072  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     34.96       11      0.000
                         |            -[95% Conf. Interval]-
H                        |     1.783     1.225     2.311
I² (%)                   |     68.5%     33.4%     81.3%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


*/



*****************************************
*****************************************
** PART 5: Meta-analyze effect expressed as LAZ MD (reduced sample, n=12***)


preserve 
keep if restricted_analysis == 1
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  fixed nostandard saving(metan_lhaz_res, replace) nograph

// extract estimates for first table in additional file 4
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


/*

Studies included: 12
Participants included: 19768

Meta-analysis pooling of  Weighted Mean Differences
using the common-effect inverse-variance model

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162      20.31
Bangladesh; RDNS         |     0.075     -0.004     0.154      14.70
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       9.11
Burkina Faso; PROMIS     |     0.130      0.041     0.219      11.70
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       5.49
Haiti; HAITI             |     0.040     -0.220     0.300       1.37
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       3.77
Malawi; iLiNS−DYAD−M     |    -0.055     -0.227     0.117       3.10
Mali; PROMIS             |     0.254      0.129     0.379       5.92
South Africa; TSWAKA     |    -0.130     -0.338     0.078       2.13
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      19.27
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       3.13
-------------------------+----------------------------------------------
Overall, IV              |     0.133      0.103     0.163     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   8.600  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     33.03       11      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.733     1.179     2.259
I² (%)                   |     66.7%     28.0%     80.4%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)

. use metan_lhaz, clear 
(Results set created by metan)

. 

*/


*****************************************
*****************************************
** PART 6: Meta-analyze effect expressed as PMB

preserve 
keep if restricted_analysis == 1
metan PMB LB_PMB UB_PMB, label(namevar = countrytrial) forestplot(dp(1) )   fixed  saving(metan_pmb, replace) nograph

// extract estimates for first table in additional file 4
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

putexcel B6 = nPC 
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



/* 

Studies included: 12
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.714      2.400     9.028      21.73
Bangladesh; RDNS         |     5.185      1.910     8.460      22.25
Burkina Faso; iLiNS-Zinc |    29.630     24.848    34.412      10.43
Burkina Faso; PROMIS     |    12.222      7.194    17.251       9.44
Ghana; iLiNS-DYAD-G      |    30.000     10.833    49.167       0.65
Haiti; HAITI             |     5.882    -12.999    24.764       0.67
Malawi; iLiNS−DOSE       |     2.222     -4.909     9.353       4.69
Malawi; iLiNS−DYAD−M     |    -6.098    -17.270     5.074       1.91
Mali; PROMIS             |    14.388      8.405    20.372       6.66
South Africa; TSWAKA     |    -2.632    -21.233    15.970       0.69
Zimbabwe; SHINE (HIV−)   |    14.444     10.594    18.295      16.09
Zimbabwe; SHINE (HIV+)   |    16.667      9.610    23.723       4.79
-------------------------+----------------------------------------------
Overall, IV              |    10.925      9.380    12.470     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  13.863  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |    108.13       11      0.000
                         |            -[95% Conf. Interval]-
H                        |     3.135     2.546     3.699
I² (%)                   |     89.8%     84.6%     92.7%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)




*/


*****************************************
*****************************************
** PART 7: Sensitivity analysis - random effects instead of fixed effects model


// Height-age, random effects
preserve
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

putexcel D4 = eff_fixed 


restore

/*

. metan N1I HA_days1I SD_HA1I N1C HA_days1C SD_HA1C, label(namevar = countrytrial) random nostandard nograph

Studies included: 18
Participants included: 36970

Meta-analysis pooling of  Weighted Mean Differences
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408       8.27
Bangladesh; RDNS         |     7.000     -0.211    14.211       7.15
Bangladesh; WASH-B       |    17.000     10.054    23.946       7.32
Burkina Faso; iLiNS-Zinc |    20.000     12.174    27.826       6.78
Burkina Faso; PROMIS     |    10.000      2.929    17.071       7.24
Burkina Faso; PROMIS-CS  |     9.000     -1.966    19.966       5.09
Ghana; GHANA             |    16.000     -2.398    34.398       2.65
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       5.22
Haiti; HAITI             |    24.000      4.552    43.448       2.44
Kenya; WASH-B            |    16.000      9.735    22.265       7.74
Madagascar; MAHAY        |    10.000     -5.700    25.700       3.32
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       5.87
Malawi; iLiNS−DYAD−M     |    -4.000    -17.601     9.601       4.00
Mali; PROMIS             |    24.000     11.979    36.021       4.62
Mali; PROMIS CS          |    18.000      7.034    28.966       5.09
South Africa; TSWAKA     |    -6.000    -18.206     6.206       4.54
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315       8.33
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       4.33
-------------------------+----------------------------------------------
Overall, DL              |    11.696      8.224    15.168     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   6.602  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     42.86       17      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.588     1.013     2.163
I² (%)                   |     60.3%      2.5%     78.6%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


Heterogeneity variance estimates
---------------------------------------
Method                   |     tau²
-------------------------+-------------
DL                       |   30.3285
---------------------------------------



*/

// HAZ, random effects
preserve
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  random nostandard nograph
// extract estimates for first table in additional file 4

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

/*

Studies included: 18
Participants included: 36970

Meta-analysis pooling of  Weighted Mean Differences
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162       8.40
Bangladesh; RDNS         |     0.075     -0.004     0.154       7.72
Bangladesh; WASH-B       |     0.207      0.139     0.276       8.34
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       6.55
Burkina Faso; PROMIS     |     0.130      0.041     0.219       7.18
Burkina Faso; PROMIS-CS  |     0.055     -0.072     0.181       5.31
Ghana; GHANA             |     0.260     -0.035     0.555       1.62
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       5.18
Haiti; HAITI             |     0.040     -0.220     0.300       2.00
Kenya; WASH-B            |     0.160      0.097     0.223       8.66
Madagascar; MAHAY        |     0.097     -0.047     0.242       4.58
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       4.18
Malawi; iLiNS−DYAD−M     |    -0.055     -0.227     0.117       3.69
Mali; PROMIS             |     0.254      0.129     0.379       5.38
Mali; PROMIS CS          |     0.206      0.102     0.310       6.37
South Africa; TSWAKA     |    -0.130     -0.338     0.078       2.83
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221       8.30
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       3.71
-------------------------+----------------------------------------------
Overall, DL              |     0.141      0.100     0.182     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   6.801  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     41.29       17      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.558     1.000     2.127
I² (%)                   |     58.8%      0.0%     77.9%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


Heterogeneity variance estimates
---------------------------------------
Method                   |     tau²
-------------------------+-------------
DL                       |    0.0039
---------------------------------------



*/

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

/*
Studies included: 12
Participants included: 19768

Meta-analysis pooling of  Weighted Mean Differences
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408      11.35
Bangladesh; RDNS         |     7.000     -0.211    14.211      10.12
Burkina Faso; iLiNS-Zinc |    20.000     12.174    27.826       9.70
Burkina Faso; PROMIS     |    10.000      2.929    17.071      10.22
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       7.81
Haiti; HAITI             |    24.000      4.552    43.448       3.97
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       8.61
Malawi; iLiNS−DYAD−M     |    -4.000    -17.601     9.601       6.21
Mali; PROMIS             |    24.000     11.979    36.021       7.03
South Africa; TSWAKA     |    -6.000    -18.206     6.206       6.93
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315      11.41
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       6.65
-------------------------+----------------------------------------------
Overall, DL              |    10.346      5.727    14.965     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   4.390  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     34.96       11      0.000
                         |            -[95% Conf. Interval]-
H                        |     1.783     1.000     2.594
I² (%)                   |     68.5%      0.0%     85.1%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


Heterogeneity variance estimates
---------------------------------------
Method                   |     tau²
-------------------------+-------------
DL                       |   41.3443
---------------------------------------

*/

// HAZ, restricted sample size, random effects 
preserve 
keep if restricted_analysis == 1
metan N1I lhaz1I sd_lhaz1I N1C lhaz1C sd_lhaz1C, label(namevar = countrytrial)  random nostandard nograph
// extract estimates for first table in additional file 4

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


/*
Studies included: 12
Participants included: 19768

Meta-analysis pooling of  Weighted Mean Differences
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162      11.85
Bangladesh; RDNS         |     0.075     -0.004     0.154      11.16
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       9.88
Burkina Faso; PROMIS     |     0.130      0.041     0.219      10.59
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       8.24
Haiti; HAITI             |     0.040     -0.220     0.300       3.64
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       6.92
Malawi; iLiNS−DYAD−M     |    -0.055     -0.227     0.117       6.24
Mali; PROMIS             |     0.254      0.129     0.379       8.50
South Africa; TSWAKA     |    -0.130     -0.338     0.078       4.97
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      11.75
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       6.27
-------------------------+----------------------------------------------
Overall, DL              |     0.128      0.071     0.186     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   4.379  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     33.03       11      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.733     1.000     2.528
I² (%)                   |     66.7%      0.0%     84.4%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


Heterogeneity variance estimates
---------------------------------------
Method                   |     tau²
-------------------------+-------------
DL                       |    0.0061
---------------------------------------
*/

// PMB, restricted sample size, random effects 
preserve
keep if restricted_analysis == 1
metan PMB LB_PMB UB_PMB, label(namevar = countrytrial)  random  nograph
// extract estimates for first table in additional file 4

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

/*
Studies included: 12
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Country; Trial           |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.714      2.400     9.028      10.37
Bangladesh; RDNS         |     5.185      1.910     8.460      10.38
Burkina Faso; iLiNS-Zinc |    29.630     24.848    34.412       9.95
Burkina Faso; PROMIS     |    12.222      7.194    17.251       9.87
Ghana; iLiNS-DYAD-G      |    30.000     10.833    49.167       4.60
Haiti; HAITI             |     5.882    -12.999    24.764       4.68
Malawi; iLiNS−DOSE       |     2.222     -4.909     9.353       9.09
Malawi; iLiNS−DYAD−M     |    -6.098    -17.270     5.074       7.40
Mali; PROMIS             |    14.388      8.405    20.372       9.54
South Africa; TSWAKA     |    -2.632    -21.233    15.970       4.76
Zimbabwe; SHINE (HIV−)   |    14.444     10.594    18.295      10.23
Zimbabwe; SHINE (HIV+)   |    16.667      9.610    23.723       9.12
-------------------------+----------------------------------------------
Overall, DL              |    10.938      5.509    16.366     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   3.949  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |    108.13       11      0.000
                         |            -[95% Conf. Interval]-
H                        |     3.135     1.499     4.786
I² (%)                   |     89.8%     55.5%     95.6%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


Heterogeneity variance estimates
---------------------------------------
Method                   |     tau²
-------------------------+-------------
DL                       |   71.1214
---------------------------------------

*/


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


