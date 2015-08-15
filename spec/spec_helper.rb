require 'avro'
require 'json'

require 'rspec/expectations'

RSpec.configure do |config|

  # Add a "protocols" setting where we will cache loading of AVDL schemas.
  config.add_setting :protocols

  config.before(:suite) do
    RSpec.configuration.protocols = Hash.new do |hash, key|
      output = `avro-tools idl schemas/#{key}`
      hash[key] = Avro::Protocol.parse(output)
    end
  end
end

RSpec::Matchers.define :be_valid_with do |schema|
  match do |data|
    Avro::Schema.validate(schema, data)
  end

  failure_message do |actual|
    "expected that test data would be valid according to provided schema"
  end

  failure_message_when_negated do |actual|
    "expected that test data would not be valid according to provided schema"
  end
end

def load_protocol(file)
  RSpec.configuration.protocols[file]
end

def find_type(protocol, type_name)
  protocol.types.find{|type| type.name == type_name}
end
