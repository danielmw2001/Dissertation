* Cross sectional dependence and unit root testing
use "/Users/danmw/Desktop/Diss/9 countries.dta"

xtset country2 year
xtreg lnco2 lny lnysq lnycb ipenergy iptfp iptrade lnoil lngini, fe
xtcsd, pes

xtunitroot ips lny, lags(aic)
xtunitroot ips lnysq,  lags(aic)
xtunitroot ips lnycb,  lags(aic)
xtunitroot ips lnco2,  lags(aic)
xtunitroot ips ipenergy,  lags(aic)
xtunitroot ips iptfp, lags(aic)
xtunitroot ips lnoil,  lags(aic)
xtunitroot ips lngini,  lags(aic)
xtunitroot ips iptrade,  lags(aic)

xtunitroot ips d.lny, lags(aic)
xtunitroot ips d.lnysq,  lags(aic)
xtunitroot ips d.lnycb,  lags(aic)
xtunitroot ips d.lnco2,  lags(aic)
xtunitroot ips d.ipenergy,  lags(aic)
xtunitroot ips d.iptfp,  lags(aic)
xtunitroot ips d.lnoil,  lags(aic)
xtunitroot ips d.lngini,  lags(aic)
xtunitroot ips d.iptrade,  lags(aic)

xtunitroot breitung lny, lags(1)
xtunitroot breitung lnysq,  lags(1)
xtunitroot breitung lnycb,  lags(1)
xtunitroot breitung lnco2,  lags(1)
xtunitroot breitung ipenergy,  lags(1)
xtunitroot breitung iptfp, lags(1)
xtunitroot breitung lnoil,  lags(1)
xtunitroot breitung lngini,  lags(1)
xtunitroot breitung iptrade,  lags(1)

xtunitroot breitung d.lny, lags(1)
xtunitroot breitung d.lnysq,  lags(1)
xtunitroot breitung d.lnycb,  lags(1)
xtunitroot breitung d.lnco2,  lags(1)
xtunitroot breitung d.ipenergy,  lags(1)
xtunitroot breitung d.iptfp, lags(1)
xtunitroot breitung d.lnoil,  lags(1)
xtunitroot breitung d.lngini,  lags(1)
xtunitroot breitung d.iptrade,  lags(1)

xtunitroot breitung d.d.lngini

*Hausman
xtreg d.(lnpe lny lnysq lnycb ipenergy iptrade iptfp lnoil lngini), fe 
estimates store fe
xtreg d.(lnco2 lny lnysq lnycb ipenergy iptrade iptfp lnoil lngini), re
estimates store re
hausman fe re

*Fixed Effects
xtreg d.(lnpco2 lny lnysq lnycb ipenergy iptrade iptfp lnoil lngini), fe robust
xtreg d.(lnpe lny lnysq lnycb ipenergy iptrade iptfp lnoil lngini), fe robust

*non parapetric
npregress kernel dlnco2 dlny dlnysq dlnycb dipenergy diptfp diptrade dlnoil dlngini, vce(boot)
npregress kernel dlnpe dlny dlnysq dlnycb dipenergy diptfp diptrade dlnoil dlngini, vce(boot)

*gmm 
xtabond2 l(0/2).d.(lnco2) d.(lny lnysq lnycb lnoil ipenergy iptrade lngini iptfp), gmm(l(1/2).d.(lnco2 lny lnysq lnycb lnoil ipenergy iptrade d.lngini iptfp),collapse) ortho small robust

xtabond2 l(0/2).d.(lnpe) d.(lny lnysq lnycb lnoil ipenergy iptrade lngini iptfp), gmm(l(1/2).d.(lnco2 lny lnysq lnycb lnoil ipenergy iptrade d.lngini iptfp),collapse) ortho small robust

*Logistic
bysort country2: egen mean_lnco2 = mean(lnco2)
gen co2diff = mean_lnco2 - lnco2
gen co2pos = co2diff < 0
clogit co2pos diptrade dipenergy diptfp dlny dlnysq dlnycb dlnoil dlngini, group(country2) vce(robust)
margins, dydx(*)

*Logistic for PE
bysort country2: egen mean_pe = mean(lnpe)
gen pediff = mean_pe - lnpe
gen pepos = pediff < 0
clogit pepos diptrade dipenergy diptfp dlny dlnysq dlnycb dlnoil dlngini, group(country2) vce(robust)
margins, dydx(*)

