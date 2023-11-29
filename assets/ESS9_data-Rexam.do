* **************************
* VUM + VKM - EKSAMEN 2023 *
* **************************

clear
set more off

* INDLÆS ESS 9
* cd H:\Work\Teaching\VUM\Eksamen\E23\ESS9
cd "/Users/fsm788/Documents/Teaching/My classes/Multiple Regression and Causal Inference/assets"
use ESS9e03_2.dta

* BRUG KUN DATA FRA DK
keep if cntry == "DK"


********************************
* DEMOGRAFISKE KONTROLVARIABLE *
********************************

* Køn - dummy for kvinde
gen kon = 0
replace kon = 1 if gndr == 2
lab var kon "Dummy for kvinde"

* Ægteskabelig status
gen aegte = marsts
lab def aegte 1 "Lovformeligt gift" 2 "Lovligt registreret borgerligt indgået ægteskab" 3 "Lovligt separeret" 4 "Juridisk skilt" 5 "Enke" 6 "Andre"
lab val aegte aegte
lab var aegte "Kategorisk variabel for ægteskabelig status"


*********************
* MATERIEL POSITION *
*********************

* Antal års uddannelse
gen udd = eduyrs

* Dummy for indkomst i laveste decil/10%
gen lavindk = 0
replace lavindk = 1 if hinctnta == 1
lab var lavindk "Egen indkomst i nederste 10%"

* Dummy for indkomst i højeste decil/10%
gen hojindk = 0
replace hojindk = 1 if hinctnta == 10
lab var hojindk "Egen indkomst i øverste 10%"

* Dummy for pt. i betalt arbejde
gen arbejde = 0
replace arbejde = 1 if pdwrk == 1
lab var arbejde "Pt. i arbejde"

* Dummy for nogensinde været arbejdsløs og søgt efter arbejde i mere end tre måneder
gen arblos = 0
replace arblos = 1 if uemp3m == 1
lab var arblos "Nogensinde arbløs > 3 måneder"



* *********************
* SUBJEKTIVE VARIABLE *
* *********************

* De fleste mennesker kan man stole på, eller man kan ikke være for forsigtig.
gen tillid = ppltrst
lab var tillid "De fleste mennesker kan man stole på"

* B6: Hvor stor tillid har du til Folketinget?
gen rich = 6 - imprich
lab var rich "Vigtigt at være rig, have penge og dyre ting"

* Hvor religiøs er du?
gen rel = rlgdgr
lab var rlgdgr "Hvor religiøs er du?"

* Regeringen bør reducere forskelle i indkomstniveauer
gen inkdif = 5 - gincdif
lab var inkdif "Regeringen bør reducere forskelle i indkomstniveauer"

* ********************
* AFHÆNGIGE VARIABLE *
* ********************

* G18: Øverste 10% (735.000 kr. per år). Hvor meget & rimeligt
gen topindk_fair = topinfr
lab var topindk_fair "Top 10%: Urimelig indkomst"


* G19: Nederste 10% (305.900 kr. per år). Hvor meget & rimeligt
gen bundindk_fair = btminfr
lab var bundindk_fair "Bund 10%: Urimelig indkomst"

*histogram topindk_fair, discrete percent
*histogram bundindk_fair, discrete percent


********
* VÆGT *
********

gen vaegt = pspwght

* ******************
* DESKRIPTIV STATS *
* ******************

summ topindk_fair bundindk_fair hojindk lavindk arbejde arblos tillid rich rel inkdif kon aegte vaegt
keep topindk_fair bundindk_fair hojindk lavindk arbejde arblos tillid rich rel inkdif kon aegte vaegt


* ****************
* ANALYSEDATASÆT *
* ****************

mvencode _all, mv(-99)

gen filter = 1
replace filter = 0 if topindk_fair == -99
replace filter = 0 if bundindk_fair == -99
replace filter = 0 if hojindk == -99
replace filter = 0 if lavindk == -99
replace filter = 0 if arbejde == -99
replace filter = 0 if arblos == -99
replace filter = 0 if tillid == -99
replace filter = 0 if rich == -99
replace filter = 0 if rel == -99
replace filter = 0 if inkdif == -99
replace filter = 0 if kon == -99
replace filter = 0 if aegte == -99
keep if filter == 1
drop filter

summ


* **************
* REGRESSIONER *
* **************

reg topindk_fair arbejde lavindk hojindk arblos i.kon##i.aegte rel [pw=vaegt]
est sto topinc
reg bundindk_fair arbejde lavindk hojindk arblos i.kon##i.aegte rel [pw=vaegt]
est sto lowinc


estout topinc lowinc, cells(b(star fmt(3)) se(par)) stats(N r2, fmt(%9.3f %9.0g) labels(N R-squared)) varlabels(_cons Constant) title("Regressions of Fair Incomes")
est clear

* GEM DATASÆT
compress
save vum23-rexam, replace