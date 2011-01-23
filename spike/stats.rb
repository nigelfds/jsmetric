require 'json'




file          = 'places_parse.json'
file_contents = File.open(file, 'r') { |f| f.read }
tree          = JSON.parse(file_contents, :max_nesting => 100)

puts tree[0]




  tree.each do |child|
    child.each do |c|
      yield c
    end
  end

  yield self


