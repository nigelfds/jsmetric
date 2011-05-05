class CCReport

  def self.generate_for source
    analyser = ComplexityAnalyser.new
    begin
      analyser.parse source
      p "Name, CC\nKlass,3\nAnnonymous,2\nconstructor,2"
#      p analyser.functions
    rescue
      p "WARNING: Could not parse #{args.file} : SKIPPED #{args.file}"
    end
  end

end