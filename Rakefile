MANIFEST = FileList["Manifest.txt", "Rakefile", "README.txt", "LICENSE.txt", "lib/**/*"]

file "Manifest.txt" => :manifest
task :manifest do
  File.open("Manifest.txt", "w") {|f| MANIFEST.each {|n| f << "#{n}\n"} }
end
Rake::Task['manifest'].invoke

begin
  require 'hoe'
  Hoe.plugin :gemcutter
  hoe = Hoe.spec("activerecord-jdbcdbf-adapter") do |p|
    p.version = "0.9.7"
    p.spec_extras[:platform] = Gem::Platform.new("java")
    p.url = "http://github.com/nightshade427/activerecord-jdbcdbf-adapter"
    p.author = "Nick Ricketts"
    p.email = "nightshade427@gmail.com"
    p.summary = "DBF JDBC adapter for JRuby on Rails."
    p.description = "Install this gem to use DBF with JRuby on Rails."
    p.extra_deps += [['activerecord-jdbc-adapter', "= 0.9.7"]]
  end
  task :gemspec do
    File.open("#{hoe.name}.gemspec", "w") {|f| f << hoe.spec.to_ruby }
  end
  task :package => :gemspec
rescue LoadError
  puts "You really need Hoe installed to be able to package this gem"
rescue => e
  puts "ignoring error while loading hoe: #{e.to_s}"
end
