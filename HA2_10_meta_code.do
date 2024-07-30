
// PROJECT: Re-express effect of SQ-LNS as height-age
// PROGRAM: HA2_meta
// TASK: Meta-analyze different expressions of SQ-LNS effect
// CREATED BY: Kelly Watson, The Hospital for Sick Children
// DATE: July 29, 2024


/* Table of contents: 
PART 1: Meta-analyze effect expressed as HA MD (full sample, n=18)
PART 2: Meta-analyze effect expressed as LAZ MD (full sample, n=18)
PART 3: Meta-analyze effect expressed as HA MD (reduced sample, n=13)
PART 4: Meta-analyze effect expressed as LAZ MD (reduced sample, n=13)
PART 5: Meta-analyze effect expressed as DHA MD
PART 6: Meta-analyze effect expressed as PMB
*/




*****************************************
*****************************************
** PART 1: Meta-analyze effect expressed as HA MD (full sample, n=18)

use "meta_input_data_full.dta", clear
metan HA_md HA_se, label(namevar=name) fixed

/*OUTPUT
Studies included: 18
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
name                     |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.416    10.416      14.11
Bangladesh; RDNS         |     7.000     -0.094    14.094       8.23
Bangladesh; WASH-B       |    17.000     10.042    23.958       8.55
Burkina Faso; iLiNS-Zinc |    20.000     12.017    27.983       6.50
Burkina Faso; PROMIS     |    10.000      2.923    17.077       8.27
Burkina Faso; PROMIS-CS  |     9.000     -1.979    19.979       3.43
Ghana; GHANA             |    16.000     -2.420    34.420       1.22
Ghana; iLiNS-DYAD-G      |    17.000      6.023    27.977       3.44
Haiti; HAITI             |    24.000      7.028    40.972       1.44
Kenya; WASH-B            |    17.000     10.652    23.348      10.27
Madagascar; MAHAY        |    10.000     -5.707    25.707       1.68
Malawi; iLiNS−DOSE       |     2.000     -7.714    11.714       4.39
Malawi; iLiNS−DYAD−M     |    -4.000    -17.473     9.473       2.28
Mali; PROMIS             |    24.000     11.979    36.021       2.87
Mali; PROMIS-CS          |    17.000      6.042    27.958       3.45
South Africa; TSWAKA     |    -2.000    -14.630    10.630       2.60
Zimbabwe; SHINE (HIV−)   |    12.000      6.699    17.301      14.73
Zimbabwe; SHINE (HIV+)   |    19.000      6.271    31.729       2.56
-------------------------+----------------------------------------------
Overall, IV              |    11.681      9.646    13.716     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  11.252  p = 0.000

Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     40.01       17      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.534     1.104     1.947
I² (%)                   |     57.5%     18.0%     73.6%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/

meta set HA_md HA_se, studylabel(name) eslabel("Mean diff.") level(95) fixed
meta forestplot


*****************************************
*****************************************
** PART 2: Meta-analyze effect expressed as LAZ MD (full sample, n=18)

use "meta_input_data_full.dta", clear
metan laz_md laz_se, label(namevar=name) fixed

/*OUTPUT
Studies included: 18
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
name                     |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.161      12.51
Bangladesh; RDNS         |     0.075     -0.004     0.155       8.90
Bangladesh; WASH-B       |     0.207      0.139     0.275      12.17
Burkina Faso; iLiNS-Zinc |     0.297      0.202     0.393       6.14
Burkina Faso; PROMIS     |     0.130      0.041     0.219       7.14
Burkina Faso; PROMIS-CS  |     0.055     -0.072     0.181       3.51
Ghana; GHANA             |     0.260     -0.035     0.555       0.65
Ghana; iLiNS-DYAD-G      |     0.198      0.069     0.327       3.40
Haiti; HAITI             |     0.040     -0.220     0.300       0.84
Kenya; WASH-B            |     0.160      0.097     0.223      14.14
Madagascar; MAHAY        |     0.097     -0.047     0.242       2.69
Malawi; iLiNS−DOSE       |     0.037     -0.117     0.192       2.36
Malawi; iLiNS−DYAD−M     |     0.020     -0.157     0.196       1.81
Mali; PROMIS             |     0.260      0.135     0.385       3.63
Mali; PROMIS-CS          |     0.200      0.096     0.304       5.18
South Africa; TSWAKA     |     0.070     -0.143     0.283       1.24
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      11.80
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       1.92
-------------------------+----------------------------------------------
Overall, IV              |     0.152      0.128     0.176     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  12.538  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     32.53       17      0.013
                         |            -[95% Conf. Interval]-
H                        |     1.383     1.000     1.784
I² (%)                   |     47.7%      0.0%     68.6%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/

meta set laz_md laz_se, studylabel(name) eslabel("Mean diff.") level(95) fixed
meta forestplot


*****************************************
*****************************************
** PART 3: Meta-analyze effect expressed as HA MD (reduced sample, n=13)

use "meta_input_data_red.dta", clear
metan HA_md HA_se, label(namevar=name) fixed

/*OUTPUT
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
name                     |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.000     -0.416    10.416      19.44
Bangladesh; RDNS         |     7.000     -0.094    14.094      11.33
Burkina Faso; iLiNS-Zinc |    20.000     12.017    27.983       8.95
Burkina Faso; PROMIS     |    10.000      2.923    17.077      11.39
Ghana; GHANA             |    16.000     -2.420    34.420       1.68
Ghana; iLiNS-DYAD-G      |    17.000      6.023    27.977       4.73
Haiti; HAITI             |    24.000      7.028    40.972       1.98
Malawi; iLiNS−DOSE       |     2.000     -7.714    11.714       6.04
Malawi; iLiNS−DYAD−M     |    -4.000    -17.473     9.473       3.14
Mali; PROMIS             |    24.000     11.979    36.021       3.95
South Africa; TSWAKA     |    -2.000    -14.630    10.630       3.57
Zimbabwe; SHINE (HIV−)   |    12.000      6.699    17.301      20.29
Zimbabwe; SHINE (HIV+)   |    19.000      6.271    31.729       3.52
-------------------------+----------------------------------------------
Overall, IV              |    10.215      7.827    12.603     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   8.385  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     32.44       12      0.001
                         |            -[95% Conf. Interval]-
H                        |     1.644     1.121     2.142
I² (%)                   |     63.0%     20.4%     78.2%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/



*****************************************
*****************************************
** PART 4: Meta-analyze effect expressed as LAZ MD (reduced sample, n=13)

use "meta_input_data_red.dta", clear
metan laz_md laz_se, label(namevar=name) fixed

/*OUTPUT
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
name                     |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     0.094      0.027     0.161      20.07
Bangladesh; RDNS         |     0.075     -0.004     0.155      14.28
Burkina Faso; iLiNS-Zinc |     0.297      0.202     0.393       9.85
Burkina Faso; PROMIS     |     0.130      0.041     0.219      11.45
Ghana; GHANA             |     0.260     -0.035     0.555       1.04
Ghana; iLiNS-DYAD-G      |     0.198      0.069     0.327       5.45
Haiti; HAITI             |     0.040     -0.220     0.300       1.34
Malawi; iLiNS−DOSE       |     0.037     -0.117     0.192       3.78
Malawi; iLiNS−DYAD−M     |     0.020     -0.157     0.196       2.90
Mali; PROMIS             |     0.260      0.135     0.385       5.82
South Africa; TSWAKA     |     0.070     -0.143     0.283       1.99
Zimbabwe; SHINE (HIV−)   |     0.152      0.083     0.221      18.94
Zimbabwe; SHINE (HIV+)   |     0.253      0.082     0.425       3.08
-------------------------+----------------------------------------------
Overall, IV              |     0.143      0.113     0.173     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =   9.321  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     25.96       12      0.011
                         |            -[95% Conf. Interval]-
H                        |     1.471     1.000     1.955
I² (%)                   |     53.8%      0.0%     73.8%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/



*****************************************
*****************************************
** PART 5: Meta-analyze effect expressed as Delta-HA (end-line - baseline HA) MD

use "meta_input_data_red.dta", clear
metan DHA_md DHA_se, label(namevar=name) fixed

/*OUTPUT
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
name                     |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     6.000      2.521     9.479      18.78
Bangladesh; RDNS         |     7.000      2.581    11.419      11.63
Burkina Faso; iLiNS-Zinc |    24.000     19.501    28.499      11.23
Burkina Faso; PROMIS     |    11.000      6.477    15.523      11.11
Ghana; GHANA             |    16.000      5.959    26.041       2.25
Ghana; iLiNS-DYAD-G      |    12.000      4.342    19.658       3.87
Haiti; HAITI             |     3.000     -6.592    12.592       2.47
Malawi; iLiNS−DOSE       |     3.000     -3.338     9.338       5.66
Malawi; iLiNS−DYAD−M     |    -7.000    -16.186     2.186       2.69
Mali; PROMIS             |    21.000     12.693    29.307       3.29
South Africa; TSWAKA     |    -4.000    -11.847     3.847       3.69
Zimbabwe; SHINE (HIV−)   |    13.000      9.535    16.465      18.93
Zimbabwe; SHINE (HIV+)   |    17.000      9.816    24.184       4.40
-------------------------+----------------------------------------------
Overall, IV              |    10.491      8.983    11.998     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  13.641  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |     90.85       12      0.000
                         |            -[95% Conf. Interval]-
H                        |     2.751     2.191     3.287
I² (%)                   |     86.8%     79.2%     90.7%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/


*****************************************
*****************************************
** PART 6: Meta-analyze effect expressed as PMB

use "meta_input_data_red.dta", clear
metan PMB PMB_se, label(namevar=name) fixed

/* OUTPUT 
Studies included: 13
Participants included: Unknown

Meta-analysis pooling of aggregate data
using the common-effect inverse-variance model

------------------------------------------------------------------------
name                     |   Effect    [95% Conf. Interval]   % Weight
-------------------------+----------------------------------------------
Bangladesh; JiVitA−4     |     5.700      2.400     9.000      22.43
Bangladesh; RDNS         |     5.200      1.900     8.500      22.43
Burkina Faso; iLiNS-Zinc |    29.600     24.100    35.100       8.07
Burkina Faso; PROMIS     |    12.200      7.200    17.200       9.77
Ghana; GHANA             |    94.100     34.600   153.600       0.07
Ghana; iLiNS-DYAD-G      |    30.000     10.800    49.200       0.66
Haiti; HAITI             |     5.900    -12.982    24.782       0.69
Malawi; iLiNS−DOSE       |     3.300     -3.700    10.300       4.98
Malawi; iLiNS−DYAD−M     |    -8.600    -20.000     2.800       1.88
Mali; PROMIS             |    15.100      9.100    21.100       6.78
South Africa; TSWAKA     |   -11.400    -33.900    11.100       0.48
Zimbabwe; SHINE (HIV−)   |    14.400     10.600    18.200      16.91
Zimbabwe; SHINE (HIV+)   |    16.700      9.600    23.800       4.84
-------------------------+----------------------------------------------
Overall, IV              |    10.547      8.984    12.110     100.00
------------------------------------------------------------------------

Test of overall effect = 0:  z =  13.228  p = 0.000


Heterogeneity measures, calculated from the data
with Conf. Intervals based on non-central chi² (common-effect) distribution for Q
-------------------------------------------------------------
Measure                  |     Value      df      p-value
-------------------------+-----------------------------------
Cochran's Q              |    104.30       12      0.000
                         |            -[95% Conf. Interval]-
H                        |     2.948     2.386     3.486
I² (%)                   |     88.5%     82.4%     91.8%
-------------------------------------------------------------
H = relative excess in Cochran's Q over its degrees-of-freedom
I² = proportion of total variation in effect estimate due to between-study heterogeneity (based on Q)
*/

meta set PMB PMB_se, studylabel(name) eslabel("PMB") level(95) fixed
meta forestplot






