clear all

use "data/CA_schools_es.dta", clear

*Generate running variable

gen norm = api_rank - 643
replace norm = api_rank - 600 if stype == "M"
replace norm = api_rank - 584 if stype == "H"


***TABLE 1, summary statistics***

sum mathscore readingscore api_rank  percentfrl total pct_hi pct_wh pct_other fte_t fte_a fte_p classsize
sum mathscore readingscore api_rank  percentfrl total pct_hi pct_wh pct_other fte_t fte_a fte_p classsize if abs(norm) < 19.099 

**Restrict sample to elementary schools**

keep if stype == "E"

gen ind = 0 
replace ind = 1 if api_rank <= 643

gen ind_norm = ind*norm



**Keep Observations within 200 API window of cutoff**

keep if abs(norm) < 100



**Normalize test  scores 

sum mathscore

replace mathscore = (mathscore - r(mean))/r(sd)

sum readingscore

replace readingscore = (readingscore - r(mean))/r(sd)

gen average_score = (mathscore+readingscore)/2

*Create an average for "percent meeting X standard" variables

gen a_1 = (farbelowbasic_read+farbelowbasic_math)/2
gen a_2 = (cstcapapercentagebelowbasic_read+cstcapapercentagebelowbasic_math)/2
gen a_3 = (cstcapapercentagebasic_read+cstcapapercentagebasic_math)/2
gen a_4 = (cstcapapercentageproficient_read+cstcapapercentageproficient_math)/2
gen a_5 = (cstcapapercentageadvanced_read+cstcapapercentageadvanced_math)/2



**Falsification Index

*Generate lagged test scores
sort cds year
bysort cds: gen lag_average_score = average_score[_n-1]


*Generage index with various characteristics
reg average_score total pct_wh pct_hi percentfrl if year < 2005 & norm < 19.099 & norm > -19.099
predict y_hat1

reg average_score total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist if year < 2005 & norm < 19.099 & norm > -19.099
predict y_hat2

reg average_score total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist lag_average_score if year < 2005 & norm < 19.099 & norm > -19.099
predict y_hat3


reg mathscore total pct_wh pct_hi percentfrl if year < 2005 & norm < 19.099 & norm > -19.099
predict ym_hat1

reg mathscore total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist if year < 2005 & norm < 19.099 & norm > -19.099
predict ym_hat2

reg mathscore total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist lag_average_score if year < 2005 & norm < 19.099 & norm > -19.099
predict ym_hat3

reg readingscore total pct_wh pct_hi percentfrl if year < 2005 & norm < 19.099 & norm > -19.099
predict yr_hat1

reg readingscore total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist if year < 2005 & norm < 19.099 & norm > -19.099
predict yr_hat2

reg readingscore total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist lag_average_score if year < 2005 & norm < 19.099 & norm > -19.099
predict yr_hat3


**RESULTS FOR TABLE 2**

reg y_hat1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)
reg y_hat2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)
reg y_hat3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)

reg ym_hat1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)
reg ym_hat2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)
reg ym_hat3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)

reg yr_hat1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)
reg yr_hat2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)
reg yr_hat3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year < 2005 , vce(robust)

**RESULTS FOR TABLE 3**

reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg fte_t ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg fte_a ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg fte_p ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg yrs_teach ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg yrs_dist ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


**RESULTS FOR TABLE 4  THESE HAVE TO BE COLLAPSED TO MAKE THE OBS COUNT CORRECT**



gen one = 1


preserve

local enr = "norm"
local bin =1


gen bin`bin' = round(`enr'+`bin'/2, `bin' )
replace bin`bin'= bin`bin'-`bin'/2


keep if year == 2003

collapse (count) one, by(bin)

gen ind = 0
replace ind = 1 if bin <=0

gen ind_norm = ind*bin

reg one ind bin ind_norm if bin < 20 & bin > -20, vce(robust)
reg one ind bin ind_norm if bin < 50 & bin > -50, vce(robust)

restore

preserve

local enr = "norm"
local bin =2


gen bin`bin' = round(`enr'+`bin'/2, `bin' )
replace bin`bin'= bin`bin'-`bin'/2


