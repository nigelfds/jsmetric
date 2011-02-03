require "rubygems"
require "bundler/setup"

Dir[File.join(File.dirname(__FILE__),"src","*.rb")].each {|file| require file }
Dir[File.join(File.dirname(__FILE__),"src/graphing","*.rb")].each {|file| require file }
