setwd("C:\\Users\\Gary\\Documents\\Data\\CMS")

library(RODBC)
dbhandle <- odbcDriverConnect('driver={SQL Server};server=sql2k804.discountasp.net;database=SQL2008R2_57153_cartridge;uid=sa1519;pwd=dballc')

cms_data <- sqlQuery(dbhandle, "set nocount on\n select * from [dbo].[cms_puf] where nppes_provider_state ='IL'",
                  stringsAsFactors = FALSE,
                  as.is = c(FALSE,TRUE, TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,
                            FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)
)

cms_data1 <- sqlQuery(dbhandle, "set nocount on\n SELECT b.[UA]
              ,[nppes_provider_zip]
              ,[nppes_provider_state]
              ,[line_srvc_cnt]
              ,[average_Medicare_allowed_amt]
              ,[stdev_Medicare_allowed_amt]
              ,[year_nbr]
              FROM [SQL2008R2_57153_cartridge].[dbo].[cms_puf] a
                 inner join [dbo].[zip_2010] b on substring(a.[nppes_provider_zip],1,5) = b.[ZCTA5]
                 where [nppes_provider_state] = 'IL' and [hcpcs_code] = '66984'",
           stringsAsFactors = FALSE,
                     as.is = c(FALSE, FALSE, FALSE,TRUE,TRUE,TRUE,TRUE)
)

odbcCloseAll()

# GitHub Example
library(RCurl)
x <- getURL("https://raw.githubusercontent.com/GaryGiuntoli/ClubMed/master/IL_Cataracts.txt", ssl.verifypeer=FALSE)
cataracts.il <- read.csv2(textConnection(x), header = T, sep = "\t")
rm(x)

head(cataracts.il)
#

# Select Columns, reduce memory size
cms_data.1 <- cms_data[ ,c(1,2,3,11,16,17,20,23,24,25,26,27,28,29)]
head(cms_data.1)
rm(cms_data)


# Manipulating Data
data.1 <- rnorm(n = 15, mean = 30, sd = 5)
data.2 <- rnorm(n = 15, mean = 32, sd = 4)
data.3 <- rnorm(n = 15, mean = 34, sd = 6)
data.df <- data.frame(cbind(data.1, data.2, data.3))
data.st <- stack(data.df)

anova.1 <- aov(values ~ ind, data = data.st)
summary(anova.1)
#


# -----------------------------------
# ANOVA
# -----------------------------------

cms_data.66984.12 <- subset(cms_data.1, hcpcs_code == '66984' & year_nbr == 2012)

nbr <- as.numeric(nrow(cms_data.66984.12))

datalist = list()

for (i in 1:nbr) {
  a <- cms_data.66984.12[i,7]
  b <- cms_data.66984.12[i,8]
  c <- cms_data.66984.12[i,9]
  
  dat <-  data.frame(rnorm(n = a, mean = b, sd = c))
  dat$ID <- paste(c("x", i), collapse="")
  datalist[[i]] <- dat
}

df.12 = do.call(rbind, datalist)
names(df.12) <- c("Avg","ID")

# 2012
anova.12 <- aov(Avg ~ ID, data = df.12)
summary(anova.12)

# Smaller Size
nbr <- as.numeric(nrow(cms_data.66984.12))

datalist = list()

for (i in 1:5) {
  a <- cms_data.66984.12[i,7]
  b <- cms_data.66984.12[i,8]
  c <- cms_data.66984.12[i,9]
  
  dat <-  data.frame(rnorm(n = a, mean = b, sd = c))
  dat$ID <- paste(c("x", i), collapse="")
  datalist[[i]] <- dat
}

df.12_10 = do.call(rbind, datalist)
names(df.12_10) <- c("Avg","ID")

anova.12_10 <- aov(Avg ~ ID, data = df.12_10)
summary(anova.12_10)

TukeyHSD(anova.12_10)

TUKEY <- TukeyHSD(anova.12_10)

plot(TUKEY)

boxplot(df.12_10$Avg ~ df.12_10$ID)


