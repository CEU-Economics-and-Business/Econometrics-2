clear
set seed 1234567

use "data-exam.dta", clear

reg y D z


scatter y z if D==0, msize(vsmall) || scatter y z if D==1, msize(vsmall) legend(off) ///
	xline(50, lstyle(foreground)) || lfit y z if D ==0, color(red) || ///
	lfit y z if D ==1, color(red) 

	
* measurement error

gen u =  runiform(1, 2)

* running variable with measurement error

gen z1=z+u


gen T = 0
replace T = 1 if z1 < 50

reg y T z1
