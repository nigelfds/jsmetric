class CCReport

  def self.generate_for source
    analyser = ComplexityAnalyser.new
    begin
      analyser.parse source
      output = "Name, CC"
      analyser.functions.each do |function|
        output += "\n#{function[:name]},#{function[:complexity]}"
      end
      p output
    rescue
      p "WARNING: Could not parse #{args.file} : SKIPPED #{args.file}"
    end
  end

end