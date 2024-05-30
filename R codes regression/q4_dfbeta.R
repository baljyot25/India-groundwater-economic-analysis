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

# Calculate residuals
residuals <- residuals(model)

# Calculate hat values (leverage)
hat_values <- hatvalues(model)

# Calculate variance of residuals
sigma_hat <- sqrt(sum(residuals^2) / (length(residuals) - length(coef(model))))

# Calculate DFBETA
dfbeta <- dfbetas(model)
dfbeta_std <- apply(dfbeta, 2, function(x) x * sigma_hat / sqrt(sum(x^2)))
cutoff_dfbeta <- 2 / sqrt(nrow(X_poly_df))

# Find influential observations based on DFBETA
influential_dfbeta <- apply(abs(dfbeta_std), 1, max) > cutoff_dfbeta
influential_observations_dfbeta <- rownames(X_poly_df)[influential_dfbeta]


# Print influential observations based on DFBETA
cat("Influential observations based on DFBETA (cutoff =", cutoff_dfbeta, "):\n")
print(influential_observations_dfbeta)

# Write the data to a CSV file
write.csv(data[influential_observations_dfbeta, ], "data_with_influential_observations_dfbeta.csv", row.names = FALSE, na = "")

influential_data <- data[influential_observations_dfbeta, ]
summ_data <- summary(influential_data)

print(summ_data)


# Plot the data with influential observations highlightedA
plot(data$SDP, data$calcium, main = "Groundwater Quality vs. SDP",
     xlab = "SDP", ylab = "Calcium", pch = 20, col = ifelse(rownames(data) %in% influential_observations_dfbeta, "red", "black"))
legend("topright", legend = c("Influential", "Non-Influential"), col = c("red", "black"), pch = 20)