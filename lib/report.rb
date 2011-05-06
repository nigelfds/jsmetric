require "cc_report"
class Report

  def self.for file_path
    contents = File.open(file_path, 'r') { |f| f.read }
    CCReport.generate_for contents
  end
  
end