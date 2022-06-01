##################################################################################
# "When are legislators responsive to ethnic minorities?
#  - Testing the role of electoral incentives and candidate selection for mitigating ethnocentric responsiveness"

# This script generates the results and figures included in the appendix
# The script relies on a data file ("APSR_responsive.xlsx") which is not available (please consult the readme file) plus three non-anonymized files for reproducing parts of the analyses
######################################################################################

### Load packages
library(stargazer)
library(coefplot)
library(ggplot2)
library(haven)
library(labelled)
library(plyr)
library(car)
library(tidyr)
library(Rmisc)
library(interplot)
library(openxlsx)
library(plm)
library(lmtest)
library(miceadds)
library(multiwaycov)
library(cjoint)
library(readr)
library(readxl)
library(gridExtra)
#library(dplyr) /load when needed
##################################################

#Load data: 
data_nonanon1 <-read_excel("main_data_1_excel.xls")
data_nonanon2 <-read_excel("main_data_2_excel.xls") 
data_nonanon3 <-read_excel("main_data_2_excel.xls")

#Load (anonymized) data: 
data <- read_excel("APSR_responsive.xlsx", 
                   col_types = c("numeric", "text", "numeric", 
                                 "text", "text", "numeric", "numeric", 
                                 "numeric", "text", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", "numeric", "numeric", 
                                 "numeric", "numeric", "numeric", "numeric", "text", 
                                 "text", "text", "text"), na = "NA")

##################################################
## Appendix A: Overview of data sources
##################################################
#Descriptive stats:
#rename main data
df<-data_nonanon1
mean(df$response)
sd(df$response)
mean(df$T_etni)
sd(df$T_etni)
mean(df$T_info)
sd(df$T_info)
mean(df$T_gender)
sd(df$T_gender)
mean(df$Minority_pol)
sd(df$Minority_pol)
mean(df$female_pol)
sd(df$female_pol)

#rename data
df3<-data_nonanon3
prop.table(table(df3$party))

#rename data
df_maj<-data_nonanon2

mean(df_maj$run)
sd(df_maj$run)
mean(df_maj$closeness_2013_dum,na.rm=TRUE)
sd(df_maj$closeness_2013_dum,na.rm=TRUE)

### Answers to questions in candidate test (non-anon data)
#Data for clear winners
df_maj_clear <- df_maj
df_maj_clear$clearwin <- ifelse(df_maj$"closeness_2013"==1,"1","0")
df_maj_clear$clearwin <- as.numeric(df_maj_clear$clearwin)

#remove all candidates not included in experiment
df_new<-df
df_new <- df_new[!is.na(df_new$ID_experiment),]

# Subset to only majority candidates
df_new <-subset(df_new, Minority_pol==0)
df_new2 <- df_new
df_new2$Q9_re <- recode(df_new2$Q9, "5=1;4=2;3=3;2=4;1=5")

# sum questions in index variable
df_new2$index <- (df_new2$Q8+df_new2$Q9_re)

