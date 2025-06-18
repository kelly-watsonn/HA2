### README

#### Study: Height-age instead of height-for-age z-scores to quantify child growth effects of small-quantity lipid-based nutrient supplements in randomized trials in low- and middle-income countries<br/>
Kelly M Watson, Alison SB Dasiewicz, Diego G Bassani, Chun-Yuan Chen, Huma Qamar, Daniel E Roth<br/>
<br/>
**1) Generating Dataset for Meta-analysis**<br/>
*Code file*: HA2_primary_HA_code.do  <br/>
*Required datasets to run this do-file*: "HA2_ExtractDat_CombineGrps.dta" AND "HA2_IPD_ICC.dta" <br/>
This do-file will generate height-age, PMB and mean estiamtes from the extracted data to generate the analysis dataset, "meta_input_data_full.dta" <br/>

**2) Running Meta-analysis**<br/>
*Code file*: HA2_meta_code.do<br/>
*Required dataset to run this do-file*: "meta_input_data.full.dta"<br/>
*File to output tables*: "HA2_tables.xlsx"<br/>
This do-file runs all meta-analyses (primary and sensitivity analyses) and generates figures for all length outcomes.<br/>
<br/>
**3) Estimating Correlations between LAZ and Height-age Mean Differences**<br/>
*Code file*: "HA2_Figure 2_HA-LAZ MD Correlation.R"<br/>
*Required dataset to run this code*: "meta_input_data.full.dta" <br/>
This code file estimates correlations between the estimates of LAZ and height-age mean differences across the included studies in this meta-analysis and generates Figure 2 of the manuscript.<br/>
<br/>
**4) Simulation of impact of baseline height-age differences on proportion of maximal benefit**<br/>
*Code file*: HA2_Simulation.do<br/>
This do-file runs a simulation of randomized controlled trials with null and positive treatment effects with varying levels of baseline differences in length to assess effects on the PMB metric.<br/>
<br/>
**NOTE: the meta-analysis dataset has been uploaded as a .csv version to facilitate any independent analyses using other statistical software**

