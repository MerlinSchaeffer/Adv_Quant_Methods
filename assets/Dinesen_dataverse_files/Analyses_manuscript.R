##################################################################################
# "When are legislators responsive to ethnic minorities?
#  - Testing the role of electoral incentives and candidate selection for mitigating ethnocentric responsiveness"

# This script generates the results and figures included in the manuscript.
# The script relies on a data file ("APSR_responsive.xlsx") which is not available (please consult the readme file) plus three non-anonymized files for reproducing parts of the analyses
##################################################################################
#Load packages
library(stargazer)
library(coefplot)
library(ggplot2)
library(dplyr)
library(Rmisc)
library(readr)
library(readxl)
#########################################################

#Load data: 
data_nonanon1 <-read_excel("main_data_1_excel.xls")
data_nonanon2 <-read_excel("main_data_2_excel.xls") 
data_nonanon3 <-read_excel("main_data_2_excel.xls")
  
#Load data (not available, please consult the readme file): 
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


####################################

### Table 1. ###

#Rename data frame
df <- data_nonanon1

#Run model
T1fit <- lm(response ~ T_etni, df)
summary(T1fit)

#Interaction
T1fit2 <- lm(response ~ T_etni+Minority_pol+T_etni*Minority_pol, df)
summary(T1fit2)

stargazer(T1fit, T1fit2, title ="", 
          align=TRUE, dep.var.labels=c("Response (0/1)"),
          omit.stat=c("LL","ser","f"),
          no.space=TRUE,
          star.char = c("*", "**", "***"),
          star.cutoffs = c(.05, .01, .001),
          out ="../Table1.html")


### Figure 2 ###
#Create two subsets conditioned on politicians' ethnic background
df_maj <-subset(df, Minority_pol==0)
df_min <-subset(df, Minority_pol==1)

#Run models, save coefs and plot
M3<- lm(response ~  T_etni, df_maj)
summary(M3)
est <- coef(M3)[2]
se<-coef(summary(M3))[, "Std. Error"][2]

M4<- lm(response ~  T_etni, df_min)
summary(M4)
est2 <- coef(M4)[2]
se2<-coef(summary(M4))[, "Std. Error"][2]

#Visualize
#95% ci
label <- paste0(c("Majority politicians", "Minority politicians"))
mean  <- c(est*100, est2*100) 
lower <- c((est-(1.96*se))*100, (est2-(1.96*se2))*100)
upper <- c((est+(1.96*se))*100, (est2+(1.96*se2))*100)
df_1 <- data.frame(label, mean, lower, upper)
df_1$label <- factor(df_1$label, levels= c("Majority politicians", "Minority politicians"))

#90% ci
mean  <- c(est*100, est2*100) 
lower <- c((est-(1.64*se))*100, (est2-(1.64*se2))*100)
upper <- c((est+(1.64*se))*100, (est2+(1.64*se2))*100)
df_2 <- data.frame(label, mean, lower, upper)

##Plot
df_2$label <- factor(df_2$label, levels= c("Majority politicians","Minority politicians"))

fig2 <- ggplot(data=df_1, aes(x=label, y=mean, ymin=lower, ymax=upper)) +
  geom_point(size=4) +
  geom_errorbar(data=df_1, color="grey67", width=.07) +
  geom_hline(yintercept=0, lty=2, color = "grey40") +  # add a dotted line at x=1 after flip
  coord_flip() +
  scale_y_continuous(breaks = seq(-50, 50, by = 5), limits=c(-35, 45)) +
  labs(y="Percentage points", x=NULL) + theme(axis.text=element_text(size=12)) +
  theme_bw() + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank() +
  theme(panel.border = element_blank()))

#add 90%-errorbar
fig2 <- fig2 + geom_errorbar(data=df_2, aes(x=label, y=mean, ymin=lower, ymax=upper, width=0.07), color="black") + ggtitle("") + theme(plot.title=element_text(family="Times", face="bold", size=9))
fig2 <-fig2 +  theme(axis.text.x = element_text(color="black", size=10),
           axis.text.y = element_text(color="black", size=10))

#ggsave(filename="Figure2.png", plot=fig2, dpi=300)



### FIGURE 3 ###
#Rename data frame
df_maj <- data_nonanon2

#summary of response rates
plot3 <- summarySE(df_maj,"response",groupvars=c("T_etni", "T_info"),na.rm=TRUE)

#rename combinations of 0s and 1s
plot3$T_info <- c("no", "yes", "no", "yes")

