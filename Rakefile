require 'rake'
require 'rspec/core/rake_task'

def validate_avro_tools!
  if system('which avro-tools').nil?
    raise "avro-tools must be installed for idl conversion."
  end
end
 
RSpec::Core::RakeTask.new(:spec) do |t|
  validate_avro_tools!
  t.pattern = Dir.glob('spec/**/*_spec.rb')
  t.rspec_opts = '--format documentation'
end

task :default => :spec
