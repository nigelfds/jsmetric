class ComplexityAnalyser

  def parse code
    @js_lint = JSLint.new code
    @tree_hash = @js_lint.tree
  end

  def function_count
    return @tree_hash.size # Cheating ;-)
  end

end