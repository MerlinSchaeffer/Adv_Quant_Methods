----------------------------
README for replication files
----------------------------

INITIAL DEPOSIT DATE: September 23, 2020
THIS VERSION: October 22, 2020

ARTICLE: “The Unequal Distribution of Opportunity: A National Audit Study of Bureaucratic Discrimination in Primary School Access”
AUTHORS: Asmus Leth Olsen, Jonas Høgh Kyhse-Andersen and Donald Moynihan 

-----------------------------------
NOTES
-----------------------------------

Replication code, data, and codebooks needed to reproduce results presented in-text and in the Supplemental Information provided for the study. 

NOTE: unit and subject identifiers have been removed to protect the anonymity of study participants, as required by GDPR regulations in Denmark. 

Only variables necessary to reproduce the results presented in the paper are contained in this repository. 

Please report any errors to Asmus Leth Olsen; current contact info: ajlo@ifs.ku.dk

-----------------------------
FILE LIST
-----------------------------

DOCUMENTATION
codebook.pdf -- codebook for all variables included in each data file.

DATA FILES:
df1.Rda -- data file needed to reproduce most tables and figures.
responder_df.Rda -- data file for email responder characteristics. 
school_df.Rda -- data file for school level characteristics.

R-SCRIPTS:
ms_tables_figures.R -- code that produces all results presented in the main text.
si_tables_figures.R -- code that produces all results in supplementary information.

-----------------------------------
COMPUTING ENVIROMENT
-----------------------------------

R version 4.0.2 (2020-06-22) -- "Taking Off Again"
Copyright (C) 2020 The R Foundation for Statistical Computing
Platform: x86_64-w64-mingw32/x64 (64-bit)

Windows 10 Enterprise, version 1709, OS Build 16299.2107.

Associated R packages (version): 

tidyverse (1.3.0)
estimatr (0.26.0)
texreg (1.37.5)
nnet (7.3-14)
MASS(7.3-53)
ltm (1.1-1)
gridExtra (2.3)
scales (1.1.0)
cowplot (1.0.0)