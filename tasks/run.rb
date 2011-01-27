namespace :spike do

  desc "Produces a CSV list of LOC & number of functions per js file in a given directory (recursive)"
  task :loc_map do

    source_dir = "/Users/nigelfer/Development/nokia/trunk/static-resources/core"
    puts "Name,Dir,LOC,Functions"
    Dir.chdir(source_dir) do

      js_files = Dir.glob(File.join("**", "*.js"))
      js_files.each do |file|
        contents        = File.open(file, 'r') { |f| f.read }
        cleaned_content = strip_js(contents)
        functions = cleaned_content.split("function")
        puts "#{Pathname.new(file).basename},#{Pathname.new(file).dirname},#{cleaned_content.split("\n").size - 1 },#{functions.size}"
      end
    end

  end

end