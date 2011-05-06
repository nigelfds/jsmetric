require "rubygems"
require "bundler/setup"

Dir[File.join(File.dirname(__FILE__),"lib","*.rb")].each {|file| require file }
Dir[File.join(File.dirname(__FILE__),"lib","graphing","*.rb")].each {|file| require file }
