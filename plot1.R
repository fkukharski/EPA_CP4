zip_file_URL <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2FNEI_data.zip"
zip_file <- "exdata_data_NEI_data.zip"
rds_file1 <- "Source_Classification_Code.rds"
rds_file2 <- "summarySCC_PM25.rds"

if (!(file.exists(rds_file1) & file.exists(rds_file2))){
        if (!file.exists(zip_file)){
                download.file(zip_file_URL, zip_file)
        }
        unzip(zip_file, overwrite = FALSE)
}

NEI <- readRDS(rds_file2)

max_by_year <- with(NEI, tapply(Emissions, year, sum, na.rm = TRUE))

png(filename = "plot1.png", width = 480, height = 480, units = "px")

plot(names(max_by_year), max_by_year, type = "b", 
     main = "Total PM2.5 emission by year", 
     xlab = "Year", ylab = "Total emission (tons)")

dev.off()
