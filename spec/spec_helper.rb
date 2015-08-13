require 'avro'
require 'json'

require 'rspec/expectations'

def load_protocol(file)
  output = `avro-tools idl schemas/#{file}`
  Avro::Protocol.parse(output)
end

def find_type(protocol, type_name)
  protocol.types.find{|type| type.name == type_name}
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
