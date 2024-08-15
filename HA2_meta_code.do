
// PROJECT: Re-express effect of SQ-LNS as height-age
// PROGRAM: HA2_meta_code
// TASK: Meta-analyze different expressions of SQ-LNS effect
// CREATED BY: Kelly Watson, The Hospital for Sick Children
// DATE: August 15, 2024


/* Table of contents: 
PART 1: Meta-analyze effect expressed as HA MD (full sample, n=18)
PART 2: Meta-analyze effect expressed as LAZ MD (full sample, n=18)
PART 3: Meta-analyze effect expressed as HA MD (reduced sample, n=13)
PART 4: Meta-analyze effect expressed as LAZ MD (reduced sample, n=13)
PART 5: Meta-analyze effect expressed as PMB
PART 6: Sensitivity analysis - random effects instead of fixed effects model
*/


*****************************************
*****************************************
** PART 1: Meta-analyze effect expressed as HA MD (full sample, n=18)

use "meta_input_data_full.dta", clear
metan ha_md ha_se, label(namevar=Study) fixed

/*OUTPUT
Studies included: 18
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

-----------------------------------------------------------------------
Country_Trial           |   Effect    [95% Conf. Interval]   % Weight
------------------------+----------------------------------------------
Bangladesh_JiVitA−4     |     5.000     -0.408    10.408      14.03
Bangladesh_RDNS         |     7.000     -0.211    14.211       7.89
Bangladesh_WASH-B       |    17.000     10.054    23.946       8.51
Burkina Faso_iLiNS-Zinc |    20.000     11.938    28.062       6.32
Burkina Faso_PROMIS     |    10.000      2.929    17.071       8.21
Burkina Faso_PROMIS-CS  |     9.000     -1.966    19.966       3.41
Ghana_GHANA             |    16.000     -2.398    34.398       1.21
Ghana_iLiNS-DYAD-G      |    17.000      6.300    27.700       3.59
Haiti_HAITI             |    24.000      7.030    40.970       1.43
Kenya_WASH-B            |    17.000     10.735    23.265      10.46
Madagascar_MAHAY        |    10.000     -5.700    25.700       1.67
Malawi_iLiNS−DOSE       |     2.000     -7.434    11.434       4.61
Malawi_iLiNS−DYAD−M     |    -4.000    -17.200     9.200       2.36
Mali_PROMIS             |    24.000     11.979    36.021       2.84
Mali_PROMIS-CS          |    17.000      6.034    27.966       3.41
South Africa_TSWAKA     |    -2.000    -13.714     9.714       2.99
Zimbabwe_SHINE (HIV−)   |    12.000      6.685    17.315      14.53
Zimbabwe_SHINE (HIV+)   |    19.000      6.272    31.728       2.53
------------------------+----------------------------------------------
Overall, IV             |    11.607      9.581    13.633     100.00
-----------------------------------------------------------------------

Test of overall effect = 0:  z =  11.229  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
------------------------------------------------------------
Measure                 |     Value      df      p-value
------------------------+-----------------------------------
Cochran's Q             |     41.19       17      0.001
                        |            -[95% Conf. Interval]-
H                       |     1.557     1.125     1.971
I² (%)                  |     58.7%     21.0%     74.3%
------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


*/


*****************************************
*****************************************
** PART 2: Meta-analyze effect expressed as LAZ MD (full sample, n=18)

use "meta_input_data_full.dta", clear
metan laz_md laz_se, label(namevar=Study) fixed

