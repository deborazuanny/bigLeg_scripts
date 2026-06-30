#       Script to extract the top ten most diverse genera within Fabaceae
#-------------------------------------------------------------------------------

# Load the packages
library(expowo)
library(taxize)

# Create the powocodes data frame
powocodes <- cbind(family = "Fabaceae",
                   data.frame(taxize::get_pow("Fabaceae")))

# Use the function topGen to extract the data
topGen(powocodes$family,
       limit = 10,
       verbose = TRUE,
       save = TRUE,
       dir = "results_toptenGen/",
       filename = "Fabaceae_topten")
