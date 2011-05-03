#TODO: rename this file

Given /^javascript code as:$/ do |string|
  @code = string
end

When /^I run the complexity analysis on it$/ do
  @analyser = ComplexityAnalyser.new
  @analyser.parse(@code)
end

Then /^the number of functions is reported as "([^"]*)"$/ do |num_funcs|
  @analyser.functions.count.should eql num_funcs.to_i
end

Then /^the complexity is reported as "([^"]*)"$/ do |complexity|
  @analyser.functions.first[:complexity].should eql complexity.to_i
end

And /^the function name is "([^"]*)"$/ do |func_name|
  @analyser.functions.first[:name].should eql func_name
end

And /^the function names are:$/ do |table|  
  table.hashes.each do |function|
    match = @analyser.functions.find {|func| func[:name].eql?(function["Name"])}
    match.should_not be_nil, "Could not find function with name '#{function["Name"]}' in #{@analyser.functions}"
  end

end