keep if year == 2003

collapse (count) one, by(bin)

gen ind = 0
replace ind = 1 if bin <=0

gen ind_norm = ind*bin

reg one ind bin ind_norm if bin < 20 & bin > -20, vce(robust)
reg one ind bin ind_norm if bin < 50 & bin > -50, vce(robust)

restore



preserve

local enr = "norm"
local bin =5


gen bin`bin' = round(`enr'+`bin'/2, `bin' )
replace bin`bin'= bin`bin'-`bin'/2


keep if year == 2003

collapse (count) one, by(bin)

gen ind = 0
replace ind = 1 if bin <=0

gen ind_norm = ind*bin

reg one ind bin ind_norm if bin < 20 & bin > -20, vce(robust)
reg one ind bin ind_norm if bin < 50 & bin > -50, vce(robust)

restore




**TABLE 5**

reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)



**TABLE 6, Percent Meeting X standards**


reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)


reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg a_1 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg a_2 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg a_3 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg a_4 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg a_5 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)



**TABLE 7, Effects at grade level**

egen missing_grade_level_data = rowmiss( meanscaledscore_G2_T7 meanscaledscore_G3_T7 meanscaledscore_G4_T7 meanscaledscore_G5_T7 meanscaledscore_G2_T8 meanscaledscore_G3_T8 meanscaledscore_G4_T8 meanscaledscore_G5_T8)
egen max_missing_grade_level = max( missing_grade_level_data) if year < 2010, by(cds)


reg meanscaledscore_G2_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T8 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008&  max_missing_grade_level == 0 ,  vce(robust)

reg meanscaledscore_G2_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G3_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G4_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008&  max_missing_grade_level == 0 ,  vce(robust)
reg meanscaledscore_G5_T7 ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009&  max_missing_grade_level == 0 ,  vce(robust)



**TABLE 8, Alternative Cutoffs**

gen norm_neg10 = norm - 10
gen ind_neg10 = 0
replace ind_neg10 = 1 if norm_neg10 < 0 
gen ind_norm_neg10 = ind_neg10*norm_neg10

gen norm_neg5 = norm - 5
gen ind_neg5 = 0
replace ind_neg5 = 1 if norm_neg5 < 0 
gen ind_norm_neg5 = ind_neg5*norm_neg5

gen norm_5 = norm + 5
gen ind_5 = 0
replace ind_5 = 1 if norm_5 < 0 
gen ind_norm_5 = ind_5*norm_5

gen norm_10 = norm + 10
gen ind_10 = 0
replace ind_10 = 1 if norm_10 < 0 
gen ind_norm_10 = ind_10*norm_10

reg average_score ind_neg10 norm_neg10 ind_norm_neg10 if norm_neg10 < 19.099 & norm_neg10 > -19.099 & year == 2004 , vce(robust)
reg average_score ind_neg10 norm_neg10 ind_norm_neg10 if norm_neg10 < 19.099 & norm_neg10 > -19.099 & year == 2005 , vce(robust)

reg average_score ind_neg5 norm_neg5 ind_norm_neg5 if norm_neg5 < 19.099 & norm_neg5 > -19.099 & year == 2004 , vce(robust)
reg average_score ind_neg5 norm_neg5 ind_norm_neg5 if norm_neg5 < 19.099 & norm_neg5 > -19.099 & year == 2005 , vce(robust)

reg average_score ind_5 norm_5 ind_norm_5 if norm_5 < 19.099 & norm_5 > -19.099 & year == 2004 , vce(robust)
reg average_score ind_5 norm_5 ind_norm_5 if norm_5 < 19.099 & norm_5 > -19.099 & year == 2005 , vce(robust)


reg average_score ind_10 norm_10 ind_norm_10 if norm_10 < 19.099 & norm_10 > -19.099 & year == 2004 , vce(robust)
reg average_score ind_10 norm_10 ind_norm_10 if norm_10 < 19.099 & norm_10 > -19.099 & year == 2005 , vce(robust)


*** Effects at other Deciles

foreach x in 609 643 674 701 728 {

gen norm_`x' = norm + 643 - `x'
gen ind_`x' = 0
replace ind_`x' = 1 if norm_`x' <= 0
gen ind_norm_`x' = ind_`x'*norm_`x'

