class GraphAnalyser
  def initialize
    @analysis = { :graphdata => {} }
  end

  def parse code

  end

  def json
    @analysis.to_json
  end
end