#Estimate interaction
M5<- lm(response ~ T_etni+T_info+T_info*T_etni, df_maj)
summary(M5)

### Plot
#Add data and random fill in order to visualize:
T_etni <- c("x") #add random fill
T_info <- c("2") #add random fill
N <- c(2326) 
response <- c(coef(M5)[4])
sd <- c(.999) #fill in random number
se <- c(coef(summary(M5))[, "Std. Error"][4])
ci <- c(se*1.96)
plot3_2 <- data.frame(T_etni, T_info, N, response, sd, se, ci)

#merge the frames
Fig3 <- rbind(plot3, plot3_2)

#rename levels
Fig3$T_info <- factor(Fig3$T_info)
levels(Fig3$T_info)
Fig3$T_info <- factor(Fig3$T_info, levels = c("2", "yes", "no"))

# Plot SE of the mean
ggplot(Fig3, aes(x=T_info, y=response, colour=T_etni)) + 
  geom_errorbar(aes(ymin=response-se, ymax=response+se), width=.1) +
  geom_point() 

#Barplot
plot3a<-ggplot(Fig3, aes(x=T_info, y=response, fill=T_etni)) +
  geom_bar(width=0.7, position=position_dodge(.78), stat="identity") +scale_colour_grey(start = 0, end = .9)

plot3a<-plot3a + geom_errorbar(position=position_dodge(.78),width=.25, (aes(ymin=response-ci, ymax=response+ci)))+
  theme_bw()  + scale_colour_grey(start = 0, end = .9) +
  theme(panel.border = element_blank())+ 
  theme(axis.line = element_line(color = 'black')) +
  ylab("Responsiveness") +
  scale_y_continuous(breaks = seq(-.15, .9, by = .1)) +
  xlab("") +
  coord_flip() +
  theme(legend.position="bottom") +
  ggtitle("") +
scale_fill_grey (name="", 
                 labels=c("Majority alias", "Minority alias", "Difference-in-differences")) 
plot3a

#change label names
labels <- c("Difference-in-differences", "Explicit voting cue","No voting cue")
labels
plot3b <- plot3a  + scale_x_discrete(labels=labels) 
plot3b

# Add layers
plot3b <-plot3b+annotate("text",
               x = c(2.2, 1.84, 2.8, 3.2),
               y = c(0.32, 0.32, 0.32, 0.32),
               label = c("56%", "75.4%", "67.3%", "52.2%" ),
               family = "", fontface = 3, size=3, colour="white")

plot3c<- plot3b +annotate("text",
                   x = c(1.2),
                   y = c(-0.02),
                   label = c("-4.3" ),
                   family = "", fontface = 3, size=3, colour="black")

Figure3 <- plot3c + annotate("segment", x = 1.5, xend =1.5, y = -.08, yend = .8,
                      colour = "black", linetype = "dashed")

Figure3

### Table 2 ###
# Coloumn 1 in table 2
#Run regression in subset of majority politicians
t2fit1 <- lm(response ~ T_etni + T_info + T_etni*T_info, df_maj)
summary(t2fit1)

### Coloumn 2 in table 2
#only include those seeking re-election
df_maj$run<-factor(df_maj$run)
levels(df_maj$run)

#Rename
levels(df_maj$run) <- c("no", "yes")

#subset to only rerunners
df_newrun <-subset(df_maj, run=="yes")

#Regression
t2fit2 <- lm(response ~ T_etni + T_info + T_etni*T_info, df_newrun)
summary(t2fit2)

###  Coloumn 3 in table 2 
## Remove incumbents that do not run for reelection
df_new <- df_maj #rename data
df_new$run[df_new$run=="no"] <- NA
df_new<-df_new[!is.na(df_new$run),]

#drop candidates that always win in the 2013 election (clear winners)
df_2013_without1 <- subset(df_new, closeness_2013_dum==0)

#regression with close election subset 2013
t2fit3 <- lm(response ~ T_etni + T_info + T_etni*T_info, df_2013_without1)
summary(t2fit3)

#Create table 2
stargazer(t2fit1,t2fit2,t2fit3, title ="", 
          align=TRUE, dep.var.labels=c("Response"),
          omit.stat=c("LL","ser","f"),
          no.space=TRUE,
          star.char = c("*", "**", "***"),
          star.cutoffs = c(.05, .01, .001),
          covariate.labels=c("Minority alias","Vote cue", "Minority alias * Vote cue"),
          out =".../Table2.html")


### Figure 4 ###
#Rename data frame
df <- data_nonanon3

