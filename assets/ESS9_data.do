* **************************
* VUM + VKM - EKSAMEN 2023 *
* **************************

clear
set more off

* INDLÆS ESS 9
cd "/Users/fsm788/Documents/Teaching/My classes/Multiple Regression and Causal Inference/assets"
use ESS9e03_2.dta

* BRUG KUN DATA FRA DK
keep if cntry == "DK"

********************************
* DEMOGRAFISKE KONTROLVARIABLE *
********************************

* Køn - dummy for kvinde
gen women = 0
replace women = 1 if gndr == 2
lab var women "Dummy for women"

* Alder i år
hist agea

*********************
* MATERIEL POSITION *
*********************

* Dummy for indkomst i laveste decil/10%
gen low_inc = 0
replace low_inc = 1 if hinctnta == 1
lab var low_inc "Own income in the bottom 10%"

* Dummy for indkomst i højeste decil/10%
gen high_inc = 0
replace high_inc = 1 if hinctnta == 10
lab var high_inc "Own income in the top 10%"

* Dummy for pt. i betalt arbejde
gen working = 0
replace working = 1 if pdwrk == 1
lab var working "Currently working"

* Dummy for nogensinde været arbejdsløs og søgt efter arbejde i mere end tre måneder
gen ever_unempl = 0
replace ever_unempl = 1 if uemp3m == 1
lab var ever_unempl "Ever unemployed > 3 months"


* *********************
* SUBJEKTIVE VARIABLE *
* *********************

* B26: I politik bruges sommetider betegnelserne "venstre" og "højre". Hvor vil du placere dig selv på denne skala, hvor 0 betyder venstre, og 10 betyder højre? (Højere værdier -> mere højreorienteret)
hist lrscale

* B6: Hvor stor tillid har du til Folketinget?
hist trstprl

* G27: Et samfund er retfærdigt, når dem, der arbejder hårdt, kan tjene mere end andre
gen hard_work = 6 - sofrwrk
lab var hard_work "Work hard -> higher salary"



* ********************
* AFHÆNGIGE VARIABLE *
* ********************

* G18: Øverste 10% (735.000 kr. per år). Hvor meget & rimeligt
gen topindk_fair = topinfr
lab var topindk_fair "Top 10%: Unreasonable income"


* G19: Nederste 10% (305.900 kr. per år). Hvor meget & rimeligt
gen bottomindk_fair = btminfr
lab var bottomindk_fair "Bottom 10%: Unreasonable income"

*histogram topindk_fair, discrete percent
*histogram bundindk_fair, discrete percent


********
* VÆGT *
********

hist pspwght


* ******************
* DESKRIPTIV STATS *
* ******************

summ topindk_fair bottomindk_fair high_inc low_inc working ever_unempl lrscale trstprl hard_work women agea [w = pspwght]
keep topindk_fair bottomindk_fair high_inc low_inc working ever_unempl lrscale trstprl hard_work women agea pspwght

* ****************
* ANALYSEDATASÆT *
* ****************

mvencode _all, mv(-99)

gen filter = 1
replace filter = 0 if topindk_fair == -99
replace filter = 0 if bottomindk_fair == -99
replace filter = 0 if high_inc == -99
replace filter = 0 if low_inc == -99
replace filter = 0 if working == -99
replace filter = 0 if ever_unempl == -99
replace filter = 0 if lrscale == -99
replace filter = 0 if trstprl == -99
replace filter = 0 if hard_work == -99
replace filter = 0 if women == -99
replace filter = 0 if agea == -99
keep if filter == 1
drop filter

summ


* **************
* REGRESSIONER *
* **************

reg topindk_fair working low_inc high_inc ever_unempl women agea trstprl [pw=pspwght]
est sto topinc
reg topindk_fair working low_inc high_inc ever_unempl women agea trstprl [pw=pspwght]
est sto lowinc


estout topinc lowinc, cells(b(star fmt(3)) se(par)) stats(N r2, fmt(%9.3f %9.0g) labels(N R-squared)) varlabels(_cons Constant) title("Regressions of Fair Incomes")
est clear

* GEM DATASÆT
compress
save Stats2, replace