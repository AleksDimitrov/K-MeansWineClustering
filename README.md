# K-MeansWineClustering

This project uses k-means clustering to find out how many groups of wines exist based on a dataset of 178 wines that vary in 13 different features. Each of these features relates to some aspect of the wine's chemical composition. The question is if we can detect varietal differences based only on these chemical properties.

Getting Started:
To get started with this project, you'll need to have the following packages installed:

tidyverse
caret

You can install these packages using the following command:

install.packages(c("tidyverse", "caret"))
In addition, you'll need to have access to the data file wine.csv.

Running the Code:
The code for this project is contained in the wine_clustering.R file. To run the code, open the file in your R environment and run each code segment in turn.

The code first scales the data and fits a k-means model with k = 5. The resulting clusters are plotted with alcohol on the x and flavanoids on the y. A copy is made of the original data frame to assign the clusters back to as we're going to use the scaled data again.

The code then uses the elbow method to figure out the optimal k. An empty data frame is created, and a for loop is used to fit a model for k values ranging from 1 to 10. The within-column variation is calculated, and the value and the k value are added to the empty data frame. An elbow plot is created to determine the optimal k value.

Based on the elbow plot, the code refits the single model with k = 3, assigns clusters back to the data, and re-plots, coloring by cluster.

Results:
The k-means model with k = 3 does a better job at clustering the data than the previous version where k = 5. This model can help determine how similar a new wine product will be to existing ones based on chemical properties (alcohol and flavanoids in this case).
