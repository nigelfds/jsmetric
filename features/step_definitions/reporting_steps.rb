Given /^a sample JS file called "([^"]*)"$/ do |filename|
  @filename = filename
end

When /^the CC report target in run on it$/ do
  path = File.join(File.dirname(__FILE__),'..', "sample_js_files_for_test", @filename + ".js")
  contents = File.open(path, 'r') { |f| f.read }  
  @results = CCReport.new(contents).as_csv
end

Then /^the contents of the report are as follows$/ do |expected_report|
  @results.should == expected_report
end

