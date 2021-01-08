### MIXED EFFECTS MODELLING

# Mixed effects models are useful when working with multiple data points from the same subject. It works 
#around the ANOVA assumption that all data points are independent. 

# Example Dataset: Runners

# Here we will work with a very basic dataset which involves the times of runners running 100m sprints once
# every week for 3 weeks. In addition, there is data indicating which school they attended. Each school 
# hypothetically has different programs for helping athletes attain faster
# sprint times. Now there are usually more variables that come into play for sprinting, 
# however we will assume that all runners are uniform to some
# degree (background, weight, age etc.) for simplicity sake.

# Import Data

running <- read.csv("./Data/runners_example.csv") 
str(running)
running$Week <- as.factor(running$Week) #Convert week to a factor

# Let's imagine we have 2 main questions:

# (1) Which school is better at training athletes to have faster sprint times?
# (2) How consistent are the runners in their sprint times? 

# To answer these, we will use mixed effects modelling as well as repeatability analysis.

#Mixed effects model

library(lme4)

running_model <- lmer(Time ~ School + Week + (1 | Runner.ID), data = running)  
tab_model(running_model)
hist(residuals(running_model))

library(rptR)

rpt_running <- rpt(Time ~ School + Week + (1 |  Runner.ID), grname = "Runner.ID", 
         data = running, datatype = "Gaussian", nboot = 100, npermut = 100)

rpt_running
