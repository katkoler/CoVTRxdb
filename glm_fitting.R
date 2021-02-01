library(readr)
library(dplyr)
library(jtools)
library(sjPlot)


# set working directory
setwd("")

# read table for dataset of top 10 drugs
covid19_tweets_trials = read_csv('top_drug_trials_and_tweets_over_time.csv')

# determine unique drugs in dataset
unique_drugs = unique(covid19_tweets_trials$Drug)

# select drugs of interest 
hydroxy = covid19_tweets_trials[covid19_tweets_trials$Drug == unique_drugs[1], ]
conv_plasma = covid19_tweets_trials[covid19_tweets_trials$Drug == unique_drugs[2], ]
remdesivir = covid19_tweets_trials[covid19_tweets_trials$Drug == unique_drugs[9], ]
dexa = covid19_tweets_trials[covid19_tweets_trials$Drug == unique_drugs[10], ]

# define null and alternate models for each drug
null_hydroxy_fit = glm( trials_CumSum ~ 1, family = "poisson", data = hydroxy)
hydroxy_fit = glm( trials_CumSum ~ tweets_CumSum, family = "poisson", data = hydroxy)

null_conv_plasma_fit = glm( trials_CumSum ~ 1, family = "poisson", data = conv_plasma)
conv_plasma_fit = glm( trials_CumSum ~ tweets_CumSum, family = "poisson", data = conv_plasma)

null_rem_fit = glm( trials_CumSum ~ 1, family = "poisson", data = remdesivir)
rem_fit = glm( trials_CumSum ~ tweets_CumSum, family = "poisson", data = remdesivir)

null_dexa_fit = glm( trials_CumSum ~ 1, family = "poisson", data = dexa)
dexa_fit = glm( trials_CumSum ~ tweets_CumSum, family = "poisson", data = dexa)

# obtain summary for glm (example for hydroxychloroquine shown) to obtain McFadden's pseudo-R2
summ(hydroxy_fit)

# run ANOVA to compare null and alternate models
hydroxy_anova_results = anova(null_hydroxy_fit, hydroxy_fit, test = "Chisq")
conv_plasma_anova_results = anova(null_conv_plasma_fit, conv_plasma_fit, test = "Chisq")
rem_anova_results = anova(null_rem_fit, rem_fit, test = "Chisq")
dexa_anova_results = anova(null_dexa_fit, dexa_fit, test = "Chisq")

# obtain p-values
hydroxy_pvalue = hydroxy_anova_results[["Pr(>Chi)"]][2]
conv_plasma_pvalue = conv_plasma_anova_results[["Pr(>Chi)"]][2]
rem_anova_pvalue = rem_anova_results[["Pr(>Chi)"]][2]
dexa_anova_pvalue = dexa_anova_results[["Pr(>Chi)"]][2]

# store p-values as vector
pvalues = c(hydroxy_pvalue, conv_plasma_pvalue, rem_anova_pvalue, dexa_anova_pvalue)

# adjust for multiple testing
adjusted_pvalues_bonferroni = p.adjust(pvalues, method = "bonferroni")


