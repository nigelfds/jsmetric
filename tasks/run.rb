namespace :run do

  desc "Produces a CSV list of LOC & number of functions per js file in a given directory (recursive)"
  task :loc_func_map, :dir do |task, args|

    raise "No Dir specified" unless args.dir
    puts "Name,Dir,LOC,Functions"
    Dir.chdir(args.dir) do
      js_files = Dir.glob(File.join("**", "*.js"))
      js_files.each do |file|
        contents        = File.open(file, 'r') { |f| f.read }
        cleaned_content = strip_js(contents)
        functions       = cleaned_content.split("function")
        puts "#{Pathname.new(file).basename},#{Pathname.new(file).dirname},#{cleaned_content.split("\n").size - 1 },#{functions.size}"
      end
    end

  end

  desc "Produces a CSV list of LOC & overall complexity per js file in a given directory (recursive)"
  task :loc_complexity_map, :dir do |task, args|
    raise "No Dir specified" unless args.dir
    raise "Sorry.. this target is WIP :-("
  end


  desc "Produces a CSV list of functions and their Cyclometric complexity in a JS file"
  task :cc, :file do |task, args|
    raise "No file specified" unless args.file
    raise "Sorry.. this target is WIP :-("
  end

end