# Spam Classification Problem for LA Coding Dojo

#### Tasks:
* Process data into Weka ARFF format
* Train a classifier using Weka
* Test your classifier against test data

### DATA PROCESSING
* Download training data tarball http://dojo.v.wc1.atti.com/data/train
* Weka accepts ARFF files: http://www.cs.waikato.ac.nz/ml/weka/arff.html
* Each training or test file becomes a vector of features
* You can play around with the values or ranges of values for your features in the ARFF file itself

### TRAINING
* POST to http://dojo.v.wc1.atti.com/train with params name (your name), classifier (weka classifier name, see list below) and featuresTrain (the string version of your ARFF file)
* You get back a json response with statistics on how well you performed
* Check your performance vs others at http://dojo.v.wc1.atti.com/rank

### TESTING
* After a certain period of time we will allow you to access the training data
* Download test data tarball http://dojo.v.wc1.atti.com/data/test
* Process the test data with the same features you use for training data
* POST to http://dojo.v.wc1.atti.com/train with params name classifier, featuresTrain and featuresTest

### NOTES
* I would recommend using Naive Bayes and the Decision Tree first as they give you good feedback about which features are useful
* Machine Learning is about quality data and features—what model you use is much less important

### WEKA CLASSIFIERS (In order of simplest to more complicated)
* weka.classifiers.bayes.NaiveBayes
* weka.classifiers.trees.J48
* weka.classifiers.functions.Logistic
* weka.classifiers.lazy.kstar
* weka.classifiers.rules.JRip
* weka.classifiers.functions.SMO