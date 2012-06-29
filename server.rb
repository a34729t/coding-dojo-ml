require 'sinatra'
require 'sinatra/synchrony'
require 'json'

set :port, 8080

$top_train = []
$top_test = []
$locked = true

def validateParams(params,*required)
  if required
    required.each { |r|
      if not params.has_key?(r.to_s)
        content_type :json
        msg = {:error => "missing param '#{r}'"}
        halt msg.to_json
      end
    }
  end
end

def update_training_rank(fmeasure,data)
  for i in 0 ... $top_train.size
    info = $top_train[i]
    if info['F-Measure'] < fmeasure
      $top_train.insert(i,data)
      return
    end
  end
  $top_train << data
end

def classify(name,classifier,featuresTrain,featuresTest=nil)
  if featuresTest and $locked
    ret = {:error => "test data is locked, play with training data some more"}
    halt ret.to_json
  end
  
  #begin
    #Generate a random file and write features to it
    filename = (0...8).map{65.+(rand(25)).chr}.join
    File.open(filename+".arff", 'w') {|f| f.write(featuresTrain) }
  
    # Call Weka, see how long it takes
    t0 = Time.now
    output = `java -cp weka.jar #{classifier} -t #{filename}.arff -i -k -d #{filename}.model`
    t1 = Time.now - t0
    `rm #{filename}.arff #{filename}.model` # clean up
    
    # Get the cliffnotes on training statistics
    # Line looks like: Weighted Avg. 0.941 0.007 0.946 0.941 0.939 0.999 0.985 
    end_of_output = output[/Stratified cross-validation.*/m] 
    if end_of_output
      stat_arr = end_of_output[/Weighted Avg.*\n/].split(/\s+/)
      avg_stats = {"TP Rate" => stat_arr[2], "FP Rate" => stat_arr[3], "Precision" => stat_arr[4], "Recall" => stat_arr[5], "F-Measure" => stat_arr[6]}
      
      rank_info = {"name" => name, "classifier" => classifier, "TP Rate" => stat_arr[2], "FP Rate" => stat_arr[3], "Precision" => stat_arr[4], "Recall" => stat_arr[5], "F-Measure" => stat_arr[6]}
      update_training_rank(stat_arr[6], rank_info) # update leader board
      
      # print json response
    	training = {:time => t1, :classifier => classifier, :statistics => avg_stats, :wekaOutput => output}
    	return training.to_json
    else
      ret = {:error => "you fucked something up", :output => output}
      return ret.to_json
    end
  #rescue Exception=>e
  #  ret = {:error => e}
  #  puts "Exception on generate random file or something: #{e}"
  #  return ret.to_json
  #end
  
end

get '/help' do
  # classifiers - any weka classifier
  # 1) weka.classifiers.bayes.NaiveBayes
  # 2) 
  # 3) 
end

get '/rank' do
  str = ''

  # Training
  str += '<h2>TRAINING LEADERBOARD</h2>'
  str += "<table border='1'>"
  str += "<tr><td>Rank</td><td>Name</td><td>Classifier</td><td>F-Measure</td><td>TP Rate</td><td>FP Rate</td><td>Precision</td><td>Recall</td></tr>"
  for i in 0 ... $top_train.size
    info = $top_train[i]
    str += "<tr><td>#{i+1}</td><td>#{info['name']}</td><td>#{info['classifier']}</td><td>#{info['F-Measure']}</td><td>#{info['TP Rate']}</td><td>#{info['FP Rate']}</td><td>#{info['Precision']}</td><td>#{info['Recall']}</td></tr>"
  end
  str += "</table><br><br>"
  
  # Testing
  str += '<h2>TEST LEADERBOARD</h2>'
  str += "<table border='1'>"
  str += "<tr><td>Rank</td><td>Name</td><td>Classifier</td><td>Root Mean Squared Error</td><td>Mean Absolute Error</td><td>Correctly Classified Instances</td></tr>"
  for i in 0 ... $top_test.size
    info = $top_test[i]
    str += "<tr><td>#{i+1}</td><td>#{info['name']}</td><td>#{info['classifier']}</td><td>#{info['Root mean squared error']}</td><td>#{info['Mean absolute error']}</td><td>#{info['Correctly Classified Instances']}</td></tr>"
  end
  str += "</table><br><br>"
  
  return str
end

get '/data/train' do
  file = './train.tar.gz'
  send_file(file, :disposition => 'inline', :filename => File.basename(file))
  puts "downloaded training data"
end

get '/data/test' do
  if $locked
    ret = {:error => "test data is locked, play with training data some more"}
    halt ret.to_json
  else
    file = './test.tar.gz'
    send_file(file, :disposition => 'inline', :filename => File.basename(file))
    puts "downloaded test data"
  end
end

post '/classify/train' do
  validateParams(params, :name, :classifier, :featuresTrain)
  name = params[:name]
  classifier = params[:classifier]
  featuresTrain = params[:featuresTrain]
  
  return classify(name,classifier,featuresTrain)
end

post '/classify/test' do
  validateParams(params, :name, :classifier, :featuresTrain, :featuresTest)
  name = params[:name]
  classifier = params[:classifier]
  featuresTrain = params[:featuresTrain]
  featuresTest = params[:featuresTest]
  
  return classify(name,classifier,featuresTrain,featuresTest)
end

get '/unlocktestdata' do
  if $locked
    $locked = false
    return "test data UNLOCKED"
  else
    $locked = true
    return "test data LOCKED"
  end
end
  

