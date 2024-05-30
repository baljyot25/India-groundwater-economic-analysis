data <- read.csv("Excels/merged_table.csv")
data$year <- factor(data$year, levels=2000:2018)
data <- na.omit(data)

model <- lm(formula = calcium ~ year + SDP*year + I(SDP^2)*year + I(SDP^3)*year + Gini*year, data = data)
print(summary(model))

n_obs <- nrow(data)
print(n_obs)
