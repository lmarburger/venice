require 'spec_helper'
require 'venice/client'

describe Venice::Client do
  describe '#verify!' do
    let(:data)     { stub :data }
    let(:url)      { stub :url }
    let(:response) { stub :response }
    let(:process)  { stub :process, :fetch_json => response }
    subject { Venice::Client.new(url, process).verify!(data) }

    it 'returns fetch_json response' do
      subject.should eq(response)
    end

    it 'sends fetch_json with data and url' do
      expected_body = {'receipt-data' => data}
      process = stub :process
      process.should_receive(:fetch_json).with(url, expected_body).once
      Venice::Client.new(url, process).verify!(data)
    end
  end

  describe '.development' do
    it 'uses development receipt verification url' do
      expected_url = Venice::ITUNES_DEVELOPMENT_RECEIPT_VERIFICATION_ENDPOINT
      Venice::Client.development.verification_url.should eq(expected_url)
    end
  end

  describe '.production' do
    it 'uses production receipt verification url' do
      expected_url = Venice::ITUNES_PRODUCTION_RECEIPT_VERIFICATION_ENDPOINT
      Venice::Client.production.verification_url.should eq(expected_url)
    end
  end
end
