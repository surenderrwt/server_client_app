# class UriCreater

# 	def uri
# 		return uri = URI.join(APIx_URL, "/users")
# 	end
# end


# class UriCreaterServices



#   def initialize
#     query_text= text
#   end

#   def call
#     uri = URI.join(API_URL, query_text)
#   end

# end


    module UriCreaterServices
      def self.create_uri( query_text)
      		uri = URI.join(API_URL, query_text)
      end
    end