/*OUTPUT
Studies included: 18
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162      12.52
Bangladesh; RDNS         |     0.075     -0.004     0.154       9.06
Bangladesh; WASH-B       |     0.207      0.139     0.276      12.09
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       5.62
Burkina Faso; PROMIS     |     0.130      0.041     0.219       7.19
Burkina Faso; PROMIS-CS  |     0.055     -0.072     0.181       3.55
Ghana; GHANA             |     0.260     -0.035     0.555       0.65
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       3.38
Haiti; HAITI             |     0.040     -0.220     0.300       0.84
Kenya; WASH-B            |     0.160      0.097     0.223      14.34
Madagascar; MAHAY        |     0.097     -0.047     0.242       2.72
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       2.33
Malawi; iLiNS−DYAD−M     |     0.020     -0.167     0.207       1.62
Mali; PROMIS             |     0.260      0.135     0.385       3.65
Mali; PROMIS-CS          |     0.200      0.096     0.304       5.20
South Africa; TSWAKA     |     0.070     -0.130     0.270       1.42
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      11.88
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       1.93
-------------------------+----------------------------------------------
Overall, IV              |     0.151      0.127     0.175     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  12.426  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     31.49       17      0.017
                         |            -[95% Conf. Interval]-
H                        |     1.361     1.000     1.760
I² (%)                   |     46.0%      0.0%     67.7%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)

*/


*****************************************
*****************************************
** PART 3: Meta-analyze effect expressed as HA MD (reduced sample, n=13)

use "meta_input_data_red.dta", clear
metan ha_md ha_se, label(namevar=Study) fixed

/*OUTPUT
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408      19.35
Bangladesh; RDNS         |     7.000     -0.211    14.211      10.88
Burkina Faso; iLiNS-Zinc |    20.000     11.938    28.062       8.71
Burkina Faso; PROMIS     |    10.000      2.929    17.071      11.32
Ghana; GHANA             |    16.000     -2.398    34.398       1.67
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       4.94
Haiti; HAITI             |    24.000      7.030    40.970       1.96
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       6.36
Malawi; iLiNS−DYAD−M     |    -4.000    -17.200     9.200       3.25
Mali; PROMIS             |    24.000     11.979    36.021       3.92
South Africa; TSWAKA     |    -2.000    -13.714     9.714       4.12
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315      20.03
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       3.49
-------------------------+----------------------------------------------
Overall, IV              |    10.103      7.724    12.482     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   8.324  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     33.31       12      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.666     1.141     2.166
I² (%)                   |     64.0%     23.2%     78.7%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)

*/


*****************************************
*****************************************
** PART 4: Meta-analyze effect expressed as LAZ MD (reduced sample, n=13)

use "meta_input_data_red.dta", clear
metan laz_md laz_se, label(namevar=Study) fixed

/*OUTPUT

Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162      20.16
Bangladesh; RDNS         |     0.075     -0.004     0.154      14.59
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       9.04
Burkina Faso; PROMIS     |     0.130      0.041     0.219      11.58
Ghana; GHANA             |     0.260     -0.035     0.555       1.05
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       5.45
Haiti; HAITI             |     0.040     -0.220     0.300       1.36
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       3.74
Malawi; iLiNS−DYAD−M     |     0.020     -0.167     0.207       2.61
Mali; PROMIS             |     0.260      0.135     0.385       5.88
South Africa; TSWAKA     |     0.070     -0.130     0.270       2.29
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      19.13
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       3.11
-------------------------+----------------------------------------------
Overall, IV              |     0.142      0.112     0.172     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   9.192  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     24.86       12      0.016
                         |            -[95% Conf. Interval]-
H                        |     1.439     1.000     1.921
I² (%)                   |     51.7%      0.0%     72.9%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)

*/


*****************************************
*****************************************
** PART 5: Meta-analyze effect expressed as PMB

use "meta_input_data_red.dta", clear
metan pmb pmb_se, label(namevar=Study) fixed

