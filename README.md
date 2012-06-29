# Spam Classification Problem for LA Coding Dojo

#### Tasks:
1. Process data into Weka ARFF format
1. Train a classifier using Weka
1. Test your classifier against test data

### DATA PROCESSING
* Download training data tarball from http://dojo.v.wc1.atti.com/data/train
* Weka accepts ARFF files: http://www.cs.waikato.ac.nz/ml/weka/arff.html
  * See https://github.com/a34729t/coding-dojo-ml/blob/master/sample.arff
* Each training or test file becomes a vector of features
* You can play around with the values or ranges of values for your features in the ARFF file itself

### TRAINING
* POST to http://dojo.v.wc1.atti.com/train with the following params:
  * name (your name)
  * classifier (weka classifier name, see list below)
  * featuresTrain (your ARFF file)
* See https://github.com/a34729t/coding-dojo-ml/blob/master/client.rb for a sample client
* You get back a JSON response with statistics on how well you performed
* Check your performance vs others at http://dojo.v.wc1.atti.com/rank

### TESTING
* After a certain period of time we will allow you to access the training data
* Download test data tarball from http://dojo.v.wc1.atti.com/data/test
* Process the test data with the same features you use for training data
* POST to http://dojo.v.wc1.atti.com/train with params:
  * name
  * classifier
  * featuresTrain
  * featuresTest

### NOTES
* I would recommend using Naive Bayes and the Decision Tree first as they give you good feedback about which features are useful
* Machine Learning is about quality data and features—what model you use is much less important

### WEKA CLASSIFIERS (From simplest to more complicated)
* weka.classifiers.bayes.NaiveBayes
* weka.classifiers.trees.J48
* weka.classifiers.functions.Logistic
* weka.classifiers.lazy.kstar
* weka.classifiers.rules.JRip
* weka.classifiers.functions.SMO