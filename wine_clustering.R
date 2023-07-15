# File: wine_clustering.py
# Author: Aleksander Dimitrov
# Description: This project uses k-means clustering to find out how many groups of wines
# exist based on a dataset of 178 wines that vary in 13 different features.
# Each of these features relate to some aspect of the wine's chemical composition.
# Given there are lots of different wine varieties, the question is if we can
# detect varietal differences based only on these chemical properties.

# Packages and data

library(tidyverse)
library(caret)
wine <- read_csv("https://docs.google.com/spreadsheets/d/1QA96h2A_i35FBKCrlmm8_QPgdcUYSZlTDeNFSUl8sEc/gviz/tq?tqx=out:csv")

# Scale your data

wine_scaled <- data.frame(scale(wine))

# Fit a k-means model with k= 5 and plot the resulting clusters
# with alcohol on the x and flavanoids on the y.
# The points are colored by cluster and cluster isn't a continuous variable.
# A copy is made of the original data frame to assign the clusters back to
# as we're going to use the scaled data again.

wine_copy <- wine

wine_kmeans_scaled <- kmeans(wine_scaled, centers = 5, nstart = 20)

wine_kmeans_scaled_clusters <- factor(wine_kmeans_scaled$cluster) # extract from km_scaled object
wine$cluster <- wine_kmeans_scaled_clusters # add back to original data frame

# Plot using color as cluster so it colors our points by cluster assignment

ggplot(wine,
       aes(x = alcohol, y = flavanoids, color = cluster)) +
  geom_point()

# At this point, I think that there are a few too many clusters.
# I would probably consider there to be about 3 distinct groups,
# vaguely in the upper left, upper right, and bottom of the plot.

# Calculate the total within-cluster sum of squares from your above model.

print(wine_kmeans_scaled$tot.withinss) # or the total across clusters

# We're now going to use the elbow method to figure out our optimal k.
# First we make our empty data frame with two columns and 10 rows.
# One column is named for the within column variation and the other for the number of k.

k_means_df <- data.frame(matrix(ncol = 2, nrow = 10))
colnames(k_means_df) <- c('k', 'wi_ss')

# We use a for loop to fit a model for k values ranging from 1 to 10.
# We fit the model for each value in i, calculate the within-column variation,
# and then add that value and the k value into our empty data frame.

for(i in 1:10) { # we'll run k from 1 to 10
  km <- kmeans(wine_scaled, centers = i) # to run k through the range
  wi_ss <- km$tot.withinss # get total within-cluster sum of squares
  k_means_df[i, 'k'] <- i
  k_means_df[i, 'wi_ss']  <- wi_ss
}

# Make an elbow plot

ggplot(k_means_df,
       aes(x = k, y = wi_ss)) +
  geom_line() +
  labs(x = 'number of clusters', y = 'total within-cluster sum of squares') +
  theme_classic()

# Based on this, what value k should you use?
# We refit the single model with this value, assign clusters back to the data,
# and replot, coloring by cluster

# We could say that the number of clusters where we stop getting major reductions
# is at about 3, so k = 3.

wine_kmeans_scaled2 <- kmeans(wine_scaled, centers = 3, nstart = 20)

wine_kmeans_scaled_clusters2 <- factor(wine_kmeans_scaled2$cluster) # extract from km_scaled object
wine_copy$cluster <- wine_kmeans_scaled_clusters2 # add back to original data frame

# Plot using color as cluster so it colors our points by cluster assignment
ggplot(wine_copy,
       aes(x = alcohol, y = flavanoids, color = cluster)) +
  geom_point()

# How good of a job did this do clustering?
# Give an example of what we could use this model for.

# This did a better job with k=3 than the previous version where k=5,
# as I hypothesized. We could use this model to help determine
# how similar a new wine product will be to existing ones based
# on chemical properties (alcohol and flavanoids in this case).