/* OUTPUT 

Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.714      2.414     9.015      22.42
Bangladesh; RDNS         |     5.185      1.885     8.486      22.42
Burkina Faso; iLiNS-Zinc |    29.630     24.130    35.129       8.08
Burkina Faso; PROMIS     |    12.222      7.222    17.222       9.77
Ghana; GHANA             |    94.118     34.617   153.618       0.07
Ghana; iLiNS-DYAD-G      |    30.000     10.800    49.200       0.66
Haiti; HAITI             |     5.900    -12.982    24.782       0.69
Malawi; iLiNS−DOSE       |     3.297     -3.704    10.298       4.98
Malawi; iLiNS−DYAD−M     |    -8.642    -20.041     2.757       1.88
Mali; PROMIS             |    15.108      9.108    21.107       6.79
South Africa; TSWAKA     |   -11.429    -33.929    11.072       0.48
Zimbabwe; SHINE (HIV−)   |    14.444     10.644    18.245      16.91
Zimbabwe; SHINE (HIV+)   |    16.667      9.566    23.768       4.84
-------------------------+----------------------------------------------
Overall, IV              |    10.558      8.995    12.121     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  13.240  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |    104.59       12      0.000
                         |            -[95% Conf. Interval]-
H                        |     2.952     2.390     3.491
I² (%)                   |     88.5%     82.5%     91.8%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)

*/


*****************************************
*****************************************
** PART 6: Sensitivity analysis - random effects instead of fixed effects model

use "meta_input_data_full.dta", clear
metan ha_md ha_se, label(namevar=Study) random

/*
Studies included: 18
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408       8.33
Bangladesh; RDNS         |     7.000     -0.211    14.211       7.15
Bangladesh; WASH-B       |    17.000     10.054    23.946       7.32
Burkina Faso; iLiNS-Zinc |    20.000     11.938    28.062       6.61
Burkina Faso; PROMIS     |    10.000      2.929    17.071       7.24
Burkina Faso; PROMIS-CS  |     9.000     -1.966    19.966       5.02
Ghana; GHANA             |    16.000     -2.398    34.398       2.57
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       5.15
Haiti; HAITI             |    24.000      7.030    40.970       2.89
Kenya; WASH-B            |    17.000     10.735    23.265       7.77
Madagascar; MAHAY        |    10.000     -5.700    25.700       3.23
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       5.81
Malawi; iLiNS−DYAD−M     |    -4.000    -17.200     9.200       4.06
Mali; PROMIS             |    24.000     11.979    36.021       4.54
Mali; PROMIS-CS          |    17.000      6.034    27.966       5.02
South Africa; TSWAKA     |    -2.000    -13.714     9.714       4.67
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315       8.39
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       4.24
-------------------------+----------------------------------------------
Overall, DL              |    11.898      8.510    15.286     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   6.883  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     41.19       17      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.557     1.000     2.117
I² (%)                   |     58.7%      0.0%     77.7%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)


*/

use "meta_input_data_full.dta", clear
metan laz_md laz_se, label(namevar=Study) random

/*
Studies included: 18
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162       9.23
Bangladesh; RDNS         |     0.075     -0.004     0.154       8.19
Bangladesh; WASH-B       |     0.207      0.139     0.276       9.13
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       6.55
Burkina Faso; PROMIS     |     0.130      0.041     0.219       7.40
Burkina Faso; PROMIS-CS  |     0.055     -0.072     0.181       5.00
Ghana; GHANA             |     0.260     -0.035     0.555       1.30
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       4.85
Haiti; HAITI             |     0.040     -0.220     0.300       1.64
Kenya; WASH-B            |     0.160      0.097     0.223       9.64
Madagascar; MAHAY        |     0.097     -0.047     0.242       4.19
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       3.75
Malawi; iLiNS−DYAD−M     |     0.020     -0.167     0.207       2.85
Mali; PROMIS             |     0.260      0.135     0.385       5.10
Mali; PROMIS-CS          |     0.200      0.096     0.304       6.28
South Africa; TSWAKA     |     0.070     -0.130     0.270       2.56
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221       9.07
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       3.26
-------------------------+----------------------------------------------
Overall, DL              |     0.150      0.115     0.186     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   8.327  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     31.49       17      0.017
                         |            -[95% Conf. Interval]-
H                        |     1.361     1.000     1.842
I² (%)                   |     46.0%      0.0%     70.5%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneit
> y (based on Q)
*/

use "meta_input_data_red.dta", clear
metan ha_md ha_se, label(namevar=Study) random

