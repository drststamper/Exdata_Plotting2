plot6 <- function(){
require("ggplot2")
require("reshape2")

#read in the data files
neidata <- readRDS("SummarySCC_PM25.rds")
sccdata <- readRDS("Source_Classification_Code.rds")

#subset the neidata to only the values for Baltimore and Los Angeles
neidata_bal_la <- neidata[neidata$fips=="24510" | neidata$fips=="06037",]

#rename fips column to City and replace fips nrs with city name
names(neidata_bal_la)[1] <- "City"
neidata_bal_la$City <- gsub("24510", "Baltimore City", neidata_bal_la$City)
neidata_bal_la$City <- gsub("06037", "Los Angeles County", neidata_bal_la$City)

#merge the separate files into one
merge_data <- merge(neidata_bal_la, sccdata, by.x = "SCC", by.y = "SCC")
names(merge_data)[9] <- "EmissionSector" #better than the old name 'EI.Sector'

#select only data from motor vehicle-related sources
indices <- grep("[vV]ehicles|Dust - [PU]|Gas Stations", merge_data$EmissionSector, value=FALSE)
filtered_data <- merge_data[indices, ]

#create the desired dataset with  year and total Emission 
molten_data <- melt(filtered_data, id=c("year","City"), measure.vars="Emissions")
desired_data <- dcast(molten_data, year + City ~ variable, sum)
  
#set the year column to be numeric (for plotting reasons)
desired_data$year <- as.numeric(desired_data$year)

#create the plot
qplot(data=desired_data, year, Emissions, color = City) + 
geom_line() + #add a line through the points for better reading
ggtitle("Emission totals for motor vehicle-related sources") + #appropiate title
scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), limits=c(1999,2008))#adjust x-axis so that it matches the datapoints

#save to png file
ggsave(filename="plot6.png")

}