#Recode Q9 since Q9 is reversed relative to Q8
df_new$Q9_re <- recode(df_new$Q9, "5=1;4=2;3=3;2=4;1=5")

#sum questions in index variable
df_new$index <- (df_new$Q8+df_new$Q9_re)

#Recode index var.
df_new$index_re <- recode(df_new$index, "2=0;3=1;4=2;5=3;6=4;7=5;8=6;9=7;10=8")

# remove all candidates with missing answer in index
df_new <- df_new[!is.na(df_new$index_re),]

# Subset to only majority candidates
df_new <-subset(df_new, Minority_pol==0)

#Estimate party averages on index
partyscore <- summarySE(df_new,"index_re",groupvars=c("party"),na.rm=TRUE)
partyscore

#round scores
round(partyscore$index_re, digits=2)

#Estimate effects for each party (Majority politicians only)
df <-subset(df, Minority_pol==0)

df_df <- subset(df, party=="DF")
dfs <- lm(response ~ T_etni, data=df_df)
summary(dfs)

df_la <- subset(df, party=="Liberal Alliance")
la <- lm(response ~ T_etni, data=df_la)
summary(la)

df_v <- subset(df, party=="Venstre")
venstre <- lm(response ~ T_etni, data=df_v)
summary(venstre)

df_c <- subset(df, party=="Det Konservative Folkeparti")
cons <- lm(response ~ T_etni, data=df_c)
summary(cons)

df_sos <- subset(df, party=="Socialdemokratiet")
sos <- lm(response ~ T_etni, data=df_sos)
summary(sos)

df_r <- subset(df, party=="Radikale Venstre")
rv <- lm(response ~ T_etni, data=df_r)
summary(rv)

df_sf <- subset(df, party=="SF")
sf <- lm(response ~ T_etni, data=df_sf)
summary(sf)

df_oe <- subset(df, party=="Enhedslisten")
oe <- lm(response ~ T_etni, data=df_oe)
summary(oe)

##Plot 
label <- paste0(c("DF", "LA", "V", "K", "S", "RV", "SF", "E"))
mean  <- c(dfs$coef[2]*100, la$coef[2]*100,venstre$coef[2]*100,cons$coef[2]*100
           ,sos$coef[2]*100,rv$coef[2]*100,sf$coef[2]*100,oe$coef[2]*100
) 

SE <- c((summary(dfs)$coef[4]*100),
        (summary(la)$coef[4]*100),
        (summary(venstre)$coef[4]*100),
        (summary(cons)$coef[4]*100),
        (summary(sos)$coef[4]*100),
        (summary(rv)$coef[4]*100),
        (summary(sf)$coef[4]*100),
        (summary(oe)$coef[4]*100)
)
lower <- mean+(SE*1.96)
upper <- mean-(SE*1.96)

df_1 <- data.frame(label, mean, lower, upper)

#90%
lower <- mean +(SE*1.64)
upper <- mean -(SE*1.64)

df_2 <- data.frame(label, mean, lower, upper)
df_1$label <- factor(df_1$label, levels=c("DF", "LA", "V", "K", "S", "RV", "SF", "E"))

#Plot
fig4 <- ggplot(data=df_1, aes(x=label, y=mean, ymin=lower, ymax=upper)) +
  geom_point(size=4) +
  geom_errorbar(data=df_1, color="grey67", width=.07) +
  geom_hline(yintercept=0, lty=2, color = "grey40") +  
  coord_flip() +
  scale_y_continuous(breaks = seq(-70, 30, by = 10), limits=c(-72, 30)) +
  labs(y="Percentage points", x=NULL) + theme(axis.text=element_text(size=10)) +
  theme_bw() + theme(panel.grid.major.x = element_blank(), panel.grid.minor.x = element_blank() + # panel.grid.major.y = element_blank()) +
                       theme(panel.border = element_blank()))

#Add 90%-errorbar
fig4 <- fig4 + geom_errorbar(data=df_2, aes(x=label, y=mean, ymin=lower, ymax=upper, width=0.07), color="black") + ggtitle("") + theme(plot.title=element_text(family="Times", face="bold", size=9))
fig4 <- fig4 + theme_classic()

fig4a<-fig4 +annotate("text",
                      x = c(1,2,3,4,5,6,7,8),
                      y = c(-72,-72,-72,-72,-72,-72,-72,-72),
                      label = c("0.48", "2.70", "3.51", "3.57", "5.35", "6.62", "6.68", "7.49"),
                      family = "", fontface = 3, size=4, colour="grey")