reg average_score ind_`x' norm_`x' ind_norm_`x' if abs(norm_`x') < 19.099 & year == 2004 , vce(robust)
reg average_score ind_`x' norm_`x' ind_norm_`x' if abs(norm_`x') < 19.099 & year == 2005 , vce(robust)

}



***THE FOLLOWING TABLES ARE FOR ONLINE APPENDICES


**TABLE A.1, Tests on student characteristics**



reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg total ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg pct_wh ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg pct_hi ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg pct_other ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg percentfrl ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)




**TABLE B.1, Generate results for alternate specifications, district fixed effects**

/*
xi: reg average_score ind norm ind_norm i.distid if norm < 19.099 & norm > -19.099 & year < 2005, vce(robust)
xi: reg mathscore ind norm ind_norm i.distid if norm < 19.099 & norm > -19.099 & year < 2005, vce(robust)
xi: reg readingscore ind norm ind_norm i.distid if norm < 19.099 & norm > -19.099 & year < 2005, vce(robust)


xi: reg average_score ind norm ind_norm i.distid if norm < 19.099 & norm > -19.099 & year == 2005 , vce(robust)
xi: reg mathscore ind norm ind_norm i.distid if norm < 19.099 & norm > -19.099 & year == 2005 , vce(robust)
xi: reg readingscore ind norm ind_norm i.distid if norm < 19.099 & norm > -19.099 & year == 2005 , vce(robust)
*/

**TABLE B.2,  Clustering on norm & cds:**


reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(cl norm)


reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(cl norm)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(cl norm)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(cl norm)


reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(cl norm)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(cl norm)


reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(cl norm)

reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(cl norm)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(cl norm)


reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(cl cds)


reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(cl cds)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(cl cds)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(cl cds)


reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(cl cds)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(cl cds)


reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(cl cds)

reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2002, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2003, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2004, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(cl cds)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(cl cds)

*Generate bins for figures

local enr = "norm"
local bin =3


gen bin = round(`enr'+`bin'/2, `bin' )
replace bin= bin-`bin'/2

*Using a bin of 3 will lump schools with exactly 643 API into the bin on the right of the cutoff
*these schools are affected by the policy and should not be included in bin 1.5 

replace bin = . if norm == 0 & bin == 1.5

*FIGURE 1*

egen y_hat3_bin = mean(y_hat3) if year < 2005, by(bin)
twoway (scatter  y_hat3_bin bin if bin < 50 & bin > -50 & year < 2005,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti("Predicted test score"))


*FIGURE 2*

egen one_bin = total(one) if year ==2005, by(bin)

twoway (scatter  one_bin bin if bin < 100 & bin > -100 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti("Number of Schools")) 



*FIGURE 3, Panel A*


merge m:1 cds using williams_full_apportionment_schedule.dta

gen list = 0
replace list = 1 if _merge == 3

replace list = . if year != 2005

egen list_bin = mean(list) , by(bin)

scatter list_bin bin if year == 2005, xline(0)



*FIGURE 3, Panel B
*This figure is produced using do file: results_district_spending.do

*FIGURE 4*
egen fte_t_bin = mean(fte_t), by(bin year)
twoway (scatter  fte_t_bin bin if bin < 50 & bin > -50 & year == 2005 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Teacher FTE)) 

*FIGURE 5*

egen average_score_bin = mean(average_score) , by(bin year)

twoway (scatter  average_score_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 

twoway (scatter  average_score_bin bin if bin < 50 & bin > -50 & year == 2005,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score))

*FIGURE 6*


**Estimate and store effects over time

foreach subject in average_ {

gen estimate_`subject' = .
gen lower95_`subject' = .
gen higher95_`subject' = .
gen id_`subject' = .


local count = 0

forval x = 2002/2011{
reg `subject'score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == `x', vce(robust)
local est_`subject'_`x' = _b[ind]
local se_`subject'_`x' = _se[ind]

