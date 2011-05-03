class ComplexityAnalyser

  attr_accessor :functions

  def parse code
    @js_lint = JSLint.new code
    @tree_hash = @js_lint.tree
    @functions = []
    @complexity_keywords = ["if", "for", "while", "do", "&&", "||", "?", "default", "case"]
    parse_multiple_expressions @tree_hash
  end

  def parse_single_expression node
    return unless node

    if node['value'] and node['value'].eql?("function") and not node['arity'].eql?("string")
      functions << {:name => node["name"], :complexity => 1}
      parse_multiple_expressions(node["block"])
      return
    end

    if node['value'] and
        node['value'].eql?("var") and
        node["arity"] and
        node["arity"].eql?("statement")
      parse_multiple_expressions node["first"] if node["first"]
      return
    end


    if node["arity"] and node["arity"].eql?("infix") and node["value"].eql?("=")
      block = node["second"]
      function_name = extract_name_from node["first"]
      if block and block["value"].eql?("function") and block["arity"].eql?("function")
        functions << {:name => function_name, :complexity => 1}
        parse_multiple_expressions(node["block"])
        return
      end
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

  def parse_multiple_expressions array_of_expressions
    return unless array_of_expressions
    array_of_expressions.each do |node|
      parse_single_expression node
    end
  end

  def extract_name_from node
    return node["value"] unless node["value"].eql?(".") and node["arity"].eql?("infix")
    return "" + extract_name_from(node["first"]) + "." + extract_name_from(node["second"])
  end

  def iterate_and_compute_for expression
    if expression.is_a?(Array)
      parse_multiple_expressions expression
    else
      parse_single_expression expression
    end
  end

end

