require "complexity_analyser"

class CCReport

  def self.generate_for source
    analyser = ComplexityAnalyser.new
    begin
      analyser.parse source
      output = "Name, CC"
      analyser.functions.each do |function|
        output += "\n#{function[:name]},#{function[:complexity]}"
      end
      puts output
    rescue
      puts "WARNING: Could not parse \n#{source} \n: SKIPPED"
    end
  end

end