#TODO : Replace with execution path through bin/jsmetric

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

    Dir.chdir(args.dir) do
      js_files = Dir.glob(File.join("**", "*.js"))
      js_files.reject! { |file| file.include?(".core.js") }
      outputs = []
      js_files.each do |file|
        contents = File.open(file, 'r') { |f| f.read }
        analyser = ComplexityAnalyser.new
        begin
          analyser.parse contents
          outputs << {file => analyser.functions}
        rescue
          p "WARNING: Could not parse #{file} : SKIPPED #{file}"
        end
      end

      puts "dir,file,funcs,totalcc"        
      outputs.each do |output|
        output.each do |file_name, report|
          file_complexity = 0

          report.each do |analysis|
            file_complexity += analysis[:complexity]
          end
          puts "#{Pathname.new(file_name).dirname},#{Pathname.new(file_name).basename},#{report.size},#{file_complexity}"
        end
      end
    end

  end
end