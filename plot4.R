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


# Plot 4
png(filename = "plot4.png", width = 480, height = 480, units = "px")

par(mfrow = c(2,2))

plot(dataHPC2$FullDate, dataHPC2$Global_active_power, type = "l", ylab = "Global Active Power (kilowatts)", xlab = "")

plot(dataHPC2$FullDate, dataHPC2$Voltage, type = "l",xlab = "datetime", ylab = "Voltage")

plot(dataHPC2$FullDate, dataHPC2$Sub_metering_1, type = "l", xlab = "", ylab = "Energy sub metering")
lines(dataHPC2$FullDate, dataHPC2$Sub_metering_2, type = "l", col = "red")
lines(dataHPC2$FullDate, dataHPC2$Sub_metering_3, type = "l", col = "blue")
legend("topright", legend = c(names(dataHPC2[,7:9])), lty = 1 , col = c("black", "red", "blue"))

plot(dataHPC2$FullDate, dataHPC2$Global_reactive_power, type = "l", xlab = "datetime", ylab = "Global_reactive_power")

dev.off()


######################################################
