# import libraries ####
library (dplyr)
library(readxl)
library(ggplot2)
library(corrplot)
library(ggcorrplot)
library(caret)
library(pROC)

# import dataset ####
predictivemaintenance_data <- read_excel("/Users/shahanperera/Documents/Data Science/Midterm Project .xlsx")

# cleaning this dataset was not necessary due to organized data as is. 
# deleting some of the columns like TWF, HDF, PWF, OSF, RNF due to unnecessary and a lack of important data. 
predictivemaintenance_data <- predictivemaintenance_data[,-10:-14]

# Descriptive Statistics ####
# using the summary function calculates all of the specific descriptive statistics necessary (numerical values)
summary(predictivemaintenance_data)

# Histograms ####
hist_color <- c("lightblue", "red", "green", "orange", "purple")

ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Air temperature [K]`)) +
  geom_histogram(fill = "skyblue", color = "black", bins = 30) +
  labs(title = "Air Temperature Distribution", x = "Temperature (K)", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = hist_color[1])

ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Process temperature [K]`, fill = "Process Temperature")) +
  geom_histogram(color = "red", bins = 30) +
  labs(title = "Process Temperature Distribution", x = "Temperature (K)", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = hist_color[2])

ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Rotational speed [rpm]`, fill = "Rotational Speed")) +
  geom_histogram(color = "green", bins = 30) +
  labs(title = "Rotational Speed Distribution", x = "Speed (rpm)", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = hist_color[3])

ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Torque [Nm]`, fill = "Torque")) +
  geom_histogram(color = "orange", bins = 30) +
  labs(title = "Torque Distribution", x = "Torque (Nm)", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = hist_color[4])

ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Tool wear [min]`, fill = "Tool Wear")) +
  geom_histogram(color = "purple", bins = 30) +
  labs(title = "Tool Wear Distribution", x = "Tool Wear (min)", y = "Frequency") +
  theme_minimal() +
  scale_fill_manual(values = hist_color[5])

# Bar Plots ####

ggplot(predictivemaintenance_data, aes(x = Type)) +
  geom_bar(fill = "skyblue") +
  labs(title = "Count of Type", x = "Type", y = "Count") +
  theme_minimal()

ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Machine failure`)) +
  geom_bar(fill = "lightgreen") +
  labs(title = "Count of Machine Failure", x = "Machine Failure", y = "Count") +
  theme_minimal()

# Scatter Plots ####

# Scatter plot: Air Temperature vs. Process Temperature
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Air temperature [K]`, y = predictivemaintenance_data$`Process temperature [K]`, color = "Air Temperature vs. Process Temperature")) + 
  geom_point() + 
  labs(x = "Air Temperature (K)", y = "Process Temperature (K)") + 
  ggtitle("Scatter Plot: Air Temperature vs. Process Temperature")

# Scatter plot: Rotational Speed vs. Torque
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$`Rotational speed [rpm]`, y = predictivemaintenance_data$`Torque [Nm]`, color = "Rotational Speed vs. Torque")) + 
  geom_point() + 
  labs(x = "Rotational Speed (rpm)", y = "Torque (Nm)") + 
  ggtitle("Scatter Plot: Rotational Speed vs. Torque")

# Box Plots ####
# Box plot: Air Temperature by Type
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$Type, y = predictivemaintenance_data$`Air temperature [K]`, fill = Type)) +
  geom_boxplot() +
  labs(title = "Box Plot: Air Temperature by Type", x = "Type", y = "Air Temperature (K)") +
  theme_minimal()

# Box plot: Process Temperature by Type
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$Type, y = predictivemaintenance_data$`Process temperature [K]`, fill = Type)) +
  geom_boxplot() +
  labs(title = "Box Plot: Process Temperature by Type", x = "Type", y = "Process Temperature (K)") +
  theme_minimal()

# Box plot: Rotational Speed by Type
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$Type, y = predictivemaintenance_data$`Rotational speed [rpm]`, fill = Type)) +
  geom_boxplot() +
  labs(title = "Box Plot: Rotational Speed by Type", x = "Type", y = "Rotational Speed (rpm)") +
  theme_minimal()

# Box plot: Torque by Type
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$Type, y = predictivemaintenance_data$`Torque [Nm]`, fill = Type)) +
  geom_boxplot() +
  labs(title = "Box Plot: Torque by Type", x = "Type", y = "Torque (Nm)") +
  theme_minimal()

# Box plot: Tool Wear by Type
ggplot(predictivemaintenance_data, aes(x = predictivemaintenance_data$Type, y = predictivemaintenance_data$`Tool wear [min]`, fill = Type)) +
  geom_boxplot() +
  labs(title = "Box Plot: Tool Wear by Type", x = "Type", y = "Tool Wear (min)") +
  theme_minimal()

# Correlation Analysis and Heat Map ####

#Correlation Analysis
correlation_matrix <- cor(select(predictivemaintenance_data, -c(UDI, `Product ID`, Type, `Machine failure`)))

corrplot(correlation_matrix, method = "color", type = "upper", order = "hclust", 
         tl.col = "black", tl.srt = 45, addCoef.col = "black", number.cex = 0.7)

# Heatmap using the correlation matrix
heatmap(correlation_matrix, 
        main = "Correlation Heatmap", 
        col = colorRampPalette(c("blue", "white", "red"))(100))

# Machine Learning Algorithms ####
# Data Preprocessing
# Assuming 'Machine_failure' is the target variable (response)
# Convert 'Type' to a factor variable
predictivemaintenance_data$Type <- as.factor(predictivemaintenance_data$Type)

# Split data into training and testing sets (80% training, 20% testing)
set.seed(123)  # for reproducibility
trainIndex <- createDataPartition(predictivemaintenance_data$`Machine failure`, p = 0.8, 
                                  list = FALSE, times = 1)
train_data <- predictivemaintenance_data[trainIndex, ]
test_data <- predictivemaintenance_data[-trainIndex, ]

test_dataWithoutID <- test_data[,-2]
# Model Training: Logistic Regression
colnames(train_data)
model <- train(`Machine failure` ~ Type + `Air temperature [K]` + `Process temperature [K]` +
                 `Rotational speed [rpm]` + `Torque [Nm]` + `Tool wear [min]`, data = train_data, method = "glm", family = "binomial")
#model <- train(`Machine failure` ~ ., data = test_data, method = "glm", family = "binomial")

# Model Evaluation
predictions <- predict(model, test_data)
predictions <- factor(round(predictions), levels = levels(test_data$`Machine failure`))
confusionMatrix(predictions, test_data$`Machine failure`)
table(predictions == test_data$`Machine failure`)

# I first preprocessed the data by converting the 'Type' variable to a factor and splitting the dataset into training and testing sets.
# Then I trained a logistic regression model using the train() function from the caret package.
# After training, I made predictions on the test set and evaluate the model's performance using confusion matrix analysis.

