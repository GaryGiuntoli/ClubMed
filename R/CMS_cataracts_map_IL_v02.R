
setwd("C:\\Users\\Gary\\Documents\\Data\\CMS")

library(RODBC)
dbhandle <- odbcDriverConnect('driver={SQL Server};server=sql2k804.discountasp.net;database=SQL2008R2_57153_cartridge;uid=sa1519;pwd=dballc')

cms_data1 <- sqlQuery(dbhandle, "set nocount on\n SELECT b.[UA]
                      ,[nppes_provider_zip]
                      ,[nppes_provider_state]
                      ,[line_srvc_cnt]
                      ,[average_Medicare_allowed_amt]
                      ,[stdev_Medicare_allowed_amt]
                      ,[year_nbr]
                      FROM [SQL2008R2_57153_cartridge].[dbo].[cms_puf] a
                      inner join [dbo].[zip_2010] b on substring(a.[nppes_provider_zip],1,5) = b.[ZCTA5]
                      where [nppes_provider_state] = 'IL' and [hcpcs_code] = '66984' and year_nbr = 2012",
                      stringsAsFactors = FALSE,
                      as.is = c(FALSE, FALSE, FALSE,TRUE,TRUE,TRUE,TRUE)
)

msa <- sqlQuery(dbhandle, "set nocount on\n SELECT [zip_code], [state_abbr], [msa_code] FROM  [SQL2008R2_57153_cartridge].[dbo].[zips_msas] where [state_abbr] = 'IL'",
                stringsAsFactors = FALSE,
                as.is = c(TRUE, TRUE, TRUE)
)

odbcCloseAll()

options(tigris_use_cache = TRUE)
library(rgdal)
library(tigris)
zips <- zctas(cb = TRUE)

cms_data1$zip_code <- substr(cms_data1$nppes_provider_zip,1,5)

my_zips <- zips[zips$ZCTA5CE10 %in% cms_data1$zip_code, ]

df_il_J <- geo_join(my_zips, cms_data1, "ZCTA5CE10", "zip_code")

library(tigris)
library(sp)
library(tmap)

rds <- primary_roads()

library(tmap)      # package for plotting
library(tmaptools)
library(RColorBrewer)
# download shape (a little less detail than in the other scripts)
f <- tempfile()
download.file("http://www2.census.gov/geo/tiger/GENZ2010/gz_2010_us_050_00_20m.zip", destfile = f)
unzip(f, exdir = ".")
US <- read_shape("gz_2010_us_050_00_20m.shp")
US_IL <- US[(US$STATE %in% c("17")),]  


# Version 1
tm_shape(df_il_J, is.master = TRUE) + tm_borders(alpha = .5) +
  tm_fill(col = "line_srvc_cnt", style = "quantile", n = 5, palette = "Blues", title = "Provider Counts") +
  tm_shape(US_IL) + tm_borders(alpha = .5) +
  tm_shape(rds) + 
  tm_lines(col = "darkgrey") +
  tm_layout(bg.color = "ivory",
            title = "",
            title.position = c("left", "top"), title.size = 0, 
            legend.text.size = 2.5, 
            legend.width = 0.2, legend.height = 0.2) +
  tm_credits("Facilities\nData source: ClubMed",
             position = c(0.002, 0.002))

