# Question for Katja - Why does this code result in rounded whole numbers in the "sum(WetBiomass_G)" column?
#load sqldf library and read csv file
library('sqldf')
sarg = read.csv("Sargassum All Months biomass.csv", header = TRUE)
head(sarg)

#check format of WetBiomass_G column
#looks like you have varying numbers of digits after the decimal point from 0 to 9
sqldf("select distinct WetBiomass_G from sarg limit 10")

#original calculation. Sqllite uses by default the number of digits that makes the most sense. Since 0 has no digits following, it rounds.
summaryByBiomass <- sqldf("select SAMPLING_PERIOD, SITE_TRANSECT, QUAD_ID, SP_CODE, LIFESTAGE, sum(WetBiomass_G) from sarg group by SAMPLING_PERIOD, SITE_TRANSECT, QUAD_ID, SP_CODE, LIFESTAGE")

#update the dataframe so that the datatype of WetBiomas_G takes decimals
sarg_digits <- sqldf("select sarg.*, 1.0 * WetBiomass_G as WetBiomass_G_9 from sarg")

#Same export as before, but now to multiple decimal places. Calculation should be double checked.
summaryByBiomass <- sqldf("select SAMPLING_PERIOD, SITE_TRANSECT, QUAD_ID, SP_CODE, LIFESTAGE, sum(WetBiomass_G_9) from sarg_digits group by SAMPLING_PERIOD, SITE_TRANSECT, QUAD_ID, SP_CODE, LIFESTAGE")

#View data output
View(summaryByBiomass) # sum(WetBiomass_G) values are rounded to nearest whole number

#write to new csv file
write.csv(summaryByBiomass, file = "summaryByBiomass.csv",row.names=FALSE) #rounded in exported file, too