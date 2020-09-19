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

NEI_BC <- subset(NEI, fips == "24510" & type == "ON-ROAD")
NEI_LA <- subset(NEI, fips == "06037" & type == "ON-ROAD")
plot_BC <- with(NEI_BC, tapply(Emissions, year, sum, na.rm = TRUE))
plot_LA <- with(NEI_LA, tapply(Emissions, year, sum, na.rm = TRUE))
df <- data.frame(year = rep(unique(NEI$year), 2), 
                 type = rep(c("BaltimoreCity", "LosAngeles"), each = 4),
                 value = c(plot_BC, plot_LA))

png(filename = "plot6.png", width = 480, height = 480, units = "px")

qplot(year, value, data = df, facets = .~type,
      main = "Total PM2.5 emission from motor vehicle sources by year in the BC and LA",
      xlab = "Year", ylab = "Total emission (tons)")

dev.off()