local low95_`subject'_`x' = `est_`subject'_`x'' - 1.96*`se_`subject'_`x''
local high95_`subject'_`x' = `est_`subject'_`x'' + 1.96*`se_`subject'_`x''


display `est_`subject'_`x''

local count = `count' +1

replace estimate_`subject' = `est_`subject'_`x'' in `count'
replace lower95_`subject' = `low95_`subject'_`x'' in `count'
replace higher95_`subject' = `high95_`subject'_`x'' in `count'
replace id_`subject' = `x' in `count'

}

local count = 0

}

eclplot estimate_average_ lower95_average higher95_average id_average, xti("Year") yti("Effect on average test scores") yline(0) xline(2004.5 , lp(dash))




*FIGURE 7*


forval x = 1/5{

egen a_`x'_bin = mean(a_`x') if year == 2007, by(bin)

}

twoway (scatter  a_1_bin bin if bin < 50 & bin > -50 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of students) title("Far below basic")) 
twoway (scatter  a_2_bin bin if bin < 50 & bin > -50 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of students) title("Below basic")) 
twoway (scatter  a_3_bin bin if bin < 50 & bin > -50 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of students) title("Basic")) 
twoway (scatter  a_4_bin bin if bin < 50 & bin > -50 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of students) title("Proficient")) 
twoway (scatter  a_5_bin bin if bin < 50 & bin > -50 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of students) title("Advanced")) 


*FIGURE 8*

gen norm_2 = norm^2
gen ind_norm_2 = ind_norm^2


gen beta = .
gen se = .


gen beta_quad = .
gen seread_quad = .




mat beta = J(300,1,.)
mat se = J(300,1,.)

mat beta_quad = J(300,1,.)
mat se_quad = J(300,1,.)

forval x = 10(1)60{


qui: reg average_score ind norm ind_norm if norm < `x' & norm > -`x' & year == 2005, vce(robust)

mat beta[`x',1] = _b[ind]
mat se[`x',1] = _se[ind]

qui: reg average_score ind norm ind_norm norm_2 ind_norm_2 if norm < `x' & norm > -`x' & year == 2005, vce(robust)

mat beta_quad[`x',1] = _b[ind]
mat se_quad[`x',1] = _se[ind]

}

svmat beta
svmat se

svmat beta_quad
svmat se_quad

gen cb = _n if beta1 !=.

gen lower95 = beta1-1.96*se1
gen higher95 = beta1+1.96*se1

gen cb_quad = _n if beta1 !=.

gen lower95_quad = beta_quad1-1.96*se_quad1
gen higher95_quad = beta_quad1+1.96*se_quad1

twoway  (line beta1 cb,yline(0) xline(19.09 , lp(dash)) xti("Bandwidth") yti(Average test score effect size ))  (line lower95 cb, lpattern(dash)) (line higher95 cb, lpattern(dash)) , legend(off) 

twoway  (line beta_quad1 cb_quad,yline(0) xline(19.09 , lp(dash)) xti("Bandwidth") yti(Average test score effect size))  (line lower95_quad cb_quad , lpattern(dash)) (line higher95_quad cb_quad, lpattern(dash)) , legend(off)  



*Appendix A
*Figure A.1*

twoway (scatter  average_score_bin bin if bin < 50 & bin > -50 & year == 2002,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 
twoway (scatter  average_score_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 
twoway (scatter  average_score_bin bin if bin < 50 & bin > -50 & year == 2004,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 

*Figure A.2*

egen total_bin = mean(total), by(bin year)
egen pct_wh_bin = mean(pct_wh), by(bin year)
egen pct_hi_bin = mean(pct_hi), by(bin year)
egen pct_other_bin = mean(pct_other), by(bin year)
egen frl_bin = mean(frl), by(bin year)

twoway (scatter  total_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Enrollment in 2003))
twoway (scatter  pct_wh_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of white students in 2003))
twoway (scatter  pct_hi_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of Hispanic students in 2003))
twoway (scatter  pct_other_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent of other ethnicities in 2003))
twoway (scatter  frl_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Percent eligible for free and reduced lunch in 2003))

