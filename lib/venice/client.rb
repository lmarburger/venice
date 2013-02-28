require 'excon'
require 'json'

module Venice
  ITUNES_PRODUCTION_RECEIPT_VERIFICATION_ENDPOINT  = "https://buy.itunes.apple.com/verifyReceipt"
  ITUNES_DEVELOPMENT_RECEIPT_VERIFICATION_ENDPOINT = "https://sandbox.itunes.apple.com/verifyReceipt"

  class Client
    class << self
      def development
        new(ITUNES_DEVELOPMENT_RECEIPT_VERIFICATION_ENDPOINT)
      end

      def production
        new(ITUNES_PRODUCTION_RECEIPT_VERIFICATION_ENDPOINT)
      end
    end

    attr_reader :verification_url, :process

    def initialize(verification_url, process = Process)
      @verification_url = verification_url
      @process = process
    end

    def verify!(data)
      process.fetch_json(verification_url, 'receipt-data' => data)
    end

    private

    module Process
      class << self
        def fetch_json(url, data)
          response = Excon.post(url, :headers => headers,
                                     :body    => data.to_json)
          JSON.parse(response.body)
        end

        def headers
          {
            'Accept'       => 'application/json',
            'Content-Type' => 'application/json'
          }
        end
      end
    end
  end
end
