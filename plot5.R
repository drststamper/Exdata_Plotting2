plot5 <- function(){
require("ggplot2")
require("reshape2")

#read in the data files
neidata <- readRDS("SummarySCC_PM25.rds")
sccdata <- readRDS("Source_Classification_Code.rds")

#subset the neidata to only the values for Baltimore
neidata_bal <- neidata[neidata$fips=="24510",]

#merge the separate files into one
merge_data <- merge(neidata_bal, sccdata, by.x = "SCC", by.y = "SCC")
names(merge_data)[9] <- "EmissionSector" #better than the old name 'EI.Sector'

#select only data from motor vehicle-related sources
indices <- grep("[vV]ehicles|Dust - [PU]|Gas Stations", merge_data$EmissionSector, value=FALSE)
filtered_data <- merge_data[indices, ]

#create the desired dataset with  year and total Emission 
molten_data <- melt(filtered_data, id="year", measure.vars="Emissions")
desired_data <- dcast(molten_data, year ~ variable, sum)
  
#set the year column to be numeric (for plotting reasons)
desired_data$year <- as.numeric(desired_data$year)

#create the plot
qplot(data=desired_data, year, Emissions) + 
geom_line() + #add a line through the points for better reading
ggtitle("Emission totals per year for motor vehicle-related sources in Baltimore City") + #appropiate title
scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), limits=c(1999,2008))#adjust x-axis so that it matches the datapoints

#save to png file
ggsave(filename="plot5.png")

}