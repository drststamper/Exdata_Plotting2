plot2 <- function(){
require("reshape2")

#read in the data file
neidata <- readRDS("SummarySCC_PM25.rds")


#subset the neidata to only the values for Baltimore
neidata_bal <- neidata[neidata$fips=="24510",]

#create the desired dataset with the year and total Emission (all sources added up)
molten_data <- melt(neidata_bal, id="year", measure.vars="Emissions")
desired_data <- dcast(molten_data, year ~ variable, sum)
  
#open graphics device (png)
png("plot2.png") 
  
#create a basic plot, without x-axis
plot(desired_data$year, desired_data$Emissions, type="p", pch=16, col="blue", main = "Total Emissions in Baltimore City", 
     xlab="Year", ylab="Total PM2.5 emission (in tons)", xaxt="n")#xaxt="n" will prevent the x-axis from being filled

#add the x-axis with values that exactly match the 4 datapoints resembling the years
axis(side=1, at=c(1999,2002,2005,2008))

#close graphics device(png)
dev.off()
}