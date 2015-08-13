require 'rake'
require 'rspec/core/rake_task'
 
RSpec::Core::RakeTask.new(:spec) do |t|
  puts Dir.pwd
  if system('which avro-tools').nil?
    raise "avro-tools must be installed for idl conversion."
  end

  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

task :default => :spec
