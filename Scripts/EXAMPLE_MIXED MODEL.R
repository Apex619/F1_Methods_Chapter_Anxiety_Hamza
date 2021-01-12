### MIXED EFFECTS MODELLING

# Mixed effects models are useful when working with multiple data points from the same subject. It works 
#around the ANOVA assumption that all data points are independent. Further, it can work with datasets that
# have missing data. 

# Example: Total distance travelled by zebrafish in anxiety tests

# We wanted to know if zebrafish travel more in short tanks or tall tanks, and whether this was impacted
# by sex and water condition. Additionally, we want to know how consistent the zebrafish are in their 
# results. 


# To answer these, we will do mixed effects modelling as well as repeatability analysis. 

#Mixed effects modelling

library(lme4) #Package used to run mixed effects models
library(lmerTest) #Package to display p-values of mixed effects model
library(sjPlot) #Useful package in displaying results 

# To build our mixed model:

Model_Tot_Dist <- #assign our model an appropriate name
  lmer(tot_dist ~ #use the function lmer and specify our response variable (in this case total distance)
                         Tank + Sex + water_time + #specify our fixed factors (tank type, sex and water)
                         (1 | Fish_ID), #specify our random effect (fish ID)
                       data = Anxiety_Joined) #specify dataset

hist(residuals(Model_Tot_Dist)) #histogram of residuals to check for normal distribution

# Assumption of normality is satisfied, we can now examine the results of our model

tab_model(Model_Tot_Dist) #displaying results in a nice table with the tab_model function

# Overall, from the table output, based on our intercept, zebrafish travelled significantly less in
# tall tanks. Males also travelled less and as time went on and stress hormones were added and zebrafish
# also swam less. However the latter two results are insignificant. There is also extra information 
# presented in the table.

# To conduct repeatability analysis, we will use the package rptR. This package uses the mixed effects
# model framework. Note: The mixed model run previously also displays repeatability as ICC, however this
# cannot be considered accurate due to the lack bootstraps and permutations. 

# Unadjusted repeatabilities will involve no fixed factors and only the random factor. However, we will
# conduct adjusted analyses with water condition.

library(rptR)

total_distance_example <- #using the function rpt
  rpt(tot_dist ~ #specifying our response variable
                                water_time + #fixed factor
                                (1 |  Fish_ID), #random effect
                              grname = "Fish_ID", #random effect in quotation marks, must match with above
                              data = Anxiety_Joined, #dataframe
                              datatype = "Gaussian", #specify datatype
      nboot = 1000, npermut = 1000) #bootstraps and 
#                                   permutations to obtain 
#                                   SE and CI, 1000 will be enough for now but 10,000 is ideal

total_distance_example #run to see repeatability

# We obtain a significant repeatability of 0.26 (95% CI 0.174 - 0.34) which is moderate