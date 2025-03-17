# Predictive Maintenance Analysis

## Overview

This repository contains a comprehensive analysis of manufacturing data designed to support predictive maintenance initiatives. Utilizing a dataset with 10,000 observations, the project examines key variables—such as air temperature, process temperature, rotational speed, torque, tool wear, and machine failure labels—to uncover insights and develop predictive models. The primary objective is to anticipate machine failures, thereby reducing downtime and enhancing operational efficiency.

## Dataset

### Features

- **Air Temperature**
- **Process Temperature**
- **Rotational Speed**
- **Torque**
- **Tool Wear**
- **Machine Failure Labels** (encompassing five distinct failure modes)

## Methodology

### Data Collection and Preparation

Data is imported from an Excel file using the `readxl` package. The dataset required no additional cleaning prior to analysis.

Below is the corrected Markdown snippet with proper code block closures so that headings render normally and only the code appears inside grey boxes. You can copy and paste the snippet directly into your README file:

```markdown
# Data Import

```r
library(readxl)
data <- read_excel("dataset.xlsx")
```

## Exploratory Data Analysis (EDA)

Descriptive statistics and visualizations are generated to understand the data distribution and underlying patterns.

```r
# Descriptive Statistics
summary(data)

# Visualization Example: Histogram for Torque
library(ggplot2)
ggplot(data, aes(x = Torque)) + geom_histogram()
```

### Correlation Analysis

Correlation matrices and visualizations are utilized to explore the relationships between features.

```r
# Correlation Matrix and Visualization
library(corrplot)
corr_matrix <- cor(data)
corrplot(corr_matrix)
```

### Predictive Modeling

#### Data Splitting

The dataset is divided into training and testing subsets using a 70/30 split to ensure robust model evaluation.

```r
library(caret)
set.seed(123)
trainIndex <- createDataPartition(data$Failure, p = 0.7, list = FALSE)
train <- data[trainIndex, ]
test <- data[-trainIndex, ]
```

#### Logistic Regression

A logistic regression model is trained to predict machine failure.

```r
model <- train(Failure ~ ., data = train, method = "glm", family = "binomial")
```

#### Model Evaluation

Model performance is assessed using a confusion matrix, along with ROC and AUC analysis.

```r
# Predictions and Confusion Matrix
predictions <- predict(model, test)
confusionMatrix(predictions, test$Failure)

# ROC and AUC Analysis
library(pROC)
roc_curve <- roc(test$Failure, as.numeric(predictions))
auc(roc_curve)
plot(roc_curve)
```

## Insights & Applications

- **Critical Failure Factors:** Identification of key variables influencing machine failures.
- **Proactive Maintenance:** Enhanced predictive capabilities allow for proactive maintenance strategies.
- **Operational Efficiency:** Reduced downtime and improved overall operational efficiency.

## Technologies

- **Programming Language:** R
- **Key Packages:** `readxl`, `ggplot2`, `corrplot`, `caret`, `pROC`

## Installation & Usage

1. **Clone the Repository:**

   ```bash
   git clone https://github.com/shahan-perera-30/Predictive-Maintenance-Analysis.git
   ```

2. **Install Required Packages:**

   ```r
   install.packages(c("readxl", "ggplot2", "corrplot", "caret", "pROC"))
   ```

3. **Run Analysis Scripts:**

   Execute the provided R scripts to replicate the analysis and generate the corresponding outputs.

## Contributing

Contributions, improvements, and suggestions are welcome. Please feel free to open issues or submit pull requests.

## Full Report

The full project report is available in PDF format. Click the link below to download:

[Download the Full Report](report.pdf)
