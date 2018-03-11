
setwd("C:\\Users\\Gary\\Documents\\CMS\\ClubMed\\")


sessions <- read.delim2("IL_Cataracts.txt", header = T, sep="\t" ,fileEncoding="UTF-8-BOM", 
                      stringsAsFactors=FALSE, 
                      colClasses = c("integer","character","character","character","character","character","character","character","character",
                                     "character","character","character","character","character","character",
                                     "character","character","character","character","integer","integer","integer",
                                     "numeric","numeric","numeric","numeric","numeric","numeric")
)
                              
sessions.step1 <- sessions[ ,c(1,2,3,11,16,17,20,23)]
names(sessions.step1) <- c("NPI", "Last_Organization","FirstName","ZipCode","FacilType","Code","NbrServices","MedicareAllowedAmt")

head(sessions.step1)

sessions.step1$TotalDollars <- sessions.step1$NbrServices * sessions.step1$MedicareAllowedAmt

cor(sessions.step1$NbrServices, sessions.step1$MedicareAllowedAmt)
cor(sessions.step1$NbrServices, sessions.step1$TotalDollars)

plot(sessions.step1$NbrServices, sessions.step1$MedicareAllowedAmt, main="A Scatter Plot",
     xlab="Nbr of Services", ylab="Medicare Amount")


sessions.step2 <- subset(sessions.step1, FacilType == 'O')
cor(sessions.step2$NbrServices, sessions.step2$MedicareAllowedAmt)

library(ggplot2)

png <- ggplot(data=sessions.step1, aes(x=FacilType, y=factor(MedicareAllowedAmt), fill=FacilType)) +
    geom_bar(stat="identity") +
    xlab("Facility Code") + ylab("Total Spent") +
    ggtitle("Cataracts", subtitle = "All Illinois Providers\n") 

ggsave("IL_Cotaracts.png", plot = png, width = 8, height = 10, dpi = 600)

# -----------------------------
# Code Types
ggplot(data=sessions.step1, aes(x=NbrServices, y=MedicareAllowedAmt, fill=Code)) +
    geom_line(aes(color=Code)) +
    geom_point(aes(color=Code), size=2) +
    xlab("Services") + ylab("Medicare $ Paid") +
    scale_fill_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")) +
    ggtitle("Cataracts - (By Code)", subtitle = "All Illinois Providers\n") 

# -----------------------------
# Split out Code 66821 & 66982
sessions.66821 <- subset(sessions.step1, Code == '66821')
head(sessions.66821)

cor(sessions.66821$NbrServices, sessions.66821$MedicareAllowedAmt)


sessions.66982 <- subset(sessions.step1, Code == '66982')
head(sessions.66982)

cor(sessions.66982$NbrServices, sessions.66982$MedicareAllowedAmt)


# -----------------------------
# Facility & Code Types

library(dplyr)
gd <- sessions.step1 %>% 
    group_by(FacilType, Code) %>% 
    summarize(
        AvgNbrServices = mean(NbrServices),
        AvgMedicarePayment = mean(MedicareAllowedAmt)
    )


library(gridExtra)
pl1 <- ggplot(data=gd, aes(x=AvgNbrServices, y=AvgMedicarePayment, fill=Code)) +
    geom_line(aes(color=Code)) +
    geom_point(aes(color=Code), size=2) +
    xlab("Services") + ylab("Medicare $ Paid") +
    scale_fill_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")) +
    ggtitle("Cataracts - (By Code)", subtitle = "All Illinois Providers\n") 

pl2 <- ggplot(data=gd, aes(x=AvgNbrServices, y=AvgMedicarePayment, fill=FacilType)) +
    geom_line(aes(color=FacilType)) +
    geom_point(aes(color=FacilType), size=2) +
    xlab("Services") + ylab("Medicare $ Paid") +
    scale_fill_manual(values=c("#E69F00", "#56B4E9", "#009E73", "#F0E442", "#0072B2")) +
    ggtitle("Cataracts - (By Facility)", subtitle = "All Illinois Providers\n") 

grid.arrange(pl1, pl2, ncol=2)
