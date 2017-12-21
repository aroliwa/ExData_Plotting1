# Load package 
library(lubridate)
library(dplyr)

# Download File from the Internet and extract zip archives
link = "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
download.file(url = link, destfile = "dataset.zip") 
unzip(zipfile = "dataset.zip")
rm(link)

# Reads a file in table format 
dataHPC <- read.table(file = "household_power_consumption.txt", header = TRUE, sep = ";", stringsAsFactors = FALSE)

#merge date and time into a single column
dataHPC$FullDate <- paste(dataHPC$Date, dataHPC$Time)

# Transform dates stored in character  to Date
dataHPC$FullDate <- dmy_hms(dataHPC$FullDate)

# Use only data from the dates 2007-02-01 and 2007-02-02
dataHPC2 <- dataHPC %>%
  filter(FullDate >= "2007-02-01 00:00:00" & FullDate <= "2007-02-02 23:59:99")

# look at missing values 
sapply(X = dataHPC2, FUN = function(X) sum(is.na(X)))

# Convert variables to double
dataHPC2$Global_active_power <- as.double(dataHPC2$Global_active_power)
dataHPC2$Global_reactive_power <- as.double(dataHPC2$Global_reactive_power)
dataHPC2$Voltage <- as.double(dataHPC2$Voltage)

# Convert variables to numeric
dataHPC2$Sub_metering_1 <- as.numeric(dataHPC2$Sub_metering_1)
dataHPC2$Sub_metering_2 <- as.numeric(dataHPC2$Sub_metering_2)
dataHPC2$Sub_metering_3 <- as.numeric(dataHPC2$Sub_metering_3)


######################################################


# Plot 1
png(filename = "plot1.png", width = 480, height = 480, units = "px")
hist(x = dataHPC2$Global_active_power, col = "red", xlab = "Global Active Power (kilowatts)",main = "Global Active Power")
dev.off()

