require 'spec_helper'

context 'Draft 2' do

  describe 'Schema Protocol', file: 'draft-2/schema.avdl' do

    # A collection of shared examples that are used for Schema, InputSchema,
    # and OutputSchema.
    shared_examples 'a Schema record' do

      context 'a minimal schema record missing a type' do
        subject do
          JSON.parse('{ }')
        end

        it 'does not validate with the corresponding schema' do
          expect(subject).not_to be_valid_with(schema)
        end
      end

      context 'a "record" type schema with fields' do
        subject do
          JSON.parse(<<-DOC)
          {
            "type": "record",
            "fields": [
              {"type": "string"}, 
              {"type": "string"}, 
              {"type": "string"}
            ]
          }
          DOC
        end

        it 'does validate with the corresponding schema' do
          expect(subject).to be_valid_with(schema)
        end
      end

      context 'an "enum" type schema with symbols' do
        subject do
          JSON.parse(<<-DOC)
          {
            "type": "enum",
            "symbols": [
              "FOO",
              "BAR",
              "BAZ"
            ]
          }
          DOC
        end

        it 'does validate with the corresponding schema' do
          expect(subject).to be_valid_with(schema)
        end

      end

      context 'an "array" type schema with items' do
        subject do
          JSON.parse(<<-DOC)
          {
            "type": "enum",
            "items": [
              "FOO",
              "BAR",
              "BAZ"
            ]
          }
          DOC
        end

        it 'does validate with the corresponding schema' do
          expect(subject).to be_valid_with(schema)
        end
      end

      context 'a "map" type schema with values' do
        subject do
          JSON.parse(<<-DOC)
          {
            "type": "map",
            "values": "string"
          }
          DOC
        end

        it 'does validate with the corresponding schema' do
          expect(subject).to be_valid_with(schema)
        end

      end
    end

    let(:protocol) do |example|
      load_protocol example.metadata[:file]
    end

    describe 'Schema record' do

      let(:schema) do
        find_type(protocol, "Schema")
      end

      it_behaves_like 'a Schema record'
    end

    describe 'InputSchema record' do

      let(:schema) do
        find_type(protocol, "InputSchema")
      end

      it_behaves_like 'a Schema record'
    end

    describe 'OutputSchema record' do

      let(:schema) do
        find_type(protocol, "OutputSchema")
      end

      it_behaves_like 'a Schema record'

      context 'an OutputSchema record with a specified binding' do

        subject do
          JSON.parse(<<-DOC)
          {
            "type": "record",
            "fields": [
              {"type": "string"}, 
              {"type": "string"}, 
              {"type": "string"}
            ],
            "inputBinding": {
              "loadContents": true,
              "secondaryFiles": [
                "/path/to/file",
                "/path/to/another/file"
              ]
            }
          }
          DOC
        end

        it 'does validate with the corresponding schema' do
          expect(subject).to be_valid_with(schema)
        end

      end
    end
  end
end