fig4b <- fig4a + geom_abline(intercept = -66, slope = 0, color="grey", 
                             linetype="dashed", size=.5)
fig4c<-fig4b +    annotate(geom = "text", x = 4.5, y = -67, label = "Immigration policy measure, party averages", color = "grey",
                           angle = -90)

fig4c + ggtitle("") + 
  theme(plot.title = element_text(lineheight=.7, face="bold"))

#ggsave(filename="Figure4.png", plot=fig4c, dpi=300)


###  Figure 5 ###
#Rename data frame
df_new <- data

#Rename parties and plot distributions for subset who answered the candidate test
df_sos <- subset(df_new, party==c("Socialdemokratiet"))
df_sos$party <- c("S")

df_v <- subset(df_new, party==c("Venstre"))
df_v$party <- c("V")

df_c <- subset(df_new, party==c("Det Konservative Folkeparti"))
df_c$party <- c("K")

df_sf <- subset(df_new, party==c("SF"))
df_sf$party <- c("SF")

df_df <- subset(df_new, party==c("DF"))
df_df$party <- c("DF")

df_la <-subset(df_new, party==c("Liberal Alliance"))
df_la$party <- c("LA")

df_oe <- subset(df_new, party==c("Enhedslisten"))
df_oe$party <- c("E")

df_r <- subset(df_new, party==c("Radikale Venstre"))
df_r$party <- c("RV")

#merge
df_all <- rbind(df_sos, df_v, df_c, df_sf, df_r, df_df, df_oe, df_la)
df_all$party <- factor(df_all$party, levels = c("S", "V", "K", "DF", "SF", "E","RV", "LA"))

#Histogram
plothist <-ggplot(data = df_all, aes(x = index_re, y=..count.. / sum(..count..))) +
  geom_bar() + 
  facet_wrap(~party, ncol = 4)

Fig5a<-plothist +  theme_classic()+ scale_x_continuous(breaks = seq(0, 9, 1))
Fig5b<-Fig5a + theme(axis.title.y=element_blank(), axis.title.x=element_blank(), panel.border = element_rect(colour = "grey", fill=NA, size=.5 ))

Fig5b

#ggsave(filename="Figure5.png", plot=Fig5b, dpi=300)

### FIGURE 6 ###
#Check bins
inter.binning(Y = "response", D = "T_etni", X = "index_re", Z = "party", data = df_new, FE = c("party"), vartype = "robust", Ylabel = "Outcome", Dlabel = "Treatment", Xlabel="Index",
              cutoffs = c(1,2,5,7))

#Run regression
fitpp <- lm(response~T_etni+index_re+T_etni*index_re + factor(party)-1,data=df_new)
summary(fitpp)

plot6<-interplot(fitpp,var1="T_etni",var2="index_re", hist=TRUE) +
  geom_hline(yintercept=0,linetype="dashed") +
  labs(x="Immigration policy measure",y="Marginal effect") +
  ggtitle("") +
  scale_y_continuous(breaks = seq(-.55, 0.05, by = 0.1), limits=c(-.55, .1)) +
  theme(plot.title = element_text(size = 12), panel.background = element_blank()) 

plot6a <- plot6 + theme(axis.title.y = element_text(size = rel(.7), angle = 90, face = "bold"))
plot6b <- plot6a + theme(axis.title.x = element_text(size = rel(.7), angle = 00, face = "bold"))

plot6c <- plot6b + theme(legend.text = element_text(size = 10))
plot6d <- plot6c +   theme(axis.text=element_text(size=8)) 

#Add bins to plot (move bin slightly from x axis to make it identifiable)
plot6e<-plot6d + annotate("pointrange", x = 0.05, y = -.374, ymin = -.525, ymax = -.223,
                          colour = "black", size = .5)
plot6e <- plot6e + annotate("pointrange", x = 2, y = -.241, ymin = -.414, ymax = -.068,
                            colour = "black", size = .5)
plot6e <- plot6e + annotate("pointrange", x = 4, y = -.156, ymin = -.229, ymax = -.082,
                            colour = "black", size = .5)
plot6e <- plot6e + annotate("pointrange", x = 6, y = -.112, ymin = -.233, ymax = .0091,
                            colour = "black", size = .5)
plot6e <- plot6e + annotate("pointrange", x = 8, y = -.120, ymin = -.252, ymax = .0124,
                            colour = "black", size = .5)+ labs(caption="")
plot6e

#ggsave(filename="Figure6.png", plot=plot6e, dpi=300)
