class ComplexityAnalyser

  attr_accessor :functions

  def parse code
    @js_lint   = JSLint.new code
    @tree_hash = @js_lint.tree
    @functions = []
    @complexity_keywords = ["if", "for", "while", "do", "&&", "||", "?", "default", "case"]

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

    if node["value"].eql?("function") and not node["arity"].eql?("string")
      node["name"].empty? ? name = "anonymous/inner" : name = node["name"]
      @functions << {:name => name, :complexity => 1}
    end

    if @complexity_keywords.include?(node["value"])
      @functions.last[:complexity] += 1 unless @functions.empty?
    end

    if node["value"].eql?("try")
      @functions.last[:complexity] += 1 if node["second"]
      @functions.last[:complexity] += 1 if node["third"]
    end

    iterate_and_compute_for node["first"]
    iterate_and_compute_for node["second"]
    iterate_and_compute_for node["third"]
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

