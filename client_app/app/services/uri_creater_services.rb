    module UriCreaterServices
      def self.create_uri( query_text)
      		uri = URI.join(API_URL, query_text)
      end

   # 		def get_date
   # 			esponse =  Net::HTTP.get_response(uri)
   			
   # 		end
   # 		return response =  Net::HTTP.get_response(uri)


   #    		req['auth_token'] = session[:auth_token]
			# res = Net::HTTP.start(uri.hostname, uri.port) {|http|
		 #  http.request(req)
    end