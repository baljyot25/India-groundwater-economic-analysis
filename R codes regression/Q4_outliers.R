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

# Calculate studentized residuals
studentized_res <- rstudent(model)

# Identify outliers
outliers <- which(abs(studentized_res) > 2)

# Plot the graph
plot(data$SDP, data$calcium, main = "Groundwater Quality Indicator vs. SDP",
     xlab = "SDP", ylab = "Calcium", pch = 20, col = "black")
legend("topright", legend = "All data", col = "black", pch = 20)

# Highlight outliers in red color
points(data$SDP[outliers], data$calcium[outliers], pch = 20, col = "red")
legend("topright", legend = "Outliers", col = "red", pch = 20)

# Remove outliers
data <- data[-outliers, ]

# Write data without outliers to a file
write.csv(data, "Excels/data_without_outliers_cutoff_2.csv", row.names = FALSE)

# Print summary statistics
summary(data)
