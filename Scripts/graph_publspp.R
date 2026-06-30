#------------------------------------------------------------------------------#
# Script for creating a graphic of species accumulation

#------------------------------------------------------------------------------#
# Loading packages
library(dplyr)
library(magrittr)
library(ggplot2)

# Reading the spreadsheet with all species
megaGenspp <- read.csv("powo_Species_megagenFabaceae_accepted_spp.csv")

# Dividing the data by combinatio nova and species nova using only the presence
# or absence of a ")".
# combinatio nova list
tt <- grepl(")", megaGenspp$scientific_name)
combnov <- megaGenspp$scientific_name[tt]
pubcombnov <- megaGenspp$publication[tt]

# species nova list
to <- !grepl(")", megaGenspp$scientific_name)
newspp <- megaGenspp$scientific_name[to]
pubnewspp <- megaGenspp$publication[to]

# Removing extra information except the year of publication
pubcombnov <- gsub(".*[(]", "", pubcombnov)
pubcombnov <- gsub("[)]", "", pubcombnov)
pubnewspp <- gsub(".*[(]", "", pubnewspp)
pubnewspp <- gsub("[)]", "", pubnewspp)

# Cleaning duplicated year and undesired month (e.g. "1907 publ. 1908"
# and "July1888").
pubcombnov <- gsub(".*[.]", "", pubcombnov)
pubcombnov <- gsub(" ", "", pubcombnov)
pubnewspp <- gsub(".*[.]", "", pubnewspp)
pubnewspp <- gsub(" ", "", pubnewspp)
pubnewspp <- gsub("[a-z]", "", pubnewspp)
pubnewspp <- gsub("J", "", pubnewspp)

# Coercing publication dates to numeric values
pubcombnov <- as.integer(pubcombnov)
pubnewspp <- as.integer(pubnewspp)

# Creating the genus list according to comb. nov. or sp. nov.
genus <- megaGenspp$genus
genuscombnov <- genus[tt]
genusnewspp <- genus[to]

# Creating separated data frames
datacombnov <- data.frame(genus = genuscombnov,
                          species = combnov,
                          year = pubcombnov)
datanewspp <- data.frame(genus = genusnewspp,
                         species = newspp,
                         year = pubnewspp)

# Ordering year of publication
datacombnov <- datacombnov[order(datacombnov$year, decreasing = FALSE), ]
datanewspp <- datanewspp[order(datanewspp$year, decreasing = FALSE), ]

# Plotting the graphs
g <- ggplot(datacombnov, aes(x = year, y = species, colour = genus)) +
            geom_line(aes(colour = genus)) +
            #scale_y_continuous(limits = length(datacombnov$species), breaks=seq(0,2000,300)) +
            geom_point() +
            theme(axis.text.x = element_text(angle = 60, hjust = 1)) +
            scale_x_discrete(labels = datacombnov$year) + xlab("Year") +
            ylab("New names")

