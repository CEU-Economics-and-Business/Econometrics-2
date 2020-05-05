********************************************************************************
* Econometrics 2 -- CEU 2019/20 
* Final Assignment - Suggested Solution
* Question 2 / 2.
********************************************************************************

* run in Econometrics-2/Assignment/
* (type "cd .../Econometrics-2/Assignment/" in command mode before running this file)

set more off, permanently
clear all

* Downloaded material is in folder "data-code", data is in "data-code/data".
* I will put log and outputs into "replication_output".
cap mkdir replication_output
cap log close
log using "replication_output/log_final_assignment_Q2_2", replace


* Setup ************************************************************************

use "data-code/data/CA_schools_es.dta", clear


* generate running variable

gen norm = api_rank - 643
replace norm = api_rank - 600 if stype == "M"
replace norm = api_rank - 584 if stype == "H"


* restrict sample to elementary schools

keep if stype == "E"

gen ind = 0 // indicator for intended treatment
replace ind = 1 if api_rank <= 643

gen ind_norm = ind*norm


* keep Observations within 200 API window of cutoff

	* RD need many observations in a window as small as possible

keep if abs(norm) < 100


* normalize test scores 
	* so meaningfully interpretable

sum mathscore

replace mathscore = (mathscore - r(mean))/r(sd)

sum readingscore

replace readingscore = (readingscore - r(mean))/r(sd)

gen average_score = (mathscore+readingscore)/2


* generate lagged test scores
sort cds year
bysort cds: gen lag_average_score = average_score[_n-1]



* Replicate outputs ************************************************************

cd replication_output // change working directory to output folder


* TABLE 5 **********************************************************************

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




* For bonus point: auto-generate it

* run regressions, store results
foreach outcome in average_score mathscore readingscore {

		eststo `outcome'allpost: qui reg `outcome' ind norm ind_norm if norm < 19.099 & norm > -19.099 & year >= 2005, vce(robust) 
		forval y=2002/2004 {
		eststo `outcome'`y': qui reg `outcome' ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == `y', vce(robust)
		}
		forval y=2005/2008 {
		eststo `outcome'`y': qui reg `outcome' ind norm ind_norm if norm < 19.099 & norm > -19.099 & year == `y', vce(robust)
		}
}

* The models with average_score are stored in average_scoreallpost, average_score2002, etc.
* average_score* means all of these in the order of estimation (which is the one we want in the table) 

* I generate the table from the stored results with 3 esttab commands
* these are a bit different so I don't use a loop here
esttab average_score* using "table5.csv", replace 							///		
	b(%9.2f) se(%9.2f) coeflabels(ind "Average score")						///
	drop(norm ind_norm _cons) noobs nostar nonotes							///
	mtitles("All post years" "2002" "2003" "2004" "2005" "2006" "2007" "2008") 
esttab mathscore* using "table5.csv", append nomtitles nonumbers 			///
	b(%9.2f) se(%9.2f) coeflabels(ind "Math")								///
	drop(norm ind_norm _cons) noobs nostar nonotes	
esttab mathscore* using "table5.csv", append nomtitles nonumbers 			///
	b(%9.2f) se(%9.2f) coeflabels(ind "Reading")							///
	drop(norm ind_norm _cons) noobs nostar nonotes	

/* Import this table to Excel (might need to set delimiter to comma).
The output does not look 100% as the one in the paper, but it is very close
and easily comparable. */




* FIGURES **********************************************************************

* generate bins for figures

local enr = "norm" // running var
local bin =3  // binsize 

gen bin = round(`enr'+`bin'/2, `bin' ) 
replace bin= bin-`bin'/2

gen bin2=floor(norm/3)*3+1.5 // my solution

* generally: floor, ceil and mod are very useful tools, but are indeed tricky
 

* using a bin of 3 will lump schools with exactly 643 API into the bin on the right of the cutoff
* these schools are affected by the policy and should not be included in bin 1.5 

replace bin = . if norm == 0 & bin == 1.5




* FIGURE 1 *********************************************************************

reg average_score total pct_wh pct_hi percentfrl fte_t fte_a fte_p yrs_teach yrs_dist lag_average_score if year < 2005 & norm < 19.099 & norm > -19.099
predict y_hat3 // predicted scores


egen y_hat3_bin = mean(y_hat3) if year < 2005, by(bin) // collapse by bin
twoway scatter  y_hat3_bin bin if bin < 50 & bin > -50 & year < 2005, ///  /* small window */
	ylabel(#5) xline(0) xti("API in 2003 relative to cutoff") yti("Predicted test score") saving("figure1", replace)  // add vertical line



* FIGURE 2 *********************************************************************

gen one = 1
egen one_bin = total(one) if year ==2005, by(bin)  // egen total is same as egen sum (BUT NOT as gen sum)

twoway scatter  one_bin bin if bin < 100 & bin > -100, ylabel(#5) /* ticks on y */  xline(0) xti("API in 2003 relative to cutoff") yti("Number of Schools") saving("figure2", replace)



* FIGURE 3, Panel A ************************************************************

* if we can append data from the schedule we know that financial support was received
merge m:1 cds using "../data-code/data/williams_full_apportionment_schedule.dta"
tab _merge
gen list = 0
replace list = 1 if _merge == 3
drop if _merge==2

replace list = . if year != 2005

egen list_bin = mean(list) , by(bin)

scatter list_bin bin if year == 2005, xline(0) saving("figure3A", replace)


cap log close
