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

# Calculate residuals
residuals <- residuals(model)

# Calculate hat values (leverage)
hat_values <- hatvalues(model)

# Calculate variance of residuals
sigma_hat <- sqrt(sum(residuals^2) / (length(residuals) - length(coef(model))))

# Calculate DFFITS
dffits <- dffits(model)
dffits_std <- dffits * sigma_hat / sqrt(hat_values)
cutoff_dffits <- 2 * sqrt((length(coef(model)) + 1) / nrow(X_poly_df))

# Find influential observations based on DFFITS
influential_dffits <- abs(dffits_std) > cutoff_dffits
influential_observations_dffits <- rownames(X_poly_df)[influential_dffits]

# Print influential observations based on DFFITS
cat("Influential observations based on DFFITS (cutoff =", cutoff_dffits, "):\n")
print(influential_observations_dffits)

# Write influential observations to a CSV file
write.csv(data[influential_observations_dffits, ], "influential_observations_dffits_with_NA.csv", row.names = FALSE)

# Plot the data with influential observations highlighted
plot(data$SDP, data$calcium, main = "Groundwater Quality vs. SDP",
     xlab = "SDP", ylab = "Calcium", pch = 20, col = ifelse(rownames(data) %in% influential_observations_dffits, "red", "black"))
legend("topright", legend = c("Influential", "Non-Influential"), col = c("red", "black"), pch = 20)

