# Load required library
library(readr)
library(tidyr)
library(dplyr)
library(car)

# Read the data
data <- read.csv("C:/Users/user/OneDrive/Study@IIITD/4th Semester/Econometrics/Eco Project/data_without_outliers_cutoff_2.csv")

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

# Get coefficients and intercept
coefficients <- coef(model)
intercept <- coefficients[1]  # Intercept
coefficients <- coefficients[-1]  # Coefficients for the polynomial terms and the fourth variable
# Evaluate R-squared
r_squared <- summary(model)$r.squared
# Calculate standard errors, t-statistics, and p-values for coefficients
std_errors <- sqrt(diag(vcov(model)))  # Exclude intercept
t_stats <- coefficients / std_errors
p_values <- 2 * pt(abs(t_stats), df = length(y) - length(coefficients))  # Exclude intercept


# Print coefficients
cat("Intercept:", intercept, "\n")
cat("Coefficients:", coefficients, "\n")A
cat("R-squared:", r_squared, "\n")
# Print standard errors, t-stats, and p-values
cat("Standard Errors:", std_errors, "\n")
cat("T-Statistics:", t_stats, "\n")
cat("P-Values:", p_values, "\n")



