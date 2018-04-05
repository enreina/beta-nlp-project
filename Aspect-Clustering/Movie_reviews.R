library(RTextTools)

dataDirectory = "file:///C:/Users/chitra/Desktop/TU-Delft/Information Retrival/movie-reviews"
data <- read_excel("C:/Users/chitra/Desktop/TU-Delft/Information Retrival/movie-reviews/movie_reviews.xlsx")
dtMatrix <- create_matrix(data["text"])


# Configure the training data
container <- create_container(dtMatrix, data$label,trainSize=1:746, virgin=FALSE)

# train a SVM Model
model <- train_model(container, "SVM", kernel="linear", cost=1)

#predicting data 
predictionData <- list("this movie is good", "the actor is handsome", "cast", "", "this is another boring movie")

# create a prediction document term matrix
predMatrix <- create_matrix(predictionData, originalMatrix=dtMatrix)
