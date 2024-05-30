# Load required library
library(readr)
library(tidyr)
library(dplyr)
library(car)

# Read the data
data <- read.csv("Excels/merged_table.csv")

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

# Summarize the model
summ_model <- summary(model)
print(summ_model)

# Plot the graph
plot(data$SDP, data$calcium, main = "Groundwater Quality Indicator vs. SDP",
     xlab = "SDP", ylab = "Calcium", pch = 20, col = "black")

# Add regression line
lines(sort(data$SDP), predict(model)[order(data$SDP)], col = "blue",lwd=2)
