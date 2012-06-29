require "uri"
require "net/http"

# Post info to server 
name = 'nico'
classifier = 'weka.classifiers.trees.J48'

filename = 'sample.arff'
featuresTrain = File.read(filename)


params = {:name => name, :classifier => classifier, :featuresTrain => featuresTrain}

x = Net::HTTP.post_form(URI.parse('http://dojo.v.wc1.atti.com/classify/train'), params)
puts "return: "+x.body