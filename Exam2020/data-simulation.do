clear
capture log close

set obs 20000
set seed 1234567
* Generate running variable
gen z = rnormal(50, 15)



replace z=0 if z < 0
drop if z > 100
summarize z, detail



*Set the cutoff at z=50. Treated if z < 50
gen D = 0
replace D = 1 if z < 50


gen y = 25 + 40*D + 1.5*z + rnormal(0, 20)

label var y "Test Scores"
label var z "Family income"

histogram z


save "data-exam.dta", replace
