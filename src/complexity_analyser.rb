class ComplexityAnalyser

  attr_accessor :functions

  def parse code
    @js_lint   = JSLint.new code
    @tree_hash = @js_lint.tree
    @functions = []

    @tree_hash.each do |node|
      compute_complexity_of node
    end
  end

  def function_count
    return @functions.size
  end

  def complexity
    @functions.last[:complexity]
  end

  private
  def compute_complexity_of(node)
    return if node.nil?

    if node["value"].eql?("function")
      node["name"].empty? ? name = "anonymous/inner" : name = node["name"]
      @functions << {:name => name, :complexity => 1}
    end

    if node["value"].eql?("if")
      @functions.last[:complexity] += 1
    end
    

    iterate_and_compute_for node["first"]
    iterate_and_compute_for node["second"]
    iterate_and_compute_for node["block"]
    iterate_and_compute_for node["else"]
  end

  def iterate_and_compute_for(node)
    if node.is_a?(Array)
      node.each { |item| compute_complexity_of item }
    else
      compute_complexity_of node
    end
  end

end

