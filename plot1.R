plot1 <- function(){
require("reshape2")

#read in the data file
neidata <- readRDS("SummarySCC_PM25.rds")


#create the desired dataset with the year and total Emission (all sources added up)
molten_data <- melt(neidata, id="year", measure.vars="Emissions")
desired_data <- dcast(molten_data, year ~ variable, sum)
  
#resulting values for Emissions are all in millions: create an additional column to 
#divide by million (for y-axis plot reasons)
desired_data$adjusted_Emissions <- desired_data$Emissions/1000000

#open graphics device (png)
png("plot1.png") 
  
#create a basic plot, without x-axis
plot(desired_data$year, desired_data$adjusted_Emissions, type="p", pch=16, col="blue", main = "Total Emissions in US", 
     xlab="Year", ylab="Total PM2.5 emission (x million, in tons)", xaxt="n")#xaxt="n" will prevent the x-axis from being filled

#add the x-axis with values that exactly match the 4 datapoints resembling the years
axis(side=1, at=c(1999,2002,2005,2008))

#close graphics device(png)
dev.off()
}