#specific to graph analysis

When /^I run the graph analysis on it$/ do
  @analyser = GraphAnalyser.new
  @analyser.parse(@code)
end

Then /^the JSON object returned is:$/ do |json|
  JSON.parse(@analyser.json).should eql JSON.parse(json)
end
