#require 'json'
#
#file          = 'places_parse.json'
#file_contents = File.open(file, 'r') { |f| f.read }
#tree          = JSON.parse(file_contents, :max_nesting => 100)
#
#puts tree[0]



require '../boot.rb'
require 'v8'
require 'json'

file = "places.js"
source = File.open(file, 'r') { |f| f.read }



cxt = V8::Context.new
cxt.load("json2.js")
cxt.load("webjslint.js")
cxt.load("options.js")
cxt['source'] = source
cxt.eval_js("JSLINT(source.toString(), options);")
raw_json_tree = cxt.eval_js("JSON.stringify(JSLINT.tree, ['value',  'arity', 'name',  'first', 'second', 'third', 'block', 'else'], 4);")

puts JSON.parse(raw_json_tree, :max_nesting => 100)
