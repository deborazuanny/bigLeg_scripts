#------------------------------------------------------------------------------#
# Script for cleaning the list from IPNI
#------------------------------------------------------------------------------#

# Loading packages
library(dplyr)
library(magrittr)
library(ggplot2)

# Reading the spreadsheet with all species
megaGenspp <- read.csv("powo_Species_megagenFabaceae_accepted_spp.csv")

# Reading the IPNI spreadsheet with only tax. nov.
IPNI_new <- read.csv("new_names_IPNI_megagen.csv")

# Reading the IPNI spreadsheet with comb. nov., nom. nov.,+ stat. nov.
IPNI_comb <- read.csv("IPNI_tax_change_megagen.csv")

# Select only the scientific name column
NEW_names <- IPNI_new$scientific.name
tax_change <- IPNI_comb$scientific.name

# Compare with POWO data and extract only the actual accepted names
tt <- NEW_names %in% megaGenspp$taxon_name
acc_NEW_names <- NEW_names[tt]
new_genus <- IPNI_new$genus[tt]
publ_new <- IPNI_new$published[tt]
datanewspp <- data.frame(genus = new_genus,
                         taxon = acc_NEW_names,
                         year = publ_new)

to <- tax_change %in% megaGenspp$taxon_name
acc_tax_change <- tax_change[to]
acc_genus <- IPNI_comb$genus[to]
publ_tax_c <- IPNI_comb$published[to]
datacombnov <- data.frame(genus = acc_genus,
                          taxon = acc_tax_change,
                          year = publ_tax_c)
# Reading the unknown citation type file
teste <- read.csv("unknown_IPNI_tax_nov.csv")

d <- teste$scientific.name %in% megaGenspp$taxon_name
teste <- teste[d,]

# Comparing with the previous IPNI_new table
igual <- teste$scientific.name %in% IPNI_new$scientific.name
teste <- teste[!igual,]

#Exclude repeated lines of names, which have more than 1 year of publication
t1 <- 
  teste %>% group_by(scientific.name) %>% filter(!duplicated(scientific.name))

unknown <- data.frame(genus = t1$genus,
                      taxon = t1$scientific.name,
                      year = t1$published)
new_names_table <- rbind(unknown, datanewspp)

# Ordering year of publication
datacombnov <- datacombnov[order(datacombnov$year, decreasing = FALSE), ]
datanewspp <- datanewspp[order(datanewspp$year, decreasing = FALSE), ]

write.csv(datacombnov, "tax_change_acceptedspecies.csv", row.names = FALSE)
write.csv(datanewspp, "new_names_acceptedspecies.csv", row.names = FALSE)
