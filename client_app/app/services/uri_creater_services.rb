    module UriCreaterServices
      def self.create_uri( query_text)
      		uri = URI.join(API_URL, query_text)
      end
    end