#Recode index var.
df_new2$index_re <- recode(df_new2$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")
df_new2 <- df_new2[!is.na(df_new2$index_re),]

#Descriptive stats
mean(df_new2$index_re, na.rm=TRUE)
sd(df_new2$index_re, na.rm=TRUE)

### Other Qs
#Few missing values are coded as 0 (candidates who didn't answer a specfic question). Change to NA
df_new2$Q1[df_new2$Q1 == 0] <- NA
df_new2$Q4[df_new2$Q4 == 0] <- NA
df_new2$Q5[df_new2$Q5 == 0] <- NA
df_new2$Q7[df_new2$Q7 == 0] <- NA
df_new2$Q11[df_new2$Q11 == 0] <- NA
df_new2$Q12[df_new2$Q12 == 0] <- NA
df_new2$Q13[df_new2$Q13 == 0] <- NA
df_new2$Q14[df_new2$Q14 == 0] <- NA

#Descriptive stats for remaining Qs
df_new<-df_new2
mean(df_new$Q1, na.rm=TRUE)
sd(df_new$Q1, na.rm=TRUE)
mean(df_new$Q2, na.rm=TRUE)
sd(df_new$Q2, na.rm=TRUE)
mean(df_new$Q3, na.rm=TRUE)
sd(df_new$Q3, na.rm=TRUE)
mean(df_new$Q4, na.rm=TRUE)
sd(df_new$Q4, na.rm=TRUE)
mean(df_new$Q5, na.rm=TRUE)
sd(df_new$Q5, na.rm=TRUE)
mean(df_new$Q6, na.rm=TRUE)
sd(df_new$Q6, na.rm=TRUE)
mean(df_new$Q7, na.rm=TRUE)
sd(df_new$Q7, na.rm=TRUE)
mean(df_new$Q8, na.rm=TRUE)
sd(df_new$Q8, na.rm=TRUE)
mean(df_new$Q9, na.rm=TRUE)
sd(df_new$Q9, na.rm=TRUE)
mean(df_new$Q10, na.rm=TRUE)
sd(df_new$Q10, na.rm=TRUE)
mean(df_new$Q11, na.rm=TRUE)
sd(df_new$Q11, na.rm=TRUE)
mean(df_new$Q12, na.rm=TRUE)
sd(df_new$Q12, na.rm=TRUE)
mean(df_new$Q13, na.rm=TRUE)
sd(df_new$Q13, na.rm=TRUE)
mean(df_new$Q14, na.rm=TRUE)
sd(df_new$Q14, na.rm=TRUE)
mean(df_new$Q15, na.rm=TRUE)
sd(df_new$Q15, na.rm=TRUE)

#Open list for rerunners
df_maj_open <- subset(df_maj, run==1)
mean(df_maj_open$openlist, na.rm=TRUE)
sd(df_maj_open$openlist, na.rm=TRUE)

#Controls
mean(df$inhabi_number)
sd(df$inhabi_number)
mean(df$mino_number)
sd(df$mino_number)
mean(df$descend_number)
sd(df$descend_number)
mean(df$Mino_share)
sd(df$Mino_share)
mean(df$female_pol)
sd(df$female_pol)

#Content
content <- data_nonanon1
#rename 'no answer' to zero
content$answer_Q[is.na(content$answer_Q)] <- 0
content$"answer+link_or_number"[is.na(content$"answer+link_or_number")] <- 0
content$Length[is.na(content$Length)] <- 0
content$greeting_name[is.na(content$greeting_name)] <- 0
content$follow_up[is.na(content$follow_up)] <- 0
content$sign_off[is.na(content$sign_off)] <- 0
content$"Remember_vote/vote_bymail_now"[is.na(content$"Remember_vote/vote_bymail_now")] <- 0

#mean and sd for each variable respectively
mean(content$greeting_name)
sd(content$greeting_name)
mean(content$follow_up)
sd(content$follow_up)
mean(content$answer_Q)
sd(content$answer_Q)
mean(content$sign_off)
sd(content$sign_off)
sd(content$Length)
mean(content$"answer+link_or_number")
sd(content$"answer+link_or_number")
mean(content$"Remember_vote/vote_bymail_now")
sd(content$"Remember_vote/vote_bymail_now")

#rename main data
content <- data 
content$Length[is.na(content$Length)] <- 0
mean(content$Length)

#Dichotomize 2017-variable
df_maj_open$closeness_2017 <- ifelse(df_maj_open$"closeness_2017"==1,1,0)
mean(df_maj_open$closeness_2017)
sd(df_maj_open$closeness_2017)


##################################################
#Appendix B -- Aliases
##################################################

#rename main data
dfa<-data_nonanon1

#Minority treatments
df_new <-subset(dfa, T_etni==1)
name <- lm(response~ 0+Treat_name, df_new)
summary(name)

#F-test
name <- lm(response~ Treat_name, df_new)
summary(name)

#Majority treats
df_new <-subset(dfa, T_etni==0)
name <- lm(response~ 0+Treat_name, df_new)
summary(name)

#test
name <- lm(response~ Treat_name, df_new)
summary(name)


##################################################
#Appendix C. Response time
##################################################

#rename main data (load data as csv to get right format for time)
dfb <- data

#In days
df_new<-difftime(dfb$t2,dfb$t1, units = "days")
df_new <- data.frame(df_new)
df_new$days <- df_new$df_new
df_new <- df_new[!is.na(df_new$days),]
df_new$days <- as.numeric(df_new$days)

#recode answers past 10 days to 11
df_new$days[df_new$days>10] = 11

#Histogram
hist1<-ggplot(df_new, aes(x=days))+
    labs(title="Response time",x="Days")+
  theme_classic()+
  geom_histogram(color="black", fill="grey40", bins=10)+
  theme(plot.title = element_text(hjust = 0.5))
hist1

#ggsave(filename="App_B.png", plot=hist1, dpi=300)

##################################################
## Appendix D: Quality measures
##################################################

#rename main data
content <- data_nonanon1

#rename 'no answer' to zero
content$answer_Q[is.na(content$answer_Q)] <- 0
content$"answer+link_or_number"[is.na(content$"answer+link_or_number")] <- 0
content$greeting_name[is.na(content$greeting_name)] <- 0
content$follow_up[is.na(content$follow_up)] <- 0
content$sign_off[is.na(content$sign_off)] <- 0
content$"Remember_vote/vote_bymail_now"[is.na(content$"Remember_vote/vote_bymail_now")] <- 0

##Rename variables
content$remember <- content$"Remember_vote/vote_bymail_now"

#add link or phone number
content$link <- content$"answer+link_or_number"

#Rename frame
df_new <- content

##Plot small multiples
df_new$T_etni <- factor(df_new$T_etni)
levels(df_new$T_etni)

#Invi. to follow up
plotadd <- summarySE(df_new,"follow_up",groupvars=c("T_etni"),na.rm=TRUE)
plotadd
plotadd$T_etni <- c("Majority", "Minority")
 
fu<-ggplot(plotadd, aes(x=T_etni, y=follow_up)) + 
  theme_bw() +
  scale_y_continuous(breaks = seq(0, .4, by = 0.1), limits=c(0, .3)) +
  geom_errorbar(aes(ymin=follow_up-se, ymax=follow_up+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Follow up")

#Answer
plotadd <- summarySE(df_new,"answer_Q",groupvars=c("T_etni"),na.rm=TRUE)
plotadd
plotadd$T_etni <- c("Majority", "Minority")
 
a<-ggplot(plotadd, aes(x=T_etni, y=answer_Q)) + 
  theme_bw() +
  scale_y_continuous(breaks = seq(0, .8, by = 0.1), limits=c(.4, .8)) +
  geom_errorbar(aes(ymin=answer_Q-se, ymax=answer_Q+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Answer question")

#greeting_name
plotadd <- summarySE(df_new,"greeting_name",groupvars=c("T_etni"),na.rm=TRUE)
plotadd
plotadd$T_etni <- c("Majority", "Minority")
 
g<-ggplot(plotadd, aes(x=T_etni, y=greeting_name)) + 
  theme_bw() +
  geom_errorbar(aes(ymin=greeting_name-se, ymax=greeting_name+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Name greeting")

#Sign off
plotadd <- summarySE(df_new,"sign_off",groupvars=c("T_etni"),na.rm=TRUE)
plotadd
plotadd$T_etni <- c("Majority", "Minority")
 
s<-ggplot(plotadd, aes(x=T_etni, y=sign_off)) + 
  theme_bw() +
  geom_errorbar(aes(ymin=sign_off-se, ymax=sign_off+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Sign off")

#Remember to vote
plotadd <- summarySE(df_new,"remember",groupvars=c("T_etni"),na.rm=TRUE)
plotadd
plotadd$T_etni <- c("Majority", "Minority")
# 
r<-ggplot(plotadd, aes(x=T_etni, y=remember)) + 
  theme_bw() +
  scale_y_continuous(breaks = seq(0, .4, by = 0.1), limits=c(0, .3)) +
  geom_errorbar(aes(ymin=remember-se, ymax=remember+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Remember vote")

#Link
plotadd <- summarySE(df_new,"link",groupvars=c("T_etni"),na.rm=TRUE)
plotadd
plotadd$T_etni <- c("Majority", "Minority")
# 
li<-ggplot(plotadd, aes(x=T_etni, y=link)) + 
  theme_bw() +
  scale_y_continuous(breaks = seq(0, .4, by = 0.1), limits=c(0, .3)) +
  geom_errorbar(aes(ymin=link-se, ymax=link+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Include link")

#Length (This requires non-anonomized data)
content <- data
content$Length[is.na(content$Length)] <- 0 
plotadd <- summarySE(df_new,"Length",groupvars=c("T_etni"),na.rm=TRUE) 
plotadd
plotadd$T_etni <- c("Majority", "Minority")

#Plot 
l<-ggplot(plotadd, aes(x=T_etni, y=Length)) + 
  theme_bw() +
  geom_errorbar(aes(ymin=Length-se, ymax=Length+se), width=.1) +
  geom_point() +
  theme(panel.border = element_blank()) +
  theme(axis.line = element_line(color = 'black')) +
  ylab("") +
  xlab("") +
  ggtitle("Word count")

#This requires non-anonomized data
plot_ap3<-grid.arrange(l,fu,a,g,s,r,li,
                 nrow = 3,
                 top = "")
plot_ap3
#ggsave(filename="App_C.png", plot=plot_ap3, dpi=300)

##################################################
## Appendix F - Distribution of immigration/integration policy measure
##################################################

#rename main data
dff<- data

#Recode Q9 since Q9 is reversed relative to Q8
dff$Q9_re <- recode(dff$Q9, "5=1;4=2;3=3;2=4;1=5")

# sum questions in index variable
dff$index <- (dff$Q8+dff$Q9_re)

#Recode index var.
dff$index_re <- recode(dff$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")

# remove all candidates with no answer in the index
df_new <- dff[!is.na(dff$index_re),]

# Subset to only majority candidates
df_new <-subset(df_new, Minority_pol==0)

#F.1
histF1<-ggplot(df_new, aes(x=index_re)) +
  labs(title="",x="Least restrictive                                      -                                      Most restrictive")+
  theme_classic()+
  geom_histogram(color="black", fill="grey40", bins=9)+
  theme(plot.title = element_text(hjust = 0.45))
histF1
#ggsave(filename="App_F1.png", plot=histF1, dpi=300)


#F.2
histF2<-ggplot(df_new, aes(x=Q8)) +
  labs(title="Question 1: Welcome more refugees",x="")+
  theme_classic()+
  geom_histogram(color="black", fill="grey40", bins=5)+
  theme(plot.title = element_text(hjust = 0.5))
histF2
#ggsave(filename="App_F2.png", plot=histF2, dpi=300)


#F.3
histF3<-ggplot(df_new, aes(x=Q9_re)) +
  labs(title="Question 2: Accommodate religious minorities",x="")+
  theme_classic()+
  geom_histogram(color="black", fill="grey40", bins=5)+
  theme(plot.title = element_text(hjust = 0.5))
histF3
#ggsave(filename="App_F3.png", plot=histF3, dpi=300)


############################################################################
## Appendix G: Comparison of samples
############################################################################

#rename main data
dfg <- data

#Recode Q9 since Q9 is reversed relative to Q8
dfg$Q9_re <- recode(dfg$Q9, "5=1;4=2;3=3;2=4;1=5")

# sum questions in index variable
dfg$index <- (dfg$Q8+dfg$Q9_re)

#Recode index var.
dfg$index_re <- recode(dfg$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")

# remove all candidates with no answer in the index
df_new <- dfg[!is.na(dfg$index_re),]

#Only majorities
df_new <- subset(df_new, Minority_pol==0)

#Coloumn 1
#summary statistics.
mean(dfg$female_pol)
sd(dfg$female_pol)

#Inhabitants
mean(dfg$inhabi_number)
sd(dfg$inhabi_number)

#Minority #
mean(dfg$mino_number)
sd(dfg$mino_number)

#Descendants
mean(dfg$descend_number)
sd(dfg$descend_number)

## Coloumn 2: Summary stat for majority sample
df_maj <- subset(dfg, Minority_pol==0)

#Summary statistics for same variables.
mean(df_maj$female_pol)
sd(df_maj$female_pol)
mean(df_maj$inhabi_number)
sd(df_maj$inhabi_number)
mean(df_maj$mino_number)
sd(df_maj$mino_number)
mean(df_maj$descend_number)
sd(df_maj$descend_number)

##Coloumn 3
##Summary statistics for same variables
mean(df_new$female_pol)
sd(df_new$female_pol)
mean(df_new$inhabi_number)
sd(df_new$inhabi_number)
mean(df_new$mino_number)
sd(df_new$mino_number)
mean(df_new$descend_number)
sd(df_new$descend_number)


##################################################
## Appendix H: Effect of the gender cue 
##################################################

#rename main data
dfh <- data_nonanon1

#Run models
gender <- lm(response ~ T_gender, dfh)
summary(gender)

#rename main data (This requires non-anon. data)
dfh <- data
#2
gender <- lm(response ~ T_gender + female_pol, dfh)
summary(gender)

#3
gender <- lm(response ~ T_gender+female_pol+T_gender*female_pol, dfh)
summary(gender)

##############################################################
## Appendix I -- are the treatments perceived as realistic
##############################################################

#rename main data
dfi<-data

#Exclude parties
dfi$party[dfi$party=="DF"] <- NA
dfi<-dfi[!is.na(dfi$party),]

dfi$party[dfi$party=="Nye Borgerlige"] <- NA
dfi<-dfi[!is.na(dfi$party),]

dfi$party[dfi$party=="Liberal Alliance"] <- NA
dfi<-dfi[!is.na(dfi$party),]

#Run model 1
fit <- lm(response~T_etni, dfi)
summary(fit)

#Only majority
dfi2 <-subset(dfi, Minority_pol==0)

fit2 <- lm(response~T_etni+T_info+T_etni*T_info, dfi2)
summary(fit2)

##################################################
### APPENDIX J - ATE across municipality size
##################################################

#rename main data
dfj<-data

#List after size
sort <- factor(dfj$muni, levels=unique(dfj$muni[order(dfj$inhabi_number)]), ordered=TRUE)
list <- levels(sort)

#smallest 7
df_7 <- 
 dfj %>%
  filter(muni=="Læsø" | muni=="Fanø" | muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk")

# 14 smallest muni
df_14 <- 
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø" | muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"| muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj")

# 28
df_28 <- 
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø"| muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"|
           muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj"
         | muni=="Glostrup"| muni=="Kerteminde"| muni=="Allerød"| muni=="Hørsholm"| muni=="Billund"| muni=="Lejre"| muni=="Albertslund"
         | muni=="Herlev"| muni=="Rebild"| muni=="Nordfyns"| muni=="Sorø"| muni=="Halsnæs"| muni=="Nyborg"| muni=="Odsherred")

# 42
df_42 <-
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø"| muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"| muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj"
         | muni=="Glostrup"| muni=="Kerteminde"| muni=="Allerød"| muni=="Hørsholm"| muni=="Billund"| muni=="Lejre"| muni=="Albertslund"
         | muni=="Herlev"| muni=="Rebild"| muni=="Nordfyns"| muni=="Sorø"| muni=="Halsnæs"| muni=="Nyborg"| muni=="Odsherred"
         | muni=="Ringsted"| muni=="Brøndby"| muni=="Faxe"| muni=="Brønderslev"| muni=="Vesthimmerlands"| muni=="Tønder"| muni=="Middelfart"
         | muni=="Rødovre"| muni=="Norddjurs"| muni=="Jammerbugt"| muni=="Bornholm"| muni=="Fredensborg"| muni=="Furesø"| muni=="Ikast-Brande")

#46
df_56 <-
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø"| muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"| muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj"
         | muni=="Glostrup"| muni=="Kerteminde"| muni=="Allerød"| muni=="Hørsholm"| muni=="Billund"| muni=="Lejre"| muni=="Albertslund"
         | muni=="Herlev"| muni=="Rebild"| muni=="Nordfyns"| muni=="Sorø"| muni=="Halsnæs"| muni=="Nyborg"| muni=="Odsherred"
         | muni=="Ringsted"| muni=="Brøndby"| muni=="Faxe"| muni=="Brønderslev"| muni=="Vesthimmerlands"| muni=="Tønder"| muni=="Middelfart"
         | muni=="Rødovre"| muni=="Norddjurs"| muni=="Jammerbugt"| muni=="Bornholm"| muni=="Fredensborg"| muni=="Furesø"| muni=="Ikast-Brande"|
           muni=="Gribskov"| muni=="Assens"
         | muni=="Syddjurs"| muni=="Mariagerfjord"| muni=="Lolland"| muni=="Egedal"| muni=="Tårnby"| muni=="Vejen"| muni=="Thisted"
         | muni=="Frederikssund"| muni=="Vordingborg"| muni=="Hedensted"| muni=="Skive"| muni=="Favrskov")

#70
df_70 <-
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø"| muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"| muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj"
         | muni=="Glostrup"| muni=="Kerteminde"| muni=="Allerød"| muni=="Hørsholm"| muni=="Billund"| muni=="Lejre"| muni=="Albertslund"
         | muni=="Herlev"| muni=="Rebild"| muni=="Nordfyns"| muni=="Sorø"| muni=="Halsnæs"| muni=="Nyborg"| muni=="Odsherred"
         | muni=="Ringsted"| muni=="Brøndby"| muni=="Faxe"| muni=="Brønderslev"| muni=="Vesthimmerlands"| muni=="Tønder"| muni=="Middelfart"
         | muni=="Rødovre"| muni=="Norddjurs"| muni=="Jammerbugt"| muni=="Bornholm"| muni=="Fredensborg"| muni=="Furesø"| muni=="Ikast-Brande"| muni=="Gribskov"| muni=="Assens"
         | muni=="Syddjurs"| muni=="Mariagerfjord"| muni=="Lolland"| muni=="Egedal"| muni=="Tårnby"| muni=="Vejen"| muni=="Thisted"
         | muni=="Frederikssund"| muni=="Vordingborg"| muni=="Hedensted"| muni=="Skive"| muni=="Favrskov"| muni=="Ballerup"| muni=="Kalundborg"
         | muni=="Greve"| muni=="Hillerød"| muni=="Høje-Taastrup"| muni=="Varde"| muni=="Fredericia"| muni=="Faaborg-Midtfyn"| muni=="Hvidovre"
         | muni=="Lyngby-Taarbæk"| muni=="Rudersdal"| muni=="Haderslev"| muni=="Ringkøbing-Skjern"| muni=="Holstebro")

#84
df_84 <-
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø"| muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"| muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj"
         | muni=="Glostrup"| muni=="Kerteminde"| muni=="Allerød"| muni=="Hørsholm"| muni=="Billund"| muni=="Lejre"| muni=="Albertslund"
         | muni=="Herlev"| muni=="Rebild"| muni=="Nordfyns"| muni=="Sorø"| muni=="Halsnæs"| muni=="Nyborg"| muni=="Odsherred"
         | muni=="Ringsted"| muni=="Brøndby"| muni=="Faxe"| muni=="Brønderslev"| muni=="Vesthimmerlands"| muni=="Tønder"| muni=="Middelfart"
         | muni=="Rødovre"| muni=="Norddjurs"| muni=="Jammerbugt"| muni=="Bornholm"| muni=="Fredensborg"| muni=="Furesø"| muni=="Ikast-Brande"| muni=="Gribskov"| muni=="Assens"
         | muni=="Syddjurs"| muni=="Mariagerfjord"| muni=="Lolland"| muni=="Egedal"| muni=="Tårnby"| muni=="Vejen"| muni=="Thisted"
         | muni=="Frederikssund"| muni=="Vordingborg"| muni=="Hedensted"| muni=="Skive"| muni=="Favrskov"| muni=="Ballerup"| muni=="Kalundborg"
         | muni=="Greve"| muni=="Hillerød"| muni=="Høje-Taastrup"| muni=="Varde"| muni=="Fredericia"| muni=="Faaborg-Midtfyn"| muni=="Hvidovre"
         | muni=="Lyngby-Taarbæk"| muni=="Rudersdal"| muni=="Haderslev"| muni=="Ringkøbing-Skjern"| muni=="Holstebro"
         | muni=="Svendborg"| muni=="Aabenraa"| muni=="Skanderbord"| muni=="Køge"| muni=="Frederikshavn"| muni=="Guldborgsund"
         | muni=="Helsingør"| muni=="Hjørring"| muni=="Gladsaxe"| muni=="Holbæk"| muni=="Sønderborg"| muni=="Gentofte"| muni=="Slagelse"
         | muni=="Næstved")

#98
df_98 <-
  dfj %>%
  filter(muni=="Læsø" | muni=="Fanø"| muni=="Samsø"| muni=="Ærø"| muni=="Langeland"| muni=="Dragør"
         | muni=="Vallensbæk"| muni=="Lemvig"| muni=="Morsø"| muni=="Struer"| muni=="Solrød"| muni=="Odder"| muni=="Stevns"| muni=="Ishøj"
         | muni=="Glostrup"| muni=="Kerteminde"| muni=="Allerød"| muni=="Hørsholm"| muni=="Billund"| muni=="Lejre"| muni=="Albertslund"
         | muni=="Herlev"| muni=="Rebild"| muni=="Nordfyns"| muni=="Sorø"| muni=="Halsnæs"| muni=="Nyborg"| muni=="Odsherred"
         | muni=="Ringsted"| muni=="Brøndby"| muni=="Faxe"| muni=="Brønderslev"| muni=="Vesthimmerlands"| muni=="Tønder"| muni=="Middelfart"
         | muni=="Rødovre"| muni=="Norddjurs"| muni=="Jammerbugt"| muni=="Bornholm"| muni=="Fredensborg"| muni=="Furesø"| muni=="Ikast-Brande"| muni=="Gribskov"| muni=="Assens"
         | muni=="Syddjurs"| muni=="Mariagerfjord"| muni=="Lolland"| muni=="Egedal"| muni=="Tårnby"| muni=="Vejen"| muni=="Thisted"
         | muni=="Frederikssund"| muni=="Vordingborg"| muni=="Hedensted"| muni=="Skive"| muni=="Favrskov"| muni=="Ballerup"| muni=="Kalundborg"
         | muni=="Greve"| muni=="Hillerød"| muni=="Høje-Taastrup"| muni=="Varde"| muni=="Fredericia"| muni=="Faaborg-Midtfyn"| muni=="Hvidovre"
         | muni=="Lyngby-Taarbæk"| muni=="Rudersdal"| muni=="Haderslev"| muni=="Ringkøbing-Skjern"| muni=="Holstebro"
         | muni=="Svendborg"| muni=="Aabenraa"| muni=="Skanderborg"| muni=="Køge"| muni=="Frederikshavn"| muni=="Guldborgsund"
         | muni=="Helsingør"| muni=="Hjørring"| muni=="Gladsaxe"| muni=="Holbæk"| muni=="Sønderborg"| muni=="Gentofte"| muni=="Slagelse"
         | muni=="Næstved"| muni=="Roskilde"| muni=="Herning"| muni=="Horsens"| muni=="Silkeborg"| muni=="Kolding"| muni=="Viborg"
         | muni=="Randers"| muni=="Frederiksberg"| muni=="Vejle"| muni=="Esbjerg"| muni=="Odense"| muni=="Aalborg"| muni=="Aarhus"
         | muni=="København")

#Run models
fit7<-lm(response~T_etni,df_7)
summary(fit7)

fit14<-lm(response~T_etni,df_14)
summary(fit14)

fit28<-lm(response~T_etni,df_28)
summary(fit28)

fit42<-lm(response~T_etni,df_42)
summary(fit42)

fit56<-lm(response~T_etni,df_56)
summary(fit56)

fit70<-lm(response~T_etni,df_70)
summary(fit70)

fit84<-lm(response~T_etni,df_84)
summary(fit84)

fit98<-lm(response~T_etni,df_98)
summary(fit98)

#PLOT
label <- paste0(c("7 smallest", "14 smallest", "28 smallest", "42 smallest", "56 smallest", "70 smallest", "84 smallest", "All 98"))
mean  <- c(100*fit7$coef[2], 100*fit14$coef[2],100*fit28$coef[2],100*fit42$coef[2],100*fit56$coef[2],100*fit70$coef[2],100*fit84$coef[2],100*fit98$coef[2]) 
SE <- c((100*summary(fit7)$coef[4]),(100*summary(fit14)$coef[4]),(100*summary(fit28)$coef[4]), (100*summary(fit42)$coef[4]), (100*summary(fit56)$coef[4]), (100*summary(fit70)$coef[4]), (100*summary(fit84)$coef[4]), (100*summary(fit98)$coef[4]))
lower <- mean+(SE*1.96)
upper <- mean-(SE*1.96)

df_1 <- data.frame(label, mean, lower, upper)

#90%
lower <- mean +(SE*1.64)
upper <- mean -(SE*1.64)

df_2 <- data.frame(label, mean, lower, upper)
df_1$label <- factor(df_1$label, levels=c("7 smallest", "14 smallest", "28 smallest", "42 smallest", "56 smallest", "70 smallest", "84 smallest", "All 98"))

#Plot
fp <- ggplot(data=df_1, aes(x=label, y=mean, ymin=lower, ymax=upper)) +
  geom_point(size=4) +
  geom_errorbar(data=df_1, color="grey67", width=.07) +
  geom_hline(yintercept=0, lty=2, color = "grey40") +  
  coord_flip() +
  scale_y_continuous(breaks = seq(-40, 5, by = 5), limits=c(-40, 5)) +
  labs(y="Percentage points", x=NULL) + theme(axis.text=element_text(size=10)) +
  theme_bw() + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank() + # panel.grid.major.y = element_blank()) +
                       theme(panel.border = element_blank()))

#90%-errorbar
fp <- fp + geom_errorbar(data=df_2, aes(x=label, y=mean, ymin=lower, ymax=upper, width=0.07), color="black") + ggtitle("") + theme(plot.title=element_text(family="Times", face="bold", size=9))

print(fp)
fp <- fp + theme_classic()

a <- fp
j1 <- a + geom_abline(intercept = -16.2, slope = 0, color="grey", 
                     linetype="dashed", size=.5)
j1
#ggsave(filename="App_J1.png", plot=j1, dpi=300)


##################################################
### APPENDIX K - Electoral incentives and responsiveness
##################################################

#rename main data
dfk<-data

#factor
dfk$T_etni <-as.factor(dfk$T_etni)

#Majority politician subset only
df_maj <-subset(dfk, Minority_pol==0)

#only re-runners
df_maj$run<-factor(df_maj$run)

### Coloumn 1
#Run regression (Majority only)
fitk1 <- lm(response ~ T_etni + run + party + inhabi_number + Mino_share, df_maj)

fitk2 <- lm(response ~ T_etni + run + T_etni * run + party + inhabi_number + Mino_share, df_maj)

df_maj_clear <- df_maj
df_maj_clear$clearwin <- ifelse(df_maj$"closeness_2013"==1,"1","0")

#coloumn 3
fitk3 <- lm(response ~ T_etni + clearwin + party + inhabi_number + Mino_share, df_maj_clear)

#coloumn 4
fitk4 <- lm(response ~ T_etni + clearwin + T_etni * clearwin + party + inhabi_number + Mino_share, df_maj_clear)

stargazer(fitk1, fitk2, fitk3, fitk4, title ="", 
          align=TRUE, dep.var.labels=c("Response (0/1)"),
          omit.stat=c("LL","ser","f"),
          no.space=TRUE,
          star.char = c("*", "**", "***"),
          star.cutoffs = c(.05, .01, .001),
          out ="../Table_Appendix_K.html")


##################################################
### APPENDIX L - Further analyses og interactions between Voting cue and Minority Alias
##################################################

#rename main data
dfl<-data

#Majority politician subset only
df_maj <-subset(dfl, Minority_pol==0)

#Coloumn 1 (se code below coloumn 4)

# Coloumn 2
#Run regression (Majority only)
fit2 <- lm(response ~ T_etni + T_info + T_etni*T_info + party + inhabi_number + Mino_share, df_maj)
summary(fit2)

### Coloumn 3
#Recode
df_maj$run <-as.factor(df_maj$run)
levels(df_maj$run) <- c("no", "yes")

#subset to only rerunners
df_newrun <-subset(df_maj, run=="yes")

#with controls
fit3 <- lm(response ~ T_etni + T_info + T_etni*T_info+ party + inhabi_number + Mino_share, df_newrun)
summary(fit3)

###  Coloumn 4
#drop candidates that always win in the 2013 election (clear winners)
df_2013_without1 <- 
  df_newrun %>%
  filter(closeness_2013 < 1)

#regression with close election subset 2013
fit4 <- lm(response ~ T_etni + T_info + T_etni*T_info + party + inhabi_number + Mino_share, df_2013_without1)
summary(fit4)

## Coloumn 1
#drop candidates that always win in the 2013 election (clear winners)
df_2013_without1_open <- subset(df_2013_without1, openlist==1)

#regression with close election subset 2013 (note: without controls)
fit1 <- lm(response ~ T_etni + T_info + T_etni*T_info, df_2013_without1_open)
summary(fit1)

#Coloumn 5
#Same procedure for 2017 election data
df_2017_without1 <- 
  df_newrun %>%
  filter(closeness_2017 < 1)

fit5 <- lm(response ~ T_etni + T_info + T_etni*T_info  + party + inhabi_number + Mino_share, df_2017_without1)
summary(fit5)


stargazer(fit1, fit2, fit3, fit4, fit5, title ="", 
          align=TRUE, dep.var.labels=c("Response (0/1)"),
          omit.stat=c("LL","ser","f"),
          no.space=TRUE,
          star.char = c("*", "**", "***"),
          star.cutoffs = c(.05, .01, .001),
          out ="S../Table_Appendix_L.html")

##################################################
## Appendix M: Comparison of ethnocentric responsiveness/majority favoritism between parties
##################################################

#rename main data
dfm<-data_nonanon3

#majorities only
df_maj <-dfm

#Subset
df_df <- subset(df_maj, party=="DF")
df_la <- subset(df_maj, party=="Liberal Alliance")
df_venstre <- subset(df_maj, party=="Venstre")
df_kons <- subset(df_maj, party=="Det Konservative Folkeparti")
df_sos <- subset(df_maj, party=="Socialdemokratiet")
df_rv <- subset(df_maj, party=="Radikale Venstre")
df_sf <- subset(df_maj, party=="SF")
df_Ø <- subset(df_maj, party=="Enhedslisten")

#Combine and compare
df_dfla <- rbind(df_df,df_la)
df_dfla <- lm(response ~ T_etni+party+T_etni*party, data=df_dfla)
summary(df_dfla)

df_dfv <- rbind(df_df,df_venstre)
df_dfv <- lm(response ~ T_etni+party+T_etni*party, data=df_dfv)
summary(df_dfv)

df_dfc <- rbind(df_df,df_kons)
df_dfc <- lm(response ~ T_etni+party+T_etni*party, data=df_dfc)
summary(df_dfc)

df_dfa <- rbind(df_df,df_sos)
df_dfa <- lm(response ~ T_etni+party+T_etni*party, data=df_dfa)
summary(df_dfa)

df_dfr <- rbind(df_df,df_rv)
df_dfr <- lm(response ~ T_etni+party+T_etni*party, data=df_dfr)
summary(df_dfr)

#sf
df_dfsf <- rbind(df_df,df_sf)
df_dfsf <- lm(response ~ T_etni+party+T_etni*party, data=df_dfsf)
summary(df_dfsf)

#oe
df_dfoe <- rbind(df_df,df_Ø)
df_dfoe <- lm(response ~ T_etni+party+T_etni*party, data=df_dfoe)
summary(df_dfoe)

### LA vs. others
df_lav <- rbind(df_la,df_venstre)
df_lav <- lm(response ~ T_etni+party+T_etni*party, data=df_lav)
summary(df_lav)

df_lac <- rbind(df_la,df_kons)
df_lac <- lm(response ~ T_etni+party+T_etni*party, data=df_lac)
summary(df_lac)

df_las <- rbind(df_la,df_sos)
df_las <- lm(response ~ T_etni+party+T_etni*party, data=df_las)
summary(df_las)

df_larv <- rbind(df_la,df_rv)
df_larv <- lm(response ~ T_etni+party+T_etni*party, data=df_larv)
summary(df_larv)

df_lasf <- rbind(df_la,df_sf)
df_lasf <- lm(response ~ T_etni+party+T_etni*party, data=df_lasf)
summary(df_lasf)

df_lao <- rbind(df_la,df_Ø)
df_lao <- lm(response ~ T_etni+party+T_etni*party, data=df_lao)
summary(df_lao)

##Venstre vs. other parties
df_v <- rbind(df_venstre,df_kons)
df_v <- lm(response ~ T_etni+party+T_etni*party, data=df_v)
summary(df_v)

df_va <- rbind(df_venstre,df_sos)
df_va <- lm(response ~ T_etni+party+T_etni*party, data=df_va)
summary(df_va)

df_vr <- rbind(df_venstre,df_rv)
df_vr <- lm(response ~ T_etni+party+T_etni*party, data=df_vr)
summary(df_vr)

df_vsf <- rbind(df_venstre,df_sf)
df_vsf <- lm(response ~ T_etni+party+T_etni*party, data=df_vsf)
summary(df_vsf)

df_voe <- rbind(df_venstre,df_Ø)
df_voe <- lm(response ~ T_etni+party+T_etni*party, data=df_voe)
summary(df_voe)

## Conservatives vs. rest
df_ca <- rbind(df_kons,df_sos)
df_ca <- lm(response ~ T_etni+party+T_etni*party, data=df_ca)
summary(df_ca)

df_crv <- rbind(df_kons,df_rv)
df_crv <- lm(response ~ T_etni+party+T_etni*party, data=df_crv)
summary(df_crv)

df_csf <- rbind(df_kons,df_sf)
df_csf <- lm(response ~ T_etni+party+T_etni*party, data=df_csf)
summary(df_csf)

df_coe <- rbind(df_kons,df_Ø)
df_coe <- lm(response ~ T_etni+party+T_etni*party, data=df_coe)
summary(df_coe)

## S vs. rest
df_arv <- rbind(df_sos,df_rv)
df_arv <- lm(response ~ T_etni+party+T_etni*party, data=df_arv)
summary(df_arv)

df_asf <- rbind(df_sos,df_sf)
df_asf <- lm(response ~ T_etni+party+T_etni*party, data=df_asf)
summary(df_asf)

df_aoe <- rbind(df_sos,df_Ø)
df_aoe <- lm(response ~ T_etni+party+T_etni*party, data=df_aoe)
summary(df_aoe)

#RV
df_rvsf <- rbind(df_rv,df_sf)
df_rvsf <- lm(response ~ T_etni+party+T_etni*party, data=df_rvsf)
summary(df_rvsf)

df_rvoe <- rbind(df_rv,df_Ø)
df_rvoe <- lm(response ~ T_etni+party+T_etni*party, data=df_rvoe)
summary(df_rvoe)

#SF
df_sfoe <- rbind(df_sf,df_Ø)
df_sfoe <- lm(response ~ T_etni+party+T_etni*party, data=df_sfoe)
summary(df_sfoe)

##################################################
## Appendix N: ATE across parties including controls
##################################################

#rename main data 
dfn<- data

#subset
df_maj <- subset(dfn, Minority_pol==0)

###models across parties
#df
df_df <- subset(df_maj, party=="DF")
dfs <- lm(response ~ T_etni, data=df_df)
dfs2 <- lm(response ~ T_etni + Mino_share+inhabi_number, data=df_df)

#LA
df_la <- subset(df_maj, party=="Liberal Alliance")
la <- lm(response ~ T_etni, data=df_la)
la2 <- lm(response ~ T_etni+Mino_share+inhabi_number, data=df_la)

#Venstre
df_venstre <- subset(df_maj, party=="Venstre")
venstre <- lm(response ~ T_etni, data=df_venstre)
venstre2 <- lm(response ~ T_etni+Mino_share+inhabi_number, data=df_venstre)

#Kons
df_kons <- subset(df_maj, party=="Det Konservative Folkeparti")
cons <- lm(response ~ T_etni, data=df_kons)
cons2 <- lm(response ~ T_etni+T_etni+Mino_share+inhabi_number, data=df_kons)

#Socialdem.
df_sos <- subset(df_maj, party=="Socialdemokratiet")
sos <- lm(response ~ T_etni, data=df_sos)
sos2 <- lm(response ~ T_etni+Mino_share+inhabi_number, data=df_sos)

#Rad.V.
df_rv <- subset(df_maj, party=="Radikale Venstre")
rv <- lm(response ~ T_etni, data=df_rv)
rv2 <- lm(response ~ T_etni+Mino_share+inhabi_number, data=df_rv)

#SF
df_sf <- subset(df_maj, party=="SF")
sf <- lm(response ~ T_etni, data=df_sf)
sf2 <- lm(response ~ T_etni+Mino_share+inhabi_number, data=df_sf)

#Ø
df_Ø <- subset(df_maj, party=="Enhedslisten")
oe <- lm(response ~ T_etni, data=df_Ø)
oe2 <- lm(response ~ T_etni+Mino_share+inhabi_number, data=df_Ø)

mean  <- c(dfs$coef[2]*100, la$coef[2]*100,venstre$coef[2]*100,cons$coef[2]*100
           ,sos$coef[2]*100,rv$coef[2]*100,sf$coef[2]*100,oe$coef[2]*100,
           
           dfs2$coef[2]*100, la2$coef[2]*100,venstre2$coef[2]*100,cons2$coef[2]*100
           ,sos2$coef[2]*100,rv2$coef[2]*100,sf2$coef[2]*100,oe2$coef[2]*100
) 

SE <- c((summary(dfs)$coef[4]*100),
        (summary(la)$coef[4]*100),
        (summary(venstre)$coef[4]*100),
        (summary(cons)$coef[4]*100),
        (summary(sos)$coef[4]*100),
        (summary(rv)$coef[4]*100),
        (summary(sf)$coef[4]*100),
        (summary(oe)$coef[4]*100),
        
        (summary(dfs2)$coef[2,2]*100),
        (summary(la2)$coef[2,2]*100),
        (summary(venstre2)$coef[2,2]*100),
        (summary(cons2)$coef[2,2]*100),
        (summary(sos2)$coef[2,2]*100),
        (summary(rv2)$coef[2,2]*100),
        (summary(sf2)$coef[2,2]*100),
        (summary(oe2)$coef[2,2]*100)
)


#95%
label <- paste0(c("DF", "LA", "V", "K", "S", "RV", "SF", "E", "DF", "LA", "V", "K", "S", "RV", "SF", "E"))
Controls <- paste0(c("-", "-", "-", "-", "-", "-", "-", "-", "+", "+", "+", "+", "+", "+", "+", "+"))
lower <- mean+(SE*1.96)
upper <- mean-(SE*1.96)

df_1 <- data.frame(label, mean, lower, upper)

#90%
lower <- mean +(SE*1.64)
upper <- mean -(SE*1.64)

df_2 <- data.frame(label, mean, lower, upper)

df_1$label <- factor(df_1$label, levels=c("DF", "LA", "V", "K", "S", "RV", "SF", "E"))

fp <- ggplot(data=df_1, aes(x=label, y=mean, ymin=lower, ymax=upper, col=Controls)) +
  geom_point(size=3.5, position=position_dodge(width=0.22))+
  geom_errorbar(data=df_1, aes(ymin=lower, ymax=upper),position=position_dodge(width=0.22), width=0.1, size=.6) +
  geom_errorbar(data=df_2, aes(ymin=lower, ymax=upper),position=position_dodge(width=0.22), width=0.0, size=.9) +
  geom_hline(yintercept=0, lty=2, color = "grey40") +  # add a dotted line at x=1 after flip
  coord_flip() +
  scale_y_continuous(breaks = seq(-70, 30, by = 10), limits=c(-72, 30)) +
  
    labs(y="", x=NULL) + theme(axis.text=element_text(size=10)) +
  theme_bw() + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank() + # panel.grid.major.y = element_blank()) +
                       theme(panel.border = element_blank()))
fp <- fp + theme_classic()
fp

fp <- fp+ theme(axis.title.y = element_blank()) +scale_colour_grey(start = 0, end = .8)

a<-fp +annotate("text",
                x = c(1,2,3,4,5,6,7,8),
                y = c(-72,-72,-72,-72,-72,-72,-72,-72),
                label = c("0.48", "2.70", "3.51", "3.57", "5.35", "6.62", "6.68", "7.49"),
                family = "", fontface = 3, size=4, colour="grey")
a
b <- a + geom_abline(intercept = -66, slope = 0, color="grey", 
                     linetype="dashed", size=.5)
b<-b +    annotate(geom = "text", x = 4.5, y = -67, label = "Immigration policy measure, party averages", color = "grey",
                   angle = -90)
c<-b + ggtitle("") + 
  theme(plot.title = element_text(lineheight=.7, face="bold"))

N<-c + theme(legend.position = c(.27,.9))
N
#ggsave(filename="App_N.png", plot=N, dpi=300)

################
##N2
################
dfn2<-data

#Recode Q9 since Q9 is reversed relative to Q8
dfn2$Q9_re <- recode(dfn2$Q9, "5=1;4=2;3=3;2=4;1=5")

# sum questions in index variable
dfn2$index <- (dfn2$Q8+dfn2$Q9_re)

#Recode index var.
dfn2$index_re <- recode(dfn2$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")

# remove all candidates with no answer in the index
dfn2 <- dfn2[!is.na(dfn2$index_re),]

# Subset to only majority candidates
df_new <-subset(dfn2, Minority_pol==0)

df_df2 <- subset(df_new, party=="DF")
dfs2 <- lm(response ~ T_etni, data=df_df2)

df_la2 <- subset(df_new, party=="Liberal Alliance")
la2 <- lm(response ~ T_etni, data=df_la2)
summary(la2)

df_v2 <- subset(df_new, party=="Venstre")
venstre2 <- lm(response ~ T_etni, data=df_v2)
summary(venstre2)

df_c2 <- subset(df_new, party=="Det Konservative Folkeparti")
cons2 <- lm(response ~ T_etni, data=df_c2)
summary(cons2)

df_sos2 <- subset(df_new, party=="Socialdemokratiet")
sos2 <- lm(response ~ T_etni, data=df_sos2)
summary(sos2)

df_r2 <- subset(df_new, party=="Radikale Venstre")
rv2 <- lm(response ~ T_etni, data=df_r2)
summary(rv2)

df_sf2 <- subset(df_new, party=="SF")
sf2 <- lm(response ~ T_etni, data=df_sf2)
summary(sf2)

df_oe2 <- subset(df_new, party=="Enhedslisten")
oe2 <- lm(response ~ T_etni, data=df_oe2)
summary(oe2)

#Plot (Note: run code for N1 first)
mean  <- c(dfs$coef[2]*100, la$coef[2]*100,venstre$coef[2]*100,cons$coef[2]*100
           ,sos$coef[2]*100,rv$coef[2]*100,sf$coef[2]*100,oe$coef[2]*100,
           
           dfs2$coef[2]*100, la2$coef[2]*100,venstre2$coef[2]*100,cons2$coef[2]*100
           ,sos2$coef[2]*100,rv2$coef[2]*100,sf2$coef[2]*100,oe2$coef[2]*100
) 

SE <- c((summary(dfs)$coef[4]*100),
        (summary(la)$coef[4]*100),
        (summary(venstre)$coef[4]*100),
        (summary(cons)$coef[4]*100),
        (summary(sos)$coef[4]*100),
        (summary(rv)$coef[4]*100),
        (summary(sf)$coef[4]*100),
        (summary(oe)$coef[4]*100),
        
        (summary(dfs2)$coef[4]*100),
        (summary(la2)$coef[4]*100),
        (summary(venstre2)$coef[4]*100),
        (summary(cons2)$coef[4]*100),
        (summary(sos2)$coef[4]*100),
        (summary(rv2)$coef[4]*100),
        (summary(sf2)$coef[4]*100),
        (summary(oe2)$coef[4]*100)
)

#95%
label <- paste0(c("DF", "LA", "V", "K", "S", "RV", "SF", "E", "DF", "LA", "V", "K", "S", "RV", "SF", "E"))
Sample <- paste0(c("Full sample", "Full sample", "Full sample", "Full sample", "Full sample", "Full sample", "Full sample", "Full sample", "Subset w. answers", "Subset w. answers", "Subset w. answers", "Subset w. answers", "Subset w. answers", "Subset w. answers", "Subset w. answers", "Subset w. answers"))
lower <- mean+(SE*1.96)
upper <- mean-(SE*1.96)

df_1 <- data.frame(label, mean, lower, upper)

#90%
lower <- mean +(SE*1.64)
upper <- mean -(SE*1.64)

df_2 <- data.frame(label, mean, lower, upper)
df_1$label <- factor(df_1$label, levels=c("DF", "LA", "V", "K", "S", "RV", "SF", "E"))

fp <- ggplot(data=df_1, aes(x=label, y=mean, ymin=lower, ymax=upper, col=Sample)) +
  geom_point(size=3.5, position=position_dodge(width=0.22))+
  geom_errorbar(data=df_1, aes(ymin=lower, ymax=upper),position=position_dodge(width=0.22), width=0.1, size=.6) +
  geom_errorbar(data=df_2, aes(ymin=lower, ymax=upper),position=position_dodge(width=0.22), width=0.0, size=.9) +
  geom_hline(yintercept=0, lty=2, color = "grey40") +  # add a dotted line at x=1 after flip
  coord_flip() +
  scale_y_continuous(breaks = seq(-90, 30, by = 10), limits=c(-90, 30)) +
  labs(y="", x=NULL) + theme(axis.text=element_text(size=10)) +
  theme_bw() + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank() + # panel.grid.major.y = element_blank()) +
                       theme(panel.border = element_blank()))
fp <- fp + theme_classic()

fp <- fp+ theme(axis.title.y = element_blank()) +scale_colour_grey(start = 0, end = .8)

a<-fp +annotate("text",
                x = c(1,2,3,4,5,6,7,8),
                y = c(-86,-86,-86,-86,-86,-86,-86,-86),
                label = c("0.48", "2.70", "3.51", "3.57", "5.35", "6.62", "6.68", "7.49"),
                family = "", fontface = 3, size=4, colour="grey")
a
b <- a + geom_abline(intercept = -78, slope = 0, color="grey", 
                     linetype="dashed", size=.5)
b<-b +    annotate(geom = "text", x = 4.5, y = -79.8, label = "Immigration policy measure, party averages", color = "grey",
                   angle = -90)
b
c <- b 

c<-c + ggtitle("") + 
  theme(plot.title = element_text(lineheight=.7, face="bold"))

n2<-c + theme(legend.position = c(.27,.89))

n2  + theme(legend.title = element_blank())

#ggsave(filename="App_N2.png", plot=n2, dpi=300)

##################################################
## Appendix O: Interaction wtih and without party FE 
##################################################

#rename main data
dfo <- data

#Q9 is coded reversed - Recode Q9
df_new<-dfo
df_new$Q9_re <- recode(df_new$Q9, "5=1;4=2;3=3;2=4;1=5")

# sum questions in new var.
df_new$index <- (df_new$Q8+df_new$Q9_re)

#Recode index var.
df_new$index_re <- recode(df_new$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")

# remove all candidates with no answer
df_new <- df_new[!is.na(df_new$index_re),]

# Remove all minority candidates
df_new <-subset(df_new, Minority_pol==0)

##With party FE
fitpp<-plm(formula = response ~ T_etni+index_re + T_etni*index_re, data = df_new, model = "within", index = c("party"))
summary(fitpp)

#Without
fitpp2 <- lm(response~T_etni+index_re+T_etni*index_re,data=df_new)
summary(fitpp2)

##################################################
## Appendix P: Interactions between ethnic cue and policy stances 
##################################################

#rename main data
dfp <- data

#Q9 is coded reversed - Recode Q9
df_new <- dfp
df_new$Q9_re <- recode(df_new$Q9, "5=1;4=2;3=3;2=4;1=5")

# sum questions in new var.
df_new$index <- (df_new$Q8+df_new$Q9_re)

#Recode index var.
df_new$index_re <- recode(df_new$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")

# remove all candidates with no answer
df_new <- df_new[!is.na(df_new$index_re),]

# Remove all minority candidates
df_new <-subset(df_new, Minority_pol==0)

#Few missing values are coded as 0 8candidates who didn't answer a specfic question). Change to NA
df_new$Q1[df_new$Q1 == 0] <- NA
df_new2$Q4[df_new2$Q4 == 0] <- NA
df_new$Q5[df_new$Q5 == 0] <- NA
df_new$Q7[df_new$Q7 == 0] <- NA
df_new$Q11[df_new$Q11 == 0] <- NA
df_new$Q12[df_new$Q12 == 0] <- NA
df_new$Q13[df_new$Q13 == 0] <- NA
df_new$Q14[df_new$Q14 == 0] <- NA

fit1 <- plm(formula=response ~ T_etni+Q1+T_etni*Q1, data=df_new, model = "within", index = c("party"))
summary(fit1)

fit2 <- plm(formula=response ~ T_etni+Q2+T_etni*Q2, data=df_new, model = "within", index = c("party"))
summary(fit2)

fit3 <- plm(formula=response ~ T_etni+Q3+T_etni*Q3, data=df_new, model = "within", index = c("party"))
summary(fit3)

fit4 <- plm(formula=response ~ T_etni+Q4+T_etni*Q4, data=df_new, model = "within", index = c("party"))
summary(fit4)

fit5 <- plm(formula=response ~ T_etni+Q5+T_etni*Q5, data=df_new, model = "within", index = c("party"))
summary(fit5)

fit6 <- plm(formula=response ~ T_etni+Q6+T_etni*Q6, data=df_new, model = "within", index = c("party"))
summary(fit6)

fit7 <- plm(formula=response ~ T_etni+Q7+T_etni*Q7, data=df_new, model = "within", index = c("party"))
summary(fit7)

fit8 <- plm(formula=response ~ T_etni+Q8+T_etni*Q8, data=df_new, model = "within", index = c("party"))
summary(fit8)

fit9 <- plm(formula=response ~ T_etni+Q9+T_etni*Q9, data=df_new, model = "within", index = c("party"))
summary(fit9)

fit10 <- plm(formula=response ~ T_etni+Q10+T_etni*Q10, data=df_new, model = "within", index = c("party"))
summary(fit10)

fit11 <- plm(formula=response ~ T_etni+Q11+T_etni*Q11, data=df_new, model = "within", index = c("party"))
summary(fit11)

fit12 <- plm(formula=response ~ T_etni+Q12+T_etni*Q12, data=df_new, model = "within", index = c("party"))
summary(fit12)

fit13 <- plm(formula=response ~ T_etni+Q13+T_etni*Q13, data=df_new, model = "within", index = c("party"))
summary(fit13)

fit14 <- plm(formula=response ~ T_etni+Q14+T_etni*Q14, data=df_new, model = "within", index = c("party"))
summary(fit14)

fit15 <- plm(formula=response ~ T_etni+Q15+T_etni*Q15, data=df_new, model = "within", index = c("party"))
summary(fit15)