/*
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.408    10.408      11.08
Bangladesh; RDNS         |     7.000     -0.211    14.211       9.75
Burkina Faso; iLiNS-Zinc |    20.000     11.938    28.062       9.12
Burkina Faso; PROMIS     |    10.000      2.929    17.071       9.85
Ghana; GHANA             |    16.000     -2.398    34.398       3.88
Ghana; iLiNS-DYAD-G      |    17.000      6.300    27.700       7.33
Haiti; HAITI             |    24.000      7.030    40.970       4.34
Malawi; iLiNS−DOSE       |     2.000     -7.434    11.434       8.15
Malawi; iLiNS−DYAD−M     |    -4.000    -17.200     9.200       5.92
Mali; PROMIS             |    24.000     11.979    36.021       6.55
South Africa; TSWAKA     |    -2.000    -13.714     9.714       6.72
Zimbabwe; SHINE (HIV−)   |    12.000      6.685    17.315      11.14
Zimbabwe; SHINE (HIV+)   |    19.000      6.272    31.728       6.17
-------------------------+----------------------------------------------
Overall, DL              |    10.825      6.529    15.122     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   4.938  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     33.31       12      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.666     1.000     2.391
I² (%)                   |     64.0%      0.0%     82.5%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneit
> y (based on Q)
*/

use "meta_input_data_red.dta", clear
metan laz_md laz_se, label(namevar=Study) random

/*
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.162      12.93
Bangladesh; RDNS         |     0.075     -0.004     0.154      11.80
Burkina Faso; iLiNS-Zinc |     0.297      0.197     0.398       9.88
Burkina Faso; PROMIS     |     0.130      0.041     0.219      10.90
Ghana; GHANA             |     0.260     -0.035     0.555       2.32
Ghana; iLiNS-DYAD-G      |     0.198      0.068     0.327       7.70
Haiti; HAITI             |     0.040     -0.220     0.300       2.88
Malawi; iLiNS−DOSE       |     0.037     -0.119     0.194       6.15
Malawi; iLiNS−DYAD−M     |     0.020     -0.167     0.207       4.81
Mali; PROMIS             |     0.260      0.135     0.385       8.04
South Africa; TSWAKA     |     0.070     -0.130     0.270       4.37
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      12.76
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       5.44
-------------------------+----------------------------------------------
Overall, DL              |     0.147      0.099     0.196     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   5.983  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     24.86       12      0.016
                         |            -[95% Conf. Interval]-
H                        |     1.439     1.000     2.055
I² (%)                   |     51.7%      0.0%     76.3%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneit
> y (based on Q)
*/

use "meta_input_data_red.dta", clear
metan pmb pmb_se, label(namevar=Study) random

/*
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the random-effects inverse-variance model
with DerSimonian-Laird estimate of tau²

------------------------------------------------------------------------
Study                    |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.714      2.414     9.015      10.45
Bangladesh; RDNS         |     5.185      1.885     8.486      10.45
Burkina Faso; iLiNS-Zinc |    29.630     24.130    35.129       9.78
Burkina Faso; PROMIS     |    12.222      7.222    17.222       9.95
Ghana; GHANA             |    94.118     34.617   153.618       0.76
Ghana; iLiNS-DYAD-G      |    30.000     10.800    49.200       4.58
Haiti; HAITI             |     5.900    -12.982    24.782       4.67
Malawi; iLiNS−DOSE       |     3.297     -3.704    10.298       9.20
Malawi; iLiNS−DYAD−M     |    -8.642    -20.041     2.757       7.32
Mali; PROMIS             |    15.108      9.108    21.107       9.59
South Africa; TSWAKA     |   -11.429    -33.929    11.072       3.76
Zimbabwe; SHINE (HIV−)   |    14.444     10.644    18.245      10.32
Zimbabwe; SHINE (HIV+)   |    16.667      9.566    23.768       9.16
-------------------------+----------------------------------------------
Overall, DL              |    11.327      5.930    16.724     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   4.113  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on Gamma (random-effects) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |    104.59       12      0.000
                         |            -[95% Conf. Interval]-
H                        |     2.952     1.415     4.502
I² (%)                   |     88.5%     50.1%     95.1%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneit
> y (based on Q)
*/
