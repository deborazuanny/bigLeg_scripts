#-------------------------------------------------------------------------------
# Script to create global maps for each one of the seven big genera
#-------------------------------------------------------------------------------
# Load the package
library(expowo)

# Load the data
megaData <- read.csv("powo_Species_megagenFabaceae_accepted_spp.csv")

# Create individual maps of each megadiverse genera with Viridis scale "rocket"
# According to political countries
expowo::powoMap(inputdf = megaData,
                botctrs = NULL,
                distcol = "native_to_country",
                taxclas = "genus",
                verbose = FALSE,
                vir_color = "rocket",
                bre_color = NULL,
                leg_title = "SR",
                dpi = 600,
                dir = "results_powoMap/",
                filename = "global_richness_country_map",
                format = "jpg")

# According to botanical countries subdivision
# Load the associated data
data("botdivmap")

expowo::powoMap(inputdf = megaData,
                botctrs = botdivmap,
                distcol = "native_to_botanical_countries",
                taxclas = "genus",
                verbose = FALSE,
                vir_color = "rocket",
                bre_color = NULL,
                leg_title = "SR",
                dpi = 600,
                dir = "results_powoMap/",
                filename = "global_richness_botcountry_map",
                format = "jpg")
