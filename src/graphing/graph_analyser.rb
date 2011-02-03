class GraphAnalyser

  attr_accessor :json

  def parse code
    @js_lint   = JSLint.new code
    @tree_hash = @js_lint.tree
    return ""
  end
end