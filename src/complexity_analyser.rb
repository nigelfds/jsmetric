class ComplexityAnalyser

  attr_accessor :functions

  def parse code
    @js_lint   = JSLint.new code
    @tree_hash = @js_lint.tree
    @functions = []

    @tree_hash.each do |node|
      p node
      compute_complexity_of node
    end
  end

  def function_count
    return @functions.size
  end

  def complexity
    @functions.last[:complexity]
  end

  def compute_complexity_of node
    if (node["arity"] == "statement") && (node["value"] == "function")
      @functions << {:name => node["name"], :complexity => 1}
      iterate_and_compute_for node["block"]
    end

    if (node["arity"] == "statement") && (node["value"] == "if")
      @functions.last[:complexity] += 1
      iterate_and_compute_for node["block"]
      compute_complexity_of node["else"] if node["else"] and not node["else"].empty?
    end
  end

  def iterate_and_compute_for array
    array.each do |item|
      compute_complexity_of item
    end
  end
end

