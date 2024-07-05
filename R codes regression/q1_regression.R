# Read data from CSV
data <- read.csv("Excels/merged_table.csv")

# Remove rows with missing values
data <- na.omit(data)

# Define the variables
X <- data$SDP  # Feature matrix
y <- data$calcium  # Target variable

# Fit the linear regression model
model <- lm(calcium ~ SDP, data=data)

# Print model summary
summary(model)

# Calculate residuals
residuals <- residuals(model)

# Print model statistics
cat("Model Statistics:\n")
print(summary(model))

# Print sum of residuals
cat("Sum of Residuals:", sum(residuals), "\n")
