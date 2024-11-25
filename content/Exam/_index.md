---
header:
  caption: ""
  image: ""
title: ""
view: 2
---

To successfully complete this course, you will need to fulfill two requirements:

1. **Completion of at least 10 Weekly Absalon online quizzes**: You must submit a minimum of 10 of the Weekly Online Quizzes [available on the Absalon page for this course](https://absalon.ku.dk/courses/70545). *Only by submitting at least 10 quizzes will you qualify for the second task!* Quizzes should be submitted within two weeks after they are made available online. Completion of at least 10 weekly Absalon online quizzes is a prerequisite for being eligible to take the written take-home exam, which is integrated with the "Velfærd, ulighed og mobilitet" course.

2. **Submit a written exam by 10 January at 12.00.**: Please see exam guidelines below, including info for students who write their exam only in this course but not also "Welfare, Inequality and Mobility" (VuM).

# Exam

## 1. Problem Formulation and Structure of the Assignment**

In this written, integrated exam, you must formulate your own research question and answer it based on data from the Danish part of the European Social Survey (ESS) 2018. Your research question must meet the following requirements: It must address a socioeconomic, gender, or ethnic gap in attitudes and attempt to explain this gap with confounding and/or mediating variables.

The exam assignment is structured around a gap in attitudes that you try to explain. This central gap can be a socioeconomic gap (e.g., highly educated compared to less educated), gender gap (women compared to men), or an ethnic gap (immigrants and their descendants compared to ethnic Danes). You choose which attitude dimensions from ESS 2018 you want to analyze. Examples of attitudes you could analyze are: attitudes towards redistribution and the welfare state, attitudes towards social justice, or attitudes towards gender roles.

**Examples of research questions:**

1. Is there a gap between men's and women's attitudes towards redistribution and, if so, can this gap be explained by differences in men's and women's education and labor market participation?
2. Is there a gap between immigrants (and their descendants) and people of Danish origin's trust in the police, and if so, can this gap be explained by differences in age and education or discrimination between the two groups?


**The exam assignment has three parts.**

In the first part, you must establish an analytical framework. The purpose of this framework is to motivate which socioeconomic or subjective factors might explain the central gap you are analyzing. Use the syllabus from VUM, e.g., theories or studies discussed in the course, to motivate the central gap you are analyzing. For example, gaps in men's and women's attitudes towards redistribution may be due to differences in men's and women's education, labor market participation, or prioritization of work and family. Socioeconomic or attitudinal gaps may also be relevant for immigrants and their descendants, but discrimination may be another factor. In addition to the syllabus from VUM, you are welcome to supplement with theories/ideas from previous courses and other literature (petitum, see below). You should use the analytical framework to motivate the choice of explanatory variables (e.g., education and attitudes) and whether these variables are confounding or mediating variables in your analysis.

In the second part, you must present a methodological design that you will use to identify and explain the central gap you are analyzing. This design has two sub-elements. (i) First, you must present the methodological design that you will implement in the third part (see below), which is based on the statistical tools you have learned in VKM. In this part, you should (briefly) describe the statistical tools you use (e.g., OLS regression), and introduce the dataset and your operationalization of dependent and independent variables. (ii) Second, you should discuss what causal assumptions are baked into your methodological design and whether these assumptions are credible in your specific analysis. You should also (briefly) present an ideal design that would allow you to identify the causal relationships you assume in your analytical framework. How could you use, for example, an RCT, IV, or RDD design to identify credible causal relationships?

In the third part, you must implement your empirical research design in practice and test whether the central gap in the attitude dimension you are analyzing (e.g., gap in men's and women's attitudes towards redistribution) is due to the factors you have identified in your analytical framework (e.g., differences in men's and women's education and labor market participation). You should draw on your analytical framework and your methodological design when interpreting the empirical results, including whether the explanatory variables are confounders or mediators.

## 2. Data and Variables

The data comes from round 9 of the Danish part of the European Social Survey (ESS), which was collected in 2018. ESS interviews a representative sample of the adult population. You can read more about ESS here: [https://www.europeansocialsurvey.org/](https://www.europeansocialsurvey.org/).

**2.1 Dependent Variable**

ESS asks respondents about their attitudes towards a wide range of issues. You decide which attitude variable you want to use as the dependent variable. If several variables appear to measure a larger concept (e.g., attitudes towards immigrants) and are measured on the same kind of scale (e.g., 1-10), you can combine these variables into one additive scale by adding the values of the variables together and dividing by the number of variables in the scale: x = (x1 + x2 + x3 + x4 + … Xk) / k. If an attitude variable is measured by a Likert scale, e.g., an ordinal five-point scale (1-5), you may interpret and treat this variable as a continuous variable. You may only use one dependent variable in your analysis.

**2.2 The Central Difference**

The central gap you are analyzing, which is the most important independent variable in your analysis, should be coded as a binary (i.e., 0-1) dummy variable (e.g., female/male, immigrant/descendant, low/high education).

**2.3 Independent Variables**

ESS contains rich background information about the respondents, which you can use to explain the central gap in attitudes you are analyzing. There is information on socioeconomic factors (e.g., education, labor market position and income), attitudes (e.g., towards social justice), family background (e.g., parents' education and labor market position) and personal experiences of discrimination. You decide which factors you include in your analysis as independent variables. Consider which independent variables are particularly relevant in your analysis and how many variables it makes sense to include. No one expects you to identify a perfect causal relationship. Nevertheless, consider the problem of causal identification when choosing your independent variables or instruments you could potentially use.

**2.4 Weights**

Remember to use the post-stratification weights in all your analyses. The post-stratification weights are called "pspwght".

**2.5 Requirements for the empirical analysis:**

- You must estimate a series of OLS regression models with your attitude variable as the dependent variable.
- The first model should only contain one independent variable: the binary variable that measures the central gap you are analyzing (e.g., female/male, immigrant/descendant, low/high education).
- In the next models, you try to explain the central gap. You do this by including other independent variables in the OLS model. Consider whether you interpret the other independent variables as confounders or mediators. Calculate how much of the central gap the other independent variables explain (i.e., how much of the central difference is due to the other independent variables).
- The purpose of the analysis is not to use as many independent variables as possible. The purpose is to include a set of well-founded independent variables and to make a credible interpretation of the effect of these variables.
- You must test for at least one non-linear effect or one interaction effect in your models and must plot these effects using model predictions (and interpret the interaction effect if it is statistically significant).
- You must use the post-stratification weight in all analyses.
- You should consider any limitations in your empirical design in relation to being able to make causal interpretations. Could there be circumstances that challenge a causal interpretation?

## 3. Merit Students

Merit students who take the exam in VUM but not VKM must answer the first question described above: Is there a difference between men's and women's attitudes towards redistribution and, if so, can this difference be explained by differences in men's and women's education and labor market participation? Instead of an independent empirical analysis based on data from ESS, the problem must be answered based on the syllabus from VUM supplemented by petitum literature from your own literature search.

Merit and exchange students who take the exam in VKM but not VUM must follow the guidelines described above, but do not need to include an analytical framework. However, there must be a concise justification for the choice of dependent and independent variables.

## 4. Practical Information

- The exam assignment follows the guidelines for a written assignment (see chapter 5 in the study regulations for sociology)
- The scope of the assignment is max 15 pages of 2400 characters if it is done by one student (10 pages for exchnage students). 5 pages are added per student if the assignment is done in groups. A reasonable (but in no way binding) allocation of a 15-page assignment could be the following: introduction (2 pages), analytical framework (4 pages), methodology/data/variables (4 pages), empirical analysis (4 pages) and conclusion (1 page).
- You must not write your name in the assignment – all exam papers are anonymous.
- You must remember to enclose a declaration on the use of AI.
- Familiarize yourself with the rules regarding the use of syllabus and petitum (the latter are texts that you choose yourself and which are in addition to the syllabus). Note that (a) you must use and cite at least 25% of the syllabus in your assignment, (b) syllabus references may constitute a maximum of 2/3 of the total references and (c) petitum must constitute at least 1/3 of the total references. Since the exam in VUM/VKM is integrated, the syllabus consists of the combined reading list for both courses.
- The deadline for submission is 10/1 2024 at 12.

## 5. Practical Guide

**Introduction**

The purpose of this section is to give you some tips on how to organize your exam assignment. Some tips are about writing style and argumentation, while others are about how to best present your method and empirical results. The main ambition of this section is to give you tools so you can use as much space as possible on the core elements of your assignment: (1) background/theory, (2) operationalization, (3) method, and (4) analysis.

Note that this section is general and does not refer to the specific exam assignment. Therefore, all references to data, variables, etc. are intended as examples.

**What is the VUM/VKM assignment – and what is it not?**

**Background/Theory**

You come from the first year and have written assignments/exercises in theory courses. VUM (+ VKM) is not a theory course, but rather a thematic course. The purpose of your background/theory section is not to compare theorists (i.e., people), but rather to draw on theoretical arguments to illuminate the problem that the exam assignment deals with. Write clearly and focused: the theory is the means and not the goal. Avoid implicit theoretical jargon ("structuring structures that structure...") and, as far as possible, present theoretical ideas in your own words (i.e., avoid many/long quotes from original/secondary sources).

Argue for your choice of theory/perspective. Tell us precisely why the theory(ies)/perspective(s) you have chosen to draw on are well-suited to illuminate the specific problem. The more concrete you are, the better your presentation will be. "I think theorist x is suitable" is not a good argument.

**Hypotheses:**

Feel free to formulate directional hypotheses that you can test empirically. A directional hypothesis postulates a negative or positive relationship between the values of two variables. For example, the following hypothesis is not directional: "There is a relationship between social class and whether you like popcorn." A directional hypothesis could be: "People from the working class eat more popcorn than people from the middle class."

You can advantageously use a figure or other graphical presentation to illustrate your hypotheses.

**Analysis/Presentation of Results**

Operationalization: Describe how you interpret/understand and, if relevant, recode your variables, as well as what theoretical and practical circumstances motivate your choices. The reader should be able to follow your decisions from "raw data" to fully coded "analysis data." If you (re)code complex variables, e.g., social classes based on e.g., job titles or ISCO codes, you must describe all "intermediate calculations" (e.g., how you handle the self-employed, middle managers, and possibly people outside the labor market). And remember to give your variables easy-to-understand names (i.e., not something like "kl_z005").

The analysis of the empirical results should, as a starting point, always be unfolded in the section where you present the results. You should not divide the analysis into a descriptive part ("Table 1 shows number x and number y") and an interpretive part ("I interpret the results in section z below"). Keep the analysis together in one section.

**Tables and Figures**

You can advantageously collect important information in your tables so that you do not have to use more tables or more space than is absolutely necessary in the text to report intermediate calculations and test statistics (upside = more space for analysis and interpretation). Examples are the regression tables that we discussed every week in lectures. Remember to not put too much focus on "goodness of fit" statistics like R2; the primary way in which you test your hypotheses is by interpreting regression coefficients (and their standard errors).

Instead of a regression table, you can also present your results as a coefficient plot (see Stats II lesson 6). If you decide to use a coefficient plot, be sure to include information about N (the number of observations) and the R2 value for the entire table (three decimal places) in a note to the plot.

You should also include two tables with descriptive statistics in your data and method section. Such a table should show means and standard deviations for continuous variables and percentages for categorical variables. As a starting point, you do not need to have more than one decimal place on numbers. That is, write 9.4 and not 9.4327654. In regression tables, however, you should have three decimal places! You can create word tables with descriptive statistics based on the datasummary_skim() function (see https://modelsummary.com/vignettes/datasummary.html). The resulting word documents can be opened and edited (you might want to change them a bit to make them nicer to look at).

**Writing/Formatting**

- Give all your variables and variable categories easy-to-understand and logical names. Do not refer to variables and variable categories with abbreviations or implicit R codes. For example, "gthorpe_5" does not make much sense to a reader, but "Goldthorpe's class scheme with five classes" does.

- Do not copy-paste tables/data from R. It rarely becomes neat or easy to read (and there are often [too] many decimal places included).

- All tables/figures must have an easy-to-understand title and must be numbered.

- Avoid footnotes. Everything important must be included in the main text.

- Do not put anything important in appendices. Remember that, as a starting point, the assessors do not read appendices, and everything important must therefore be included in the main text.

- Meta text is important. Meta text means text that summarizes results and links sections together. For example, "In section 1, I showed that people in higher class positions are less likely to eat popcorn than people in lower class positions. In the next section, I will use the abnormally high price of corn oil to explain why this is the case."

- Avoid normative language ("my research shows that capitalism is evil and alienating"). You can be normative in your free time, not in your professional work as a sociological essay writer. You should also not be normative when putting your results into perspective (unless you are explicitly asked to do so).

**Conclusion/Discussion**

Make sure that you answer the problem statement unambiguously and comprehensively. Do this before you embark on a general discussion/perspective. The purpose of your assignment is first and foremost to answer the problem statement that the teacher has posed.

**Grammar and Language**

- Get a reading group partner to check your assignment for spelling and typing errors. You don't spot the errors until right after you have submitted your assignment (this applies to all of us)

- Remember to write compound nouns correctly. In Danish, they are almost always one word. What would you rather have: a "writing desk" or a "writing table"?

- Remember: no comma before the infinitive: "Your old Danish teacher is clearly not able to, to put commas."

- And finally: No one expects perfection. The purpose of an exam assignment is to learn something new and something important. It also doesn't hurt if the writing process is fun. 

# Good luck 😊
