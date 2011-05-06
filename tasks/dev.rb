desc "Run all cukes tagged with @current"
Cucumber::Rake::Task.new(:current) do |t|
  t.cucumber_opts = "--tags @current"
end
