import scipy as sp
from sklearn.cluster import KMeans
from sklearn import cluster
import numpy as np
import pandas as pd

#X = np.array([[1, 2], [1, 4], [1, 0], [4, 2], [4, 4], [4, 0]])
X = pd.read_csv("../word2vec/output/word_vectors_training.csv",header=None)
vectors = X.iloc[:,1:] # this is the vector representation, from column 1 till the end
words = X[X.columns[0]] # this is the first column, the real "words"
centroids, labels, inertia = cluster.k_means (vectors, n_clusters = 4)

#kmeans = KMeans(n_clusters=2, random_state=0).fit(X)
np.savetxt('C:\\Users\\chitra\\Desktop\\TU-Delft\\Information Retrival\\movie-reviews\\label.txt',labels,fmt='%d')
np.savetxt('C:\\Users\\chitra\\Desktop\\TU-Delft\\Information Retrival\\movie-reviews\\centroids.txt',centroids,fmt='%d')
np.savetxt('C:\\Users\\chitra\\Desktop\\TU-Delft\\Information Retrival\\movie-reviews\\inertia.txt',inertia,fmt='%d')
#print centroids
#print labels
#print inertia
#kmeans.labels_array([0, 0, 0, 1, 1, 1], dtype=sp.int32)
#kmeans.predict([[0, 0], [4, 4]]), np.array([0, 1], dtype=sp.int32)
#kmeans.cluster_centers_array([[ 1.,  2.], [ 4.,  2.]])