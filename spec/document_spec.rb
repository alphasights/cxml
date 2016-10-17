require 'spec_helper'

describe CXML::Document do
  let(:parser) { CXML::Parser.new }

  it { should respond_to :version }
  it { should respond_to :payload_id }
  it { should respond_to :timestamp }

  describe '#parse' do
    it 'sets document attributes' do
      data = parser.parse(fixture('envelope3.xml'))
      doc = nil

      expect { doc = CXML::Document.new(data) }.not_to raise_error

      doc.payload_id.should_not be_nil
      doc.timestamp.should be_a Time

      doc.header.should be_a CXML::Header
      doc.request.should be_a CXML::Request
      doc.response.should be_nil
    end
  end
end