
library(RODBC)
dbhandle <- odbcDriverConnect('driver={SQL Server};server=sql2k804.discountasp.net;database=SQL2008R2_57153_cartridge;uid=sa1519;pwd=dballc')

cms_data <- sqlQuery(dbhandle, "set nocount on\n select * from [dbo].[cms_puf] where nppes_provider_state ='IL'",
                  stringsAsFactors = FALSE,
                  as.is = c(FALSE,TRUE, TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,TRUE,
                            FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE,FALSE)
)
odbcCloseAll()


library(RCurl)
x <- getURL("https://raw.githubusercontent.com/GaryGiuntoli/ClubMed/master/IL_Cataracts.txt", ssl.verifypeer=FALSE)
cataracts.il <- read.csv2(textConnection(x), header = T, sep = "\t")

rm(x)

head(cataracts.il)

cms_data.1 <- cms_data[ ,c(1,2,3,11,16,17,20,23,24,25,26,27,28,29)]
head(cms_data.1)
rm(cms_data)

#
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
cms_data.66984.13 <- subset(cms_data.1, hcpcs_code == '66984' & year_nbr == 2013)

nbr <- as.numeric(nrow(cms_data.66984.12))

datalist = list()

for (i in 1:nbr) {
  a <- cms_data.66984.12[i,7]
  b <- cms_data.66984.12[i,8]
  c <- cms_data.66984.12[i,9]
  
  dat <- data.frame(rnorm(n = a, mean = b, sd = c))
  dat$i <- paste(c("x", i), collapse="")
  datalist[[i]] <- dat
}

df.12 = do.call(rbind, datalist)

# -----------------------------------
# 2013

nbr <- as.numeric(nrow(cms_data.66984.13))

datalist = list()

for (i in 1:nbr) {
  a <- cms_data.66984.13[i,7]
  b <- cms_data.66984.13[i,8]
  c <- cms_data.66984.13[i,9]
  
  dat <- data.frame(rnorm(n = a, mean = b, sd = c))
  dat$i <- paste(c("x", i), collapse="")
  datalist[[i]] <- dat
}

df.13 = do.call(rbind, datalist)

names(df.12) <- c("Avg","ID")
names(df.13) <- c("Avg","ID")

# 2012
anova.12 <- aov(Avg ~ ID, data = df.12)
summary(anova.12)

TukeyHSD(anova.12)

# 2013
anova.13 <- aov(Avg ~ ID, data = df.13)
summary(anova.13)

TukeyHSD(anova.13)
