********************************************************************************
* Econometrics 2 -- CEU 2019/20 
* Final Assignment - Suggested Solution
* Question 1
********************************************************************************


* run in Econometrics-2/Assignment/
* (type "cd ???/Econometrics-2/Assignment/" in command mode before running this file)

set more off, permanently
clear all

* Downloaded material is in folder "data-code", data is in "data-code/data".
* I will put log and outputs into "measurement_error_output".
cap mkdir measurement_error_output
cap log close
log using "measurement_error_output/log_final_assignment_Q1", replace


* Question 1 *******************************************************************

* a)

use "data-code/data/CA_schools_ms.dta", clear

set seed 20200423 // can be any number

* Let's create a classic  measurement error 
generate me=rnormal(0,2) // a variable of random numbers drawn from N(0,2)

* check
histogram me
kdensity me


* b) Standardization 

binscatter readingscore api_rank, name(before)
foreach v in readingscore api_rank {     // we can iterate over a varlist
	gen `v'_raw=`v' // let's keep the raw data as well 
	sum `v', d								
	replace `v'=(`v'-`r(mean)')/`r(sd)' 	// after a sum or regress you can acess stored results
}
binscatter readingscore api_rank, name(after)
graph combine before after 

* check (mean should be 0, s.d. 1)
summarize readingscore
summarize api_rank


* c)
reg readingscore api_rank
reg  api_rank readingscore
corr api_rank readingscore


* d) 

gen api_error= api_rank+me
la var api_rank "Standardized API rank"
la var api_error "Standardized API rank with measurement error"

reg  readingscore api_rank
reg  readingscore api_error 

* figure (extra, not expected in submissions)
twoway (scatter readingscore api_rank, msize(vtiny)) (lfit readingscore api_rank, lwidth(medthick)), legend(off) xtitle("Standardized API rank") ytitle("Standardized reading score") name(basic, replace)
twoway (scatter readingscore api_error, msize(vtiny)) (lfit readingscore api_error, lwidth(medthick)), legend(off) xtitle("Standardized API rank with measurement error") ytitle("Standardized reading score")name(error, replace)
graph combine basic error, xcommon rows(2)
graph export "measurement_error_output/1d.png", as(png) replace 
*graph export graph export "graph_nologo.png", as(png) replace width(6400) height(4800)



* attenuation bias
* formal test:
	* t=(beta_1-beta_2)/sqrt(var(b_1)+var(b_2))
	* where var=n*se; and beta_1 and beta_2 is assumed to be independent
quietly reg  readingscore api_rank
scalar beta1=_b[api_rank]
scalar var1=_se[api_rank]^2

quietly reg  readingscore api_error
scalar beta2=_b[api_error]
scalar var2=_se[api_error]^2

scalar list 
disp( (beta2-beta1)/(sqrt(var1+var2)) )

reg  readingscore api_rank
scalar beta1=_b[api_rank]
scalar var1=_se[api_rank]^2

reg  readingscore api_error
scalar beta2=_b[api_error]
scalar var2=_se[api_error]^2

disp "t: " (beta2-beta1)/(sqrt(var1+var2)) 

	
* e)
sum api_rank, d
gen api_rank_el=api_rank+me  if api_rank>`r(mean)'
replace api_rank_el=api_rank if api_rank<=`r(mean)'

scatter readingscore api_rank
scatter readingscore api_rank_el


* f)
regress readingscore api_rank
regress readingscore api_error
regress readingscore api_rank_el

replace api_rank_el=api_rank-runiform(4,6) if api_rank<=0
scatter readingscore api_rank_el
regress readingscore api_rank_el


* g)
* The tables in the suggested solutions document are quite small so here I did
* not auto-generate them (but in general, auto-generation is preferred).

cap drop api_error_* // drop these variables if they exist 
gen api_error_shift= api_rank+ rnormal(0.5,2)
gen api_error_bigvar= api_rank+ rnormal(0,3)

reg  readingscore api_rank
reg  readingscore api_error 
reg  readingscore api_error_shift 
reg  readingscore api_error_bigvar

* figure (extra, not expected in submissions)
twoway (scatter readingscore api_rank, msize(vtiny)) (lfit readingscore api_rank, lwidth(medthick)), name(basic, replace)
twoway (scatter readingscore api_error, msize(vtiny)) (lfit readingscore api_error, lwidth(medthick)), legend(off) xtitle("With measurement error N(0,2)") name(error, replace) 
twoway (scatter readingscore api_error_shift, msize(vtiny)) (lfit readingscore api_error_shift, lwidth(medthick)), legend(off) xtitle("With measurement error N(0.5,2)") name(error_shift, replace) 
twoway (scatter readingscore api_error_bigvar, msize(vtiny)) (lfit readingscore api_error_bigvar, lwidth(medthick)), legend(off) xtitle("With measurement error N(0,3)") name(error_bigvar, replace) 
graph combine error error_shift error_bigvar, xcommon rows(3)
graph export "measurement_error_output/1g.png", as(png) replace 


* h)

gen readingscore_error=readingscore+me
reg readingscore api_rank
reg readingscore_error api_rank
generate me_small=rnormal(0,0.3)
gen readingscore_error_small=readingscore+me_small
reg readingscore_error_small api_rank
	
corr me api_rank

cap log close
