clear
capture log close

set obs 1000
set seed 1234567
* Generate running variable
gen z = rnormal(50, 25)

histogram z


replace z=0 if z < 0
drop if z > 100
summarize z, detail



*Set the cutoff at z=50. Treated if z > 50
gen D = 0
replace D = 1 if z > 50
gen y1 = 25 + 0*D + 1.5*z + rnormal(0, 20)
reg y1 D z

twoway (scatter y1 z if D==0, msize(vsmall) msymbol(circle_hollow)) ///
	(scatter y1 z if D==1, sort mcolor(blue) msize(vsmall) msymbol(circle_hollow)) ///
	(lfit y1 z if D==0, lcolor(red) msize(small) lwidth(medthin) lpattern(solid)) ///
	(lfit y1 z, lcolor(dknavy) msize(small) lwidth(medthin) lpattern(solid)), ///
	xtitle(Test score (z)) xline(50) legend(off)
	

gen y = 25 + 40*D + 1.5*z + rnormal(0, 20)
reg y D z

scatter y z if D==0, msize(vsmall) || scatter y z if D==1, msize(vsmall) legend(off) ///
	xline(50, lstyle(foreground)) || lfit y z if D ==0, color(red) || ///
	lfit y z if D ==1, color(red) ytitle("Outcome (y)") ztitle("Test Score (z)")
	
*non linearities interpreted as discontinuity
	
gen z2=z^2
gen z3=z^3
gen y2 = 25 + 0*D + 2*z + z2 + rnormal(0, 20)
scatter y2 z if D==0, msize(vsmall) || scatter y2 z if D==1, msize(vsmall) legend(off) ///
	xline(50, lstyle(foreground)) ytitle("Outcome (y)") ztitle("Test Score (z)")
	
reg y D z
reg y D z z2

