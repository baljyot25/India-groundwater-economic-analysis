# Load required library
library(readr)
library(tidyr)
library(dplyr)
library(car)

# Read the data
data <- read.csv("C:/Users/user/OneDrive/Study@IIITD/4th Semester/Econometrics/Eco Project/merged_table.csv")

# Drop rows with missing values
data <- na.omit(data)

# Define independent variables
x <- data$SDP
x2 <- x^2
x3 <- x^3
x4 <- data$Gini

# Create polynomial features
X_poly <- cbind(x, x2, x3, x4)  # Including x4 (Gini) in the polynomial features

# Define dependent variable
y <- data$calcium

# Convert matrix to data frame
X_poly_df <- as.data.frame(X_poly)

# Fit the model
model <- lm(y ~ ., data = X_poly_df)

studentized_res <- rstudent(model)

print(studentized_res)

outliers <- which(abs(studentized_res) > 2)

outlier_data <- data[outliers, ]

print("Outliers detected:")


write_csv(outlier_data, "outliers.csv")


plot(data$SDP, data$calcium, main = "Groundwater Quality Indicator vs. SDP",
     xlab = "SDP", ylab = "Calcium", pch = 20, col = ifelse(1:nrow(data) %in% outliers, "red", "black"))
legend("topright", legend = c("Outliers", "Non-outliers"), col = c("red", "black"), pch = 20)

getwd()
