#TODO: rename this file

Given /^javascript code as:$/ do |string|
  @code = string
end

When /^I run the complexity analysis on it$/ do
  @analyser = ComplexityAnalyser.new
  @analyser.parse(@code)
end

Then /^the number of functions is reported as "([^"]*)"$/ do |num_funcs|
  @analyser.function_count.should eql num_funcs.to_i
end

Then /^the complexity is reported as "([^"]*)"$/ do |complexity|
  @analyser.complexity.should eql complexity.to_i
end