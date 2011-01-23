#TODO: rename this file

Given /^javascript code as:$/ do |string|
  @code = string
end

When /^I run the complexity analysis on it$/ do
  @analyser = ComplexityAnalyser.new
  @analyser.parse(@code)
end

Then /^the number of functions is reported as "([^"]*)"$/ do |arg1|
  @analyser.function_count.should eql 1
end

