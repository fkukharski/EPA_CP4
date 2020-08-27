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
SCC <- readRDS(rds_file1)
SCC_tmp <- subset(SCC, grepl("Combustion", SCC.Level.One) & 
                  (grepl("Coal", SCC.Level.Three) | grepl("Coal", SCC.Level.Four)), 
                  select = SCC)
NEI_tmp <- subset(NEI, SCC %in% SCC_tmp$SCC)

max_by_year <- with(NEI_tmp, tapply(Emissions, year, sum, na.rm = TRUE))
plot(names(max_by_year), max_by_year, type = "b", 
     main = "Emissions from coal combustion-related sources", 
     xlab = "Year", ylab = "Total emission (tons)")
