plot3 <- function(){
require("reshape2")
require("ggplot2")

#read in the data files
neidata <- readRDS("SummarySCC_PM25.rds")
sccdata <- readRDS("Source_Classification_Code.rds")

#subset the neidata to only the values for Baltimore
neidata_bal <- neidata[neidata$fips=="24510",]

#create the desired dataset with  year,type combo and total Emission for that combination
molten_data <- melt(neidata_bal, id=c("year", "type"), measure.vars="Emissions")
desired_data <- dcast(molten_data, year + type ~ variable, sum)
  

#set the year column to be numeric (for plotting reasons)
desired_data$year <- as.numeric(desired_data$year)

#create the plot
qplot(data=desired_data, year, Emissions, color = type) + #use the color param to separate types of sources
geom_line() + #add a line through the points for better reading
ggtitle("Emission totals per type of source for Baltimore City") + #appropiate title
scale_x_continuous(breaks=c(1999, 2002, 2005, 2008), limits=c(1999,2008))#adjust x-axis so that it matches the datapoints

#save to png file
ggsave(filename="plot3.png")


}