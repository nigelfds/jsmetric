class GraphAnalyser
  def initialize
    @analysis = { :graphdata => {} }
  end

  def parse code
    @js_lint   = JSLint.new code
    @tree_hash = @js_lint.tree
  end

  def json
    @analysis.to_json
  end
end