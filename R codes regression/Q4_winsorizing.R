data <- read.csv("Excels/merged_table.csv")

# Drop rows with missing values
data <- na.omit(data)

# Define a function for winsorizing outliers
winsorize <- function(x, trim = 0.05) {
  q <- quantile(x, probs = c(trim, 1 - trim), na.rm = TRUE)
  x[x < q[1]] <- q[1]
  x[x > q[2]] <- q[2]
  return(x)
}

# Winsorize outliers in relevant columns
data$SDP <- winsorize(data$SDP)
data$calcium <- winsorize(data$calcium)
data$Gini <- winsorize(data$Gini)

# Write the winsorized data to a new CSV file
write.csv(data, file = "Excels/winsorized_data.csv", row.names = FALSE)


library(readr)
library(tidyr)
library(dplyr)
library(car)

# Read the data
data <- read.csv("Excels/winsorized_data.csv")

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

n_obs <- nrow(data)
print(n_obs)
