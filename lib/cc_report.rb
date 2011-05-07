require "complexity_analyser"

class CCReport

  def initialize source
    @output = ""
    @analyser = ComplexityAnalyser.new
    @source = source
  end

  def as_csv
    begin
      @analyser.parse @source
      @output += "Name, CC"
      @analyser.functions.each do |function|
        @output += "\n#{function[:name]},#{function[:complexity]}"
      end
    rescue
      @output = "WARNING: Could not parse \n#{source} \n: SKIPPED"
    end
    @output
  end

end