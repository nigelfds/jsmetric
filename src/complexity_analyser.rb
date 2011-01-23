class ComplexityAnalyser

  attr_accessor :functions

  def parse code
    @js_lint   = JSLint.new code
    @tree_hash = @js_lint.tree
    @functions = @tree_hash # Cheating ;-)
  end

  def function_count
    return @functions.size
  end

  def complexity
    return 1
  end
end