*Figure A.3*


egen fte_a_bin = mean(fte_a), by(bin year)
egen fte_p_bin = mean(fte_p), by(bin year)
egen yrs_teach_bin = mean(yrs_teach), by(bin year)
egen yrs_dist_bin = mean(yrs_dist), by(bin year)


twoway (scatter  fte_t_bin bin if bin < 50 & bin > -50 & year == 2005 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Teacher FTE)) 
twoway (scatter  fte_a_bin bin if bin < 50 & bin > -50 & year == 2004 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Administrator FTE)) 
twoway (scatter  fte_p_bin bin if bin < 50 & bin > -50 & year == 2004 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Pupil Staff FTE)) 
twoway (scatter  yrs_teach_bin bin if bin < 50 & bin > -50 & year == 2004 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Years of Experience)) 
twoway (scatter  yrs_dist_bin bin if bin < 50 & bin > -50 & year == 2004 ,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Years in District)) 

*Appendix B
*Figure B.1*

twoway  (lfit average_score_bin bin if bin < 0 & bin > -15 & year == 2005 , lpattern(dot) lc(black) ) (lfit average_score_bin bin if bin > 0 & bin < 15 & year == 2005 , lpattern(dot) lc(black)) (lfit average_score_bin bin if bin < 0 & bin > -33 & year == 2005 , lpattern(solid) lc(black)) (lfit average_score_bin bin if bin > 0 & bin < 33 & year == 2005 , lpattern(solid) lc(black)) (lfit average_score_bin bin if bin < 0 & bin > -25 & year == 2005 , lpattern(dash) lc(black)) (lfit average_score_bin bin if bin > 0 & bin < 25 & year == 2005 , lpattern(dash) lc(black)) (scatter  average_score_bin bin if bin < 33 & bin > -33 & year == 2005,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score) leg(off) )
twoway  (qfit average_score_bin bin if bin < 0 & bin > -15 & year == 2005 , lpattern(dot) lc(black) ) (qfit average_score_bin bin if bin > 0 & bin < 15 & year == 2005 , lpattern(dot) lc(black)) (qfit average_score_bin bin if bin < 0 & bin > -33 & year == 2005 , lpattern(solid) lc(black)) (qfit average_score_bin bin if bin > 0 & bin < 33 & year == 2005 , lpattern(solid) lc(black)) (qfit average_score_bin bin if bin < 0 & bin > -25 & year == 2005 , lpattern(dash) lc(black)) (qfit average_score_bin bin if bin > 0 & bin < 25 & year == 2005 , lpattern(dash) lc(black)) (scatter  average_score_bin bin if bin < 33 & bin > -33 & year == 2005,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score) leg(off) )


*Figure B.2*

egen mathscore_bin = mean(mathscore) , by(bin year)
egen readingscore_bin = mean(readingscore) , by(bin year)


twoway (scatter  mathscore_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 
twoway (scatter  mathscore_bin bin if bin < 50 & bin > -50 & year == 2005,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 

twoway (scatter  readingscore_bin bin if bin < 50 & bin > -50 & year == 2003,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 
twoway (scatter  readingscore_bin bin if bin < 50 & bin > -50 & year == 2005,ylabel(#5)  xline(0) xti("API in 2003 relative to cutoff") yti(Mean scaled score)) 

*Appendix C
*Figure C.1*

*This figure is produced using do file: results_district_spending.do

