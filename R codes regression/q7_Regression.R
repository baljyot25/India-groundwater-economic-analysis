# Function to classify states into regions
classify_region <- function(state) {
  if (state %in% c('Chandigarh', 'Delhi', 'Haryana', 'Himachal Pradesh', 'Jammu And Kashmir', 'Punjab', 'Rajasthan')) {
    return('NORTHERN REGION')
  } else if (state %in% c('Arunachal Pradesh', 'Assam', 'Manipur', 'Meghalaya', 'Mizoram', 'Nagaland', 'Tripura')) {
    return('NORTH-EASTERN REGION')
  } else if (state %in% c('Andaman And Nicobar Islands', 'Bihar', 'Jharkhand', 'Odisha', 'West Bengal')) {
    return('EASTERN REGION')
  } else if (state %in% c('Chhattisgarh', 'Madhya Pradesh', 'Uttar Pradesh', 'Uttarakhand')) {
    return('CENTRAL REGION')
  } else if (state %in% c('The Dadra And Nagar Haveli And Daman And Diu','Dadra & Nagar Haveli', 'Daman & Diu', 'Goa', 'Gujarat', 'Maharashtra')) {
    return('WESTERN REGION')
  } else if (state %in% c('Andhra Pradesh', 'Karnataka', 'Kerala', 'Lakshadweep', 'Pondicherry', 'Tamil Nadu', 'Telangana','Tamilnadu')) {
    return('SOUTHERN REGION')
  } else {
    print(paste("Unknown state:", state))
    return('Unknown')
  }
}

# Read the data
data <- read.csv("Excels/merged_table.csv")

# Classify states into regions
data$region <- sapply(data$state, classify_region)

# Convert 'region' into a factor with specific levels
data$region <- factor(data$region, levels = c("NORTHERN REGION", "NORTH-EASTERN REGION", "EASTERN REGION", "CENTRAL REGION", "WESTERN REGION", "SOUTHERN REGION"))

# Remove rows with missing values
data <- na.omit(data)

# Fit the model with regions
model <- lm(formula = calcium ~ region + SDP*region + I(SDP^2)*region + I(SDP^3)*region + Gini*region, data = data)

# Print model summary
print(summary(model))
