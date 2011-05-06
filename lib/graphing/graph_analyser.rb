class GraphAnalyser
  def initialize
    @analysis = { :graphdata => {} }
  end

  def parse code
    js_lint   = JSLint.new code 
    js_lint.tree.each do |node|
      if node["value"].eql?("function") and not node["arity"].eql?("string")
         @functions << {node["name"]=> 1}
       end
      
    end
  end

  def json
    @analysis.to_json
  end
end