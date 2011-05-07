require "cc_report"
class Report

  def self.for file_path
    output = ""
    if (File.directory? file_path)
      Dir.chdir(file_path) do
        output += "\nDir: #{file_path}\n"
        Dir.glob(File.join("**", "*.js")).each do |file|
          output += "File: #{file}\n"
          output += "\n" + Report.cc_report_for(file)
          end
      end
    else
      output += "\nFile: #{file_path}\n"
      output += Report.cc_report_for file_path
    end
    output
  end

  def self.cc_report_for file
    contents = File.open(file, 'r') { |f| f.read }
    CCReport.new(contents).as_csv
  end

end