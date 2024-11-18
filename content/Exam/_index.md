---
header:
  caption: ""
  image: ""
title: Exam
view: 2
---

To successfully complete this course, you will need to fulfill two requirements:

1. **Completion of at least 10 Weekly Absalon online quizzes**: You must submit a minimum of 10 of the Weekly Online Quizzes [available on the Absalon page for this course](https://absalon.ku.dk/courses/70545). *Only by submitting at least 10 quizzes will you qualify for the second task!* Quizzes should be submitted within two weeks after they are made available online. Completion of at least 10 weekly Absalon online quizzes is a prerequisite for being eligible to take the written take-home exam, which is integrated with the "Velfærd, ulighed og mobilitet" course.

2. **Submit a written exam by 10 January at 12.00.**: Please see exam guidelines below, including info for students who write their exam only in this course but not also "Welfare, Inequality and Mobility" (VuM).

# Integrated Exam Assignment in Welfare, Inequality and Mobility (VUM) and Advanced Quantitative Methods (VKM); for non-integrated exams see "Merit Students"

## Problem Formulation and Structure of the Assignment
In this written, integrated exam, you must formulate your own research question and answer it based on data from the Danish part of the European Social Survey (ESS) 2018. Your research question must meet the following requirements: It must address a socioeconomic, gender, or ethnic gap in attitudes and attempt to explain this gap with confounding and/or mediating variables.

The exam assignment is structured around a gap in attitudes that you try to explain. This central difference can be a socioeconomic gap (e.g., highly educated compared to less educated), gender gap (women compared to men), or an ethnic gap (immigrants and their descendants compared to ethnic Danes). You choose which attitude dimensions from ESS 2018 you want to analyze. Examples of attitudes you could analyze are: attitudes towards redistribution and the welfare state, attitudes towards social justice, or attitudes towards gender roles.

Examples of research questions:

- Is there a gender gap between men's and women's attitudes towards redistribution, and if so, can this gap be explained by differences in men's and women's education and labor market participation?
- Is there an ethnic gap between immigrants (and their descendants) and people with Danish origin in trust in the police, and if so, can this gap be explained by differences in age and education or discrimination between the two groups?

## The exam assignment has three parts.

In the first part, you must *establish an analytical framework*. The purpose of this framework is to motivate which socioeconomic or subjective factors might explain the central gap you are interested in. Use the syllabus from VUM, e.g., theories or studies discussed in the course, to motivate the central difference you are analyzing. For example, gaps in men's and women's attitudes towards redistribution may be due to differences in men's and women's education, labor market participation, or prioritization of work and family. Socioeconomic or attitudinal differences may also be relevant for immigrants and their descendants, but discrimination may be another factor. In addition to the syllabus from VUM, you are welcome to supplement with theories/ideas from previous courses to the extent you find it relevant (petitum, see below). You should use your analytical framework to motivate the choice of explanatory variables (e.g., education and attitudes) and whether these variables are confounding or mediating variables.

In the second part, you must *present a methodological design* that you will use to identify and explain the central gap you are interested in. The methodological design has two sub-elements. (i) First, you must present a methodological design that you will implement in the third part (see below), and which is based on the statistical tools you have learned in VKM. In this part, you should (briefly) describe the statistical tools you use (e.g., OLS regression), and introduce the dataset and your operationalization of variables. (ii) Second, you should discuss what causal assumptions are baked into your methodological design, and whether these assumptions are credible in your analysis. You should also (briefly) present an ideal design that would allow you to identify the causal relationships you assume in your analytical framework. For example, what might an RCT, IV, or RDD design look like that would allow you to identify credible causal relationships?

In the third part, you must *implement your empirical research design in practice* and test whether the central gap in the attitude dimension you are working with (e.g., differences in men's and women's attitudes towards redistribution) is due to the factors you have outlined in your analytical framework (e.g., differences in men's and women's education and labor market participation). You should draw on your analytical framework and your methodological design when interpreting the empirical results, including whether the explanatory variables are confounders or mediators.

2. Data and Variables
The data comes from round 9 of the Danish part of the European Social Survey (ESS), which was collected in 2018. ESS interviews a representative sample of the adult population. You can read more about ESS here: https://www.europeansocialsurvey.org/.

2.1 Dependent Variable
ESS asks respondents about their attitudes towards a wide range of issues. You decide which attitude variable you want to use as the dependent variable. If several variables appear to measure a larger concept (e.g., attitudes towards immigrants), and are measured on the same kind of scale (e.g., 1-10), you can combine these variables into one additive scale by adding the values of the variables together and dividing by the number of variables in the scale: x = (x1 + x2 + x3 + x4 + … Xk) / k. If an attitude variable is measured by a Likert scale, e.g., an ordinal five-point scale (1-5), you may interpret and treat this variable as a continuous variable.

2.2 The Central Difference
The central gap you are working with as the most important explanatory variable must be coded as a binary (i.e., 0-1) dummy variable (e.g., female/male, immigrant/descendant, low/high education).

2.3 Independent Variables
ESS contains rich information about the respondents, which you can use to explain the central gap in attitudes you are working with. There is information on socioeconomic factors (e.g., education, labor market position, income), attitudes (e.g., towards social justice), family background (e.g., parents' education and labor market position), and personal experiences of discrimination. You decide which factors to include in your analysis as independent variables. Consider which independent variables are particularly relevant to your analysis, and how many variables it makes sense to include. No one expects you to identify a perfect causal relationship. Nevertheless, consider the problem of causal identification when choosing your explanatory factors and the control variables or instruments you could potentially use.

2.4 Weights
Remember to use post-stratification weights in all your analyses.

## Requirements for the empirical analysis:

You must estimate a series of OLS regression models with your attitude variable as the dependent variable.
The first model should only contain one independent variable: the binary variable that measures the central gap you are interested in (e.g., female/male, immigrant/descendant, low/high education).

In the next models, you try to explain the central gap. You do this by including other independent variables in the OLS model. Consider whether you interpret the other independent variables as confounders or mediators. Calculate how much of the central difference the other independent variables explain. 

The purpose of the analysis is not to add as many independent variables as possible. The purpose is to include a set of analytically/theoretically well-founded independent variables and to make a credible interpretation of these variables.

You must test for at least one non-linear effect or one interaction effect in your models and plot these associations using model predictions (and interpret the interaction effect if it is statistically significant).

You must use the design weight in all analyses.

You should consider any limitations in your empirical design in relation to being able to make causal interpretations. Could there be circumstances that challenge a causal interpretation?

### Merit Students
Merit students taking the exam in VUM but not VKM must answer the first research question described above: Is there a gap between men's and women's attitudes towards redistribution, and if so, can this gap be explained by differences in men's and women's education and labor market participation? Instead of an independent empirical analysis, the research question must be answered based on the syllabus from VUM supplemented with petitum literature from your own literature search.

Students taking the exam in "Multiple Regression and the Foundation of Causal Inference" but not VUM must follow the same exam guidelines but do not need to develop a conceptual and theoretical framework. Briefly justifying the choice of explanatory variables etc. will be sufficient.

4. Practical Information
- The exam assignment follows the guidelines for a written assignment (see chapter 5 in the study regulations)
- The scope of the assignment is a maximum of 15 pages of 2400 characters if it is done by one student. 5 pages are added per student if the assignment is done in groups. A reasonable (but in no way binding) allocation of a 15-page assignment could be the following: introduction (2 pages), analytical framework (4 pages), methodology/data/variables (4 pages), empirical analysis (4 pages) and conclusion (1 page).
- You must not write your name in the assignment - all assessments are anonymous.
- You must remember to enclose a declaration on the use of AI.
- Familiarize yourself with the rules regarding the use of syllabus and petitum (the latter are texts that you choose yourself and which are in addition to the syllabus). Note that (a) you must use and cite at least 25% of the syllabus in your assignment, (b) syllabus references may constitute a maximum of 2/3 of the total references and (c) petitum must constitute at least 1/3 of the total references. Since the exam in VUM/VKM is integrated, the syllabus consists of the combined reading list for both courses.
- The deadline for submission is 10/1 2025 at 12.00.