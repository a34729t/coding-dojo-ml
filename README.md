# TODOS:
-verify weka train command is alright, catch errors, create model file, exceptions, etc
-weka command to test data
-write client to do this

Contents:
* Gemfile bundler file
* server.rb web server that serves up data and offers classification and training endpoints
* weka.jar WEKA classification package
* test/ test data (ENRON email dataset - 25%)
* training/ training data (ENRON email dataset - 75%)

java -cp weka.jar weka.classifiers.bayes.NaiveBayes -t [training set filename] -i -k -d march.model
java -cp weka.jar weka.classifiers.bayes.NaiveBayes -l march.model -T [test set filename]

weka.classifiers.bayes.NaiveBayes
weka.classifiers.trees.J48 
weka.classifiers.functions.SMO
