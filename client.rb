require "uri"
require "net/http"

# Post info to server 
name = 'nico'
classifier = 'weka.classifiers.trees.J48'

filename = 'sample.arff'
featuresTrain = File.read(filename)


params = {:name => name, :classifier => classifier, :featuresTrain => featuresTrain, :featuresTest => featuresTrain}

x = Net::HTTP.post_form(URI.parse('http://localhost:8080/classify/test'), params)
puts "return: "+x.body