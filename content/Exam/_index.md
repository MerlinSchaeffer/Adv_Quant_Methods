---
header:
  caption: ""
  image: ""
title: ""
view: 2
---

To successfully complete this course, you will need to fulfill two requirements:

1. **Completion of at least 10 Weekly Absalon online quizzes**: You must submit a minimum of 10 of the Weekly Online Quizzes [available on the Absalon page for this course](https://absalon.ku.dk/courses/70545). *Only by submitting at least 10 quizzes will you qualify for the second task!* Quizzes should be submitted within two weeks after they are made available online. Completion of at least 10 weekly Absalon online quizzes is a prerequisite for being eligible to take the home assignment (final exam).

2. **Submit a home assignment (final exam) by 12 January 2026 at 12.00.**: Please see exam guidelines below.

# Exam
This examination consists of two primary components. The first component requires a statistical analysis of a provided dataset to test a set of pre-registered hypotheses. The second component requires you to propose an alternative research design to test the principal hypothesis.

![](/img/Pictures.png)

- Pre-registrations: [Link to Pre-registration 1](https://osf.io/76usw/overview?view_only=c7fdbbb8e2eb4e77b072544579fb2aa1) and [Link to Pre-registration 2](https://osf.io/g8n4v/overview?view_only=97f3c8ec393d470085283b57a272683a)

- Questionnaire: You can find a link to the questionnaire in the pre-registration.

- Data Availability: The dataset will be made available at the beginning of December.

## Component 1: Data Analysis and Interpretation
You will be provided with a dataset from a survey experiment conducted by my colleagues and me in September. You will also receive the full questionnaire and two separate pre-registrations. A pre-registration is a document researchers file in a public registry before data collection, outlining their hypotheses and planned analysis strategies. Your task is to select one of the two pre-registrations and conduct the statistical analyses to test *all of its hypotheses*. You must adhere as closely as possible to the analytical strategy described in your chosen pre-registration. Note however, that you will not need to merge/join any data from Statistics Denmark. To test hypotheses about respondents' neighborhood characteristics, instead use the questions on the subjectively perceived shares of different social groups (e.g., share of immigrants, unemployed, etc) in their nieghborhood. Combine them into an additive scale, by first z-standardizing each of them and then taking the average value across all of them using the R function `rowMeans()` with the argument `na.rm = TRUE`. Your deliverable will be a written report of your methods and findings. This component requires you to produce two core sections of a scientific paper:

1. A "Data and Methods" Section:

  + Describe the operationalization of all variables used in your analysis (dependent, treatment, control).

  + Clearly identify the socio-demographic variables (e.g., age, gender, education) and detail how they are included as pre-treatment control variables.

  + Document your data cleaning and preparation process, including the management of missing values.

  + Specify the statistical methods used (e.g., OLS regression) and justify their appropriateness based on the pre-registration.

2. A "Results" Section:

  + Present the findings of your statistical analyses.

  + You must estimate a series of OLS regression models as the core of your analysis.

  + The purpose of the analysis is to test the pre-registered hypotheses, including the effects of the randomized treatment variables and any specified moderators (i.e., interaction effects).

  + Use appropriate tables and/or visualizations (e.g., coefficient plots) to communicate results clearly.

  + Correctly interpret the statistical results in the context of the pre-registered hypotheses.

  + You must briefly discuss any limitations of the empirical design concerning causal interpretation. Are there any circumstances or unaddressed factors that might challenge a strictly causal reading of the results?

## Component 2: Alternative Research Design
First, briefly discuss the primary limitations of the original survey experiment for testing its hypotheses. Thereafter, propose an alternative research design to test *the first-listed hypothesis* from your chosen pre-registration. Your proposed alternative design must be one of the following: A natural experiment, a regression discontinuity design (RDD), an instrumental variable (IV) regression design. You must discuss the key assumptions of your chosen design (e.g., the exclusion restriction for an IV, or the "no-manipulation" assumption for an RDD). You must explain how your specific research proposal meets these assumptions to ensure a valid causal estimate.

## Submission and Formatting Requirements
- The deadline for submission is 12 January 2026 at 12 am (noon).
- The scope of the assignment is max 10 pages of 2400 characters each, if it is done by one student. 5 pages are added per student if the assignment is done in groups.
- You must not write your name in the assignment – all exam papers are anonymous.
- You must remember to enclose a declaration on the use of AI.
- Familiarize yourself with the rules regarding the use of syllabus and petitum (external texts chosen by you). Note that (a) you must use and cite at least 25% of the syllabus in your assignment, (b) syllabus references may constitute a maximum of 2/3 of the total references and (c) petitum must constitute at least 1/3 of the total references. Two books books count as the syllabus pensum, so citing one of of them fulfills the pensum requirement.

## Advisory Guide for Paper Organization
This section provides general advice on structuring your exam paper. To get a general impression, take a close look at the research articles that I posted as optional reading's, like Legewie's study on the Bali terror attack. While you do not need theoretical discussion, like these article have it, the way they present the data, methods, and the results, should guide you as examples. The main objective is to help you allocate your space effectively to the core tasks: (1) Introduction, (2) Analysis of the experiment, (3) Proposal of the alternative design, and (4) Conclusion. A reasonable (but non-binding) page allocation for a 10-page group assignment might be:

- Introduction (1/2 pages): Introduce the research question from the pre-registration and outline the paper's structure.

- Component 1: Analysis of Survey Experiment (7 pages):

  - Data and Methods (3 pages): Describe how you interpret, recode, and prepare all variables for analysis. Justify your choices. The reader must be able to follow your process from the "raw data" to the final "analysis data." Explicitly discuss your strategy for handling missing values. Use clear, easy-to-understand variable names (e.g., "Education Level") in your text, not programmatic names (e.g., "kl_z005"). You should present descriptive statistics for your key variables, particularly showing the balance of pre-treatment covariates across the experimental treatment groups.

  - Results and Interpretation (4 pages): Discussion of Results Your analysis and interpretation should be integrated. Do not simply describe a table ("Table 1 shows a coefficient of x") and save the interpretation for later. Analyze and interpret your findings as you present them. Consolidate information effectively; well-formatted regression tables are ideal. The primary focus for hypothesis testing should be on the regression coefficients and their standard errors/confidence intervals, not on model fit statistics like R. Instead of a table, you may present regression results using a coefficient plot (see Week 6 lecture). If you do, you must include the number of observations (N) and R values in a note accompanying the plot. Do not copy-paste raw output from R or other software. Tables must be formatted neatly and be legible. All tables and figures must have numbered, descriptive titles.

- Component 2: Alternative Research Design (2 pages):

  - Critique of original design.
  - Proposal of new design (NE, RDD, or IV) and discussion of assumptions
  
Conclusion (1 page): Summarize the key findings from both components. Ensure your conclusion provides a clear and unambiguous answer to the research question(s) from Component 1 and summarizes the contribution of your proposed design from Component 2.


## Writing Style

- Avoid Footnotes: All essential information must be in the main text.

- Meta-Text: Use "signposting" to guide your reader. For example: "Having established X in the previous section, I now turn to Y..."

- Avoid normative or subjective language (e.g., "My research proves this is harmful..."). Maintain an objective, academic tone throughout your analysis and discussion.

- I strongly recommend engaging in peer review with a reading group partner.

- Use spell-checking tools and/or generative AI to check for basic grammatical errors and typos. It is notoriously difficult to spot your own errors after submission.

Finally, no one expects perfection. The purpose of this examination is to learn and apply complex skills.

Good luck! 😊

