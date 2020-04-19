clear all

use "data/CA_districts.dta", clear


*Convert district-level spending to per-student levels

foreach x of var value2100 value4100 value5100 value5200 value5500 value6400{
replace `x' = `x'/total
}


foreach x of var value2100 value4100 value5100 value5200 value5500 value6400{
gen sd_`x' = `x'
}





collapse value* (sd) sd_value*, by(year ind_no)



foreach x of var value2100  value4100 value5100 value5200 value5500 value6400{

gen ub_`x'_control = `x' + 1.96*(sd_`x'^.5) if ind == 0
gen lb_`x'_control = `x' - 1.96*(sd_`x'^.5) if ind == 0

gen ub_`x'_treat = `x' + 1.96*(sd_`x'^.5) if ind == 1
gen lb_`x'_treat = `x' - 1.96*(sd_`x'^.5) if ind == 1

}




twoway (rarea ub_value4100_control lb_value4100_control year, color(gs15))   (line value4100 year if ind ==0 , lpattern(dash_dot) color(gs12))(line value4100 year if ind ==1, color(gs8)ti() lpattern(dashed)) , legend( label(1 "95% CI Affected") label(2 "Spending in Affected Districts") label(3 "Spending in Unaffected Districts")) legend(order( 2 1 3)) xline(2004) yti("Spending per Student")
twoway (rarea ub_value6400_control lb_value6400_control year, color(gs15))   (line value6400 year if ind ==0 , lpattern(dash_dot) color(gs12))(line value6400 year if ind ==1, color(gs8)ti() lpattern(dashed)) , legend( label(1 "95% CI Affected") label(2 "Spending in Affected Districts") label(3 "Spending in Unaffected Districts")) legend(order( 2 1 3)) xline(2004) yti("Spending per Student")
twoway (rarea ub_value2100_control lb_value2100_control year, color(gs15))   (line value2100 year if ind ==0 , lpattern(dash_dot) color(gs12))(line value2100 year if ind ==1, color(gs8)ti() lpattern(dashed)) , legend( label(1 "95% CI Affected") label(2 "Spending in Affected Districts") label(3 "Spending in Unaffected Districts")) legend(order( 2 1 3)) xline(2004) yti("Spending per Student")
twoway (rarea ub_value5100_control lb_value5100_control year, color(gs15))   (line value5100 year if ind ==0 , lpattern(dash_dot) color(gs12))(line value5100 year if ind ==1, color(gs8)ti() lpattern(dashed)) , legend( label(1 "95% CI Affected") label(2 "Spending in Affected Districts") label(3 "Spending in Unaffected Districts")) legend(order( 2 1 3)) xline(2004) yti("Spending per Student")
twoway (rarea ub_value5500_control lb_value5500_control year, color(gs15))   (line value5500 year if ind ==0 , lpattern(dash_dot) color(gs12))(line value5500 year if ind ==1, color(gs8)ti() lpattern(dashed)) , legend( label(1 "95% CI Affected") label(2 "Spending in Affected Districts") label(3 "Spending in Unaffected Districts")) legend(order( 2 1 3)) xline(2004) yti("Spending per Student")
twoway (rarea ub_value5200_control lb_value5200_control year, color(gs15))   (line value5200 year if ind ==0 , lpattern(dash_dot) color(gs12))(line value5200 year if ind ==1, color(gs8)ti() lpattern(dashed)) , legend( label(1 "95% CI Affected") label(2 "Spending in Affected Districts") label(3 "Spending in Unaffected Districts")) legend(order( 2 1 3)) xline(2004) yti("Spending per Student")


