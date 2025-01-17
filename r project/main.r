#PACKAGES
install.packages("pacman")
install.packages("fdth")

#load the package
library(pacman)  # No message.
library(fdth)

pacman::p_load(pacman, dplyr, GGally, ggplot2, ggthemes, 
               ggvis, httr, lubridate, plotly, rio, rmarkdown, shiny, 
               stringr, tidyr) 

# Load/unload base packages manually
library(datasets)

# CLEAN UP

# Clear packages
p_unload(dplyr, tidyr, stringr) # Clear specific packages
p_unload(all)  # Easier: clears all add-ons
detach("package:datasets", unload = TRUE)  # For base

# Clear console
cat("\014")  # ctrl+L

#=====CODE=====#

#import data
stores_data <- import("C:/Users/Todor/Desktop/R PROJECT/Stores.csv")

head(stores_data)
summary(stores_data)

#frequency table for store area data
storeArea_duration <- stores_data$Store_Area
min_area <- min(storeArea_duration)
max_area <- max(storeArea_duration)
R_area <- max_area - min_area
k_area <- 1 + 3.322 * log10(896)
i_area <- R_area / 11
table_area <- fdt(storeArea_duration, start = 770, end = 2255, h=135)
summary(table_area)
table_area

#II
n = length(storeArea_duration)
sort(storeArea_duration)
breaks1 = seq(770, 2255, by=135)
d.int = cut(storeArea_duration, breaks1, right=FALSE)
freq = table(d.int)
Rfreq = freq/n
Cumfreq = cumsum(freq)
R_Cumfreq = cumsum(freq)/n
R_Cumfreq2 = cumsum(Rfreq)
Pfreq = Rfreq*100
P_Cumfreq = R_Cumfreq*100
d.table = cbind(freq,Rfreq, Cumfreq, Pfreq, P_Cumfreq)
summary(d.table)
cbind(freq,Rfreq, Cumfreq, Pfreq, P_Cumfreq)

#histogram
mid = c()
for (i in 1:length(breaks1)-1)
{mid = c(mid, (breaks1[i]+breaks1[i+1])/2)} # определување на средните точки

h1 = hist(storeArea_duration, right = FALSE, breaks = breaks1, col = "orange", 
          main = "Порвшина", xlab = "d", ylab = "честоти")
lines(mid,freq)
h1$counts = h1$counts / sum(h1$counts)
plot(h1, freq = TRUE, col = "grey",ylab = "Релативни фреквенции",
     xlab = "средни точки", main = "Неделни хипотекарни каматни стапки")

#pie chart
 procent_freq = paste(Pfreq,"%",sep = "")
 procent_freq
 pie(Pfreq,labels = procent_freq, main = "Честоти во проценти")


#polygon
P_Cumfreq0 = c(0, P_Cumfreq)
plot(breaks1, P_Cumfreq0, axes = F,
     main = "Полигон на кумулативни честоти во % (Ogive)",
     xlab = "интервали",
     ylab = "Кумулативни честоти %")
axis(side = 1, at = breaks1)
axis(side = 2)
lines(breaks1, P_Cumfreq0) 

#frequency table for available items
items_duration <- stores_data$Items_Available
min_items <- min(items_duration)
max_items <- max(items_duration)
R_items <- max_items - min_items
k_items <- 1 + 3.322 * log10(896)
i_items <- R_items / 11
table_items <- fdt(items_duration, start = 920, end = 2680, h=160)
table_items
summary(table_items)


n = length(items_duration)
sort(items_duration)
breaks1 = seq(920, 2680, by=160)
d.int = cut(items_duration, breaks1, right=FALSE)
freq = table(d.int)
Rfreq = freq/n
Cumfreq = cumsum(freq)
R_Cumfreq = cumsum(freq)/n
R_Cumfreq2 = cumsum(Rfreq)
Pfreq = Rfreq*100
P_Cumfreq = R_Cumfreq*100
d.table = cbind(freq,Rfreq, Cumfreq, Pfreq, P_Cumfreq)
d.table
summary(d.table)

#histogram
mid = c()
for (i in 1:length(breaks1)-1)
{mid = c(mid, (breaks1[i]+breaks1[i+1])/2)} # определување на средните точки

h1 = hist(items_duration, right = FALSE, breaks = breaks1, col = "orange", 
          main = "Достапни артикли", xlab = "d", ylab = "честоти")
lines(mid,freq)

#pie chart
procent_freq = paste(Pfreq,"%",sep = "")
procent_freq
pie(Pfreq,labels = procent_freq, main = "Честоти во проценти")

#polygon
P_Cumfreq0 = c(0, P_Cumfreq)
plot(breaks1, P_Cumfreq0, axes = F,
     main = "Полигон на кумулативни честоти во % (Ogive)",
     xlab = "интервали",
     ylab = "Кумулативни честоти %")
axis(side = 1, at = breaks1)
axis(side = 2)
lines(breaks1, P_Cumfreq0) 


#steam and leaf for another data set
electric_car <- import("C:/Users/Todor/Desktop/R PROJECT/ElectricCarData_Clean.csv")
stem(electric_car$AccelSec)


#rasejuvanje
plot(storeArea_duration, items_duration, pch=1,
     main = "Површина на продавница наспроти достапните артикли",
     xlab = "Површина (во јарди квадратни)",
     ylab = "Достапни артикли")

plot(storeArea_duration, stores_data$Store_Sales, pch=20,
     main = "Површина на продавница наспроти продажбата",
     xlab = "Површина (во јарди квадратни)",
     ylab = "Приходи (US$)")

#summary of data
summary(stores_data)

#mode
mfv(storeArea_duration)
mfv(items_duration)

#mean
mean(storeArea_duration)
mean(items_duration)

#R
R_area
R_items

#variance and deviation
sd(storeArea_duration)
var(storeArea_duration)

sd(items_duration)
var(items_duration)

#coefficient of variance
CV_area <- (sd(storeArea_duration) / mean(storeArea_duration)) * 100
CV_area
CV_items <- (sd(items_duration) / mean(items_duration)) * 100
CV_items

#coefficient of correlation
cor(storeArea_duration, items_duration)
cor(customer_count, stores_data$Store_Sales)
cor(storeArea_duration, stores_data$Store_Sales)

#daily customer count / interval of confidence
customer_count <- stores_data$Daily_Customer_Count
avg <- mean(customer_count)
disp <- var(customer_count)
stdev <- sd(customer_count)
n <- 896
error <- qnorm(0.975) * stdev/sqrt(n)
from <- avg - error
to <- avg + error

#testing
mi <- avg
n <- 60
z <- (820.98 - mi)/(stdev/sqrt(n))

#regression
cor(storeArea_duration, items_duration)
cor(storeArea_duration, stores_data$Store_Sales)

mod_first <- lm(storeArea_duration ~ items_duration)
summary(mod_first)
plot(storeArea_duration, items_duration)
abline(mod_first)

mod_sec <- lm(storeArea_duration ~ stores_data$Store_Sales)
summary(mod_sec)
plot(storeArea_duration, stores_data$Store_Sales)
abline(mod_sec)

