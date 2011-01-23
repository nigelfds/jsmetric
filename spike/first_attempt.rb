#Strip a JS file of comments but leave the code and new lines untouched.
def strip_js(data)
  non_empty_strings = []
  stripped_data     = data.gsub(/('|").*?[^\\]\1/) { |m|
    non_empty_strings.push $&
    "!temp-string-replacement-#{non_empty_strings.size}!"
  }
  stripped_data.gsub(/\/\*.*?\*\//m, "\n").gsub(/\/\/.*$/, "").gsub(/( |\t)+$/, "").gsub(/\n+/, "\n").gsub(/!temp-string-replacement-([0-9]+)!/) { |m| non_empty_strings[$1.to_i] }
end

## Parse an entire folder of JS files and do simple evaluation of complexity
#
#source_dir = "/Users/nigelfer/Development/nokia/trunk/static-resources/"
#Dir.chdir(source_dir) do
#
#  js_files = Dir.glob(File.join("**", "*.js"))
#
#  puts "Total JS files:#{js_files.size}"
#
#  js_files.each do |file|
#    puts "#{file}"
#    contents        = File.open(file, 'r') { |f| f.read }
#    cleaned_content = strip_js(contents)
#
#    puts "Lines: #{cleaned_content.split("\n").size - 1 }"
#    functions = cleaned_content.split("= function (")
#    puts "Functions: #{functions.size}"
#
#    functions.each do |function|
#      puts "---"
#      puts "IF Complexity: #{function.split("if").size - 1 }"
#      puts "ELSE Complexity: #{function.split("else").size - 1 }"
#      puts "SWITCH Complexity #{function.split("switch").size + cleaned_content.split("case").size - 2}"
#      puts "LOOP Complexity #{function.split("for").size + cleaned_content.split("while").size - 2}"
#      puts "---\n"
#    end
#    puts "\n"
#  end
#end

file = "/Users/nigelfer/Development/nokia/trunk/static-resources/modules/places/js/places.categories.js"
contents        = File.open(file, 'r') { |f| f.read }
cleaned_content = strip_js(contents)

puts "Lines: #{cleaned_content.split("\n").size - 1 }"

functions = cleaned_content.split("= function (")

puts "Functions: #{functions.size}"

#functions.shift

functions.each do |function|
#  puts "---"
#  puts "SOURCE:" + function
#  puts "---"
  puts "IF Complexity: #{function.split("if").size - 1 }"
  puts "ELSE Complexity: #{function.split("else").size - 1 }"
  puts "SWITCH Complexity #{function.split("switch").size + cleaned_content.split("case").size - 2}"
  puts "LOOP Complexity #{function.split("for").size + cleaned_content.split("while").size - 2}"
  puts "---\n"
end
puts "\n"
