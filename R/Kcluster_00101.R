library(cluster)

setwd("C:\\Users\\Gary\\Documents\\Business\\BCBSA\\NCCT")

# Load Defined first 2 columns only
data <- read.table("data.txt", header = T, sep="\t" ,fileEncoding="UTF-8-BOM", 
stringsAsFactors=FALSE, 
colClasses = c("character","character","numeric","numeric","numeric")
)

head(data)

data.101 <- subset(data, Code == '00101')
summary(data.101)

library(ggplot2)

pl1 <- ggplot(data.101, aes(Avg, SD, color = State)) +
       geom_point(size = 2) +
       ggtitle("Checking SD & Volumes", subtitle = "Club Data Dozen: pl1")
print(pl1)

pl2 <- ggplot(data.101, aes(Volumes, SD, color = State)) +
      geom_point(size = 2) +
      ggtitle("Checking SD & Volumes", subtitle = "Club Data Dozen: pl2")
print(pl2)

pl3 <- ggplot(data.101, aes(Volumes, Avg, color = State)) +
       geom_point(size = 2) +
       ggtitle("Checking Avg & Volumes", subtitle = "Club Data Dozen: pl3")
print(pl3)


set.seed(101)
# nstart means attempts to smooth prediction
data.cluster <- kmeans(data.101[, 4:5], 3, nstart = 100)

# print(data.cluster)
# d = dist(data.101[ ,3:5])
clusplot(data.101[, 4:5], data.cluster$cluster, color = T, shade = T, labels = 0, lines = 0)

# Plot to See Clusters
data.cluster$cluster <- as.factor(data.cluster$cluster)
ggplot(data.101, aes(Avg, SD, color = data.cluster$cluster)) + geom_point()


# Grouping is Vol:SD  [ , 3:4]
data.cluster <- kmeans(data.101[, 3:4], 3, nstart = 100)
data.cluster$cluster <- as.factor(data.cluster$cluster)
pl2.a <- ggplot(data.101, aes(Volumes, SD, color = data.cluster$cluster)) + geom_point()
multiplot(pl2, pl2.a, cols=2)


multiplot(pl1, pl2, cols=2)

# nstart means attempts to smooth prediction
data.clusterC <- kmeans(data.101c, 3, nstart = 20)

# print(data.cluster)
# d = dist(data.101[ ,3:5])
clusplot(data.101c, data.clusterC$cluster, color = T, shade = T, labels = 0, lines = 0)



# ----------------------
# Cataracts
# ----------------------
data.00501 <- subset(data, Code == '00501')
summary(data.00501)
head(data.00501)

data.00501 <- data.00501[!duplicated(data.00501), ]


plc1 <- ggplot(data.00501, aes(Avg, SD, color = State)) +
    geom_point(size = 2) +
    ggtitle("Checking SD & Volumes", subtitle = "Club Data Dozen: pl1")
print(plc1)

data.cluster501 <- kmeans(data.00501[, 4:5], 4, nstart = 20)

# print(data.cluster)
# d = dist(data.101[ ,3:5])

data.cluster501$cluster <- as.factor(data.cluster501$cluster)
plc2 <- ggplot(data.00501, aes(Avg, SD, color = data.cluster501$cluster)) + geom_point()

# Just using plot, not ggplot2
data.cluster501 <- kmeans(data.00501[, 4:5], 4, nstart = 100)
plot(data.00501[, 4:5], col =(data.cluster501$cluster + 1), main="Cataract K-Means result with 4 clusters", pch=20, cex=2)

# Elbow
mydata <- data.00501
wss <- (nrow(mydata) - 1) * sum(apply(mydata[,4:5], 2, var))
for (i in 2:15)
    wss[i] <- sum(kmeans(mydata[,4:5], centers=i)$withinss)

plot(1:15, wss, type="b", xlab="Number of Clusters",
     ylab="Within groups sum of squares",
     main="Assessing the Optimal Number of Clusters with the Elbow Method",
     pch=15, cex=1)

# Change Clusters
# Change x, y axis
library(dplyr)
data.00501 <- arrange(data.00501, State, Code, Volumes, Avg, SD)
k_count <- 7
data.cluster501 <- kmeans(data.00501[, 4:5], k_count, nstart = 100)
plot(data.00501[, 4:5], col =(data.cluster501$cluster + 1), main= paste("Cataract K-Means result with", as.character(k_count), "clusters"), pch=20, cex=2)
