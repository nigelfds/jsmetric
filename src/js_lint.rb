require 'v8'
require 'json'

class JSLint

  def initialize source
    @source = source
    @context = V8::Context.new
    load("fulljslint")
    load("options")       #TODO: refactor options to be a param
    load("json2")
  end

  def tree
    @context['source'] = @source

    code = <<Code
      JSLINT(source.toString(), options);
      JSON.stringify(JSLINT.tree, ['value',  'arity', 'name',  'first', 'second', 'third', 'block', 'else'], 4);
Code

    JSON.parse(@context.eval_js(code), :max_nesting => 100)
  end

  def load filename
    @context.load(File.join(File.dirname(__FILE__),"#{filename}.js"))
  end
end