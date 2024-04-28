# Read the data
data <- read.csv("C:/Users/user/OneDrive/Study@IIITD/4th Semester/Econometrics/Eco Project/merged_table.csv")

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
write.csv(data, file = "winsorized_data.csv", row.names = FALSE)
