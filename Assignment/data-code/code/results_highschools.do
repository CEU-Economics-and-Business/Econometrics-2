clear all

use "data/CA_schools_hs.dta", clear


*Generate running variable

gen norm = api_rank - 584

*Create indicator for whether a school is below the cutoff

gen ind = 0 
replace ind = 1 if norm <= 0

*Interaction for flexible slope at cutoff

gen ind_norm = ind*norm


**Keep Observations within 200 API window of cutoff**

keep if abs(norm) < 100


**Normalize test scores to school-level average and sd

sum mathscore

replace mathscore = (mathscore - r(mean))/r(sd)

sum readingscore

replace readingscore = (readingscore - r(mean))/r(sd)

gen average_score = (mathscore+readingscore)/2



**TABLE 9, Panel B: High Schools

reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg average_score ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg mathscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)


reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust)

reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2005, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2006, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2007, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2008, vce(robust)
reg readingscore ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == 2009, vce(robust)




