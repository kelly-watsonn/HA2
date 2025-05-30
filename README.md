### README

#### Study: Height-age instead of height-for-age z-scores to quantify intervention effects on child growth in randomized controlled trials: application to small-quantity lipid-based nutrient supplements in low- and middle-income countries 
Kelly M Watson, Alison SB Dasiewicz, Diego G Bassani, Chun-Yuan Chen, Huma Qamar, Daniel E Roth

**1) Generating Dataset for Meta-analysis**
*Code file*: HA2_primary_HA_code.do 
*Required datasets to run this do-file*: "HA2_ExtractDat_CombineGrps.dta" AND "HA2_IPD_ICC.dta"
This do-file will generate height-age, PMB and mean estiamtes from the extracted data to generate the analysis dataset, "meta_input_data_full.dta"

**2) Running Meta-analysis**
*Code file*: HA2_meta_code.do
*Required dataset to run this do-file*: "meta_input_data.full.dta"
This do-file runs all meta-analyses (primary and sensitivity analyses) and generates figures for all length outcomes. 

**3) Simulation of impact of baseline height-age differences on proportion of maximal benefit**
*Code file*: HA2_Simulation.do
This do-file runs a simulation of randomized controlled trials with null and positive treatment effects with varying levels of baseline differences in length to assess effects on the PMB metric.

**NOTE: the meta-analysis dataset has been uploaded as a .csv version to facilitate any independent analyses using other statistical software**

