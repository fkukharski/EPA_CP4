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
NEI_BC <- subset(NEI, fips == 24510)


df <- data.frame(year = rep(unique(NEI_BC$year), 4), 
                 type = rep(sort(unique(NEI_BC$type)), each = 4))
df$value <- as.numeric(with(NEI_BC, tapply(Emissions, list(year, type), sum, na.rm = TRUE)))
qplot(year, value, data = df, facets = .~type,
      main = "Total PM2.5 emission by year and type in the BC",
      xlab = "Year", ylab = "Total emission (tons)")
