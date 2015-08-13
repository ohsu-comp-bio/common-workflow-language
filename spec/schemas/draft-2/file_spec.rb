require 'spec_helper'

context 'Draft 2' do

  describe 'File Protocol', file: 'draft-2/file.avdl' do

    let(:protocol) do |example|
      load_protocol example.metadata[:file]
    end

    describe 'File record' do

      let(:schema) do
        find_type(protocol, "File")
      end

      context 'a minimal File record missing a path' do
        subject do
          JSON.parse(<<-DOC)
            {
              "fileClass": "FILE"
            }
          DOC
        end

        it 'does not validate with the corresponding schema' do
          expect(subject).not_to be_valid_with(schema)
        end
      end

      context 'a minimal File record' do
        subject do
          JSON.parse(<<-DOC)
            {
              "path": "/path/to/file",
              "fileClass": "FILE"
            }
          DOC
        end

        it 'does validate with the corresponding schema' do
          expect(subject).to be_valid_with(schema)
        end
      end
      
      context 'a File with nested secondaryFiles' do
        subject do
          JSON.parse(<<-DOC)
            {
              "path": "/path/to/file",
              "fileClass": "FILE",
              "secondaryFiles": [
                {"path": "/path/to/another/file", "fileClass": "FILE"},
                {"path": "/path/to/yet/another/file", "fileClass": "FILE"}]
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
