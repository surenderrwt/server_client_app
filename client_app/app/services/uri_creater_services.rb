module UriCreaterServices

    def self.show_users( query_text)
  		uri = URI.join(API_URL, query_text)
  		return Net::HTTP.get_response(uri)
    end

    def self.create_user( query_text, params)
   		uri = URI.join(API_URL, query_text)
   		
   		return Net::HTTP.post_form(uri,
			 "user[name]" => "#{params[:name]}",
			 "user[username]" => "#{params[:username]}", 
			 "user[password]" => "#{params[:password]}", 
			 "user[password_confirmation]" => "#{params[:password_confirmation]}")
    end

    def self.get_user( query_text, token)
  		uri = URI.join(API_URL, query_text)
  		req = Net::HTTP::Get.new(uri)
		req['auth_token'] = token
		return Net::HTTP.start(uri.hostname, uri.port) {|http|
		  	http.request(req)
		}
    end

    def self.edit_user( query_text, token)
     	uri = URI.join(API_URL, query_text) 
		req = Net::HTTP::Get.new(uri)
		req['auth_token'] = token
		return Net::HTTP.start(uri.hostname, uri.port) {|http|
			http.request(req)
		}
	end

	def self.update_user( query_text, params, token)
     	uri = URI.join(API_URL, query_text) 
		req = Net::HTTP::Put.new(uri)
		req.set_form_data(
			"user[name]" => "#{params[:name]}",
			"user[username]" => "#{params[:username]}",)
		req['auth_token'] = token	
		
		return 	Net::HTTP.start(uri.hostname, uri.port) do |http|
		 	http.request(req)
		end
	end

	def self.login_user(query_text, params)
		uri = URI.join(API_URL, query_text)
		Net::HTTP.post_form URI(uri), 
			{"username" => "#{params[:username]}", "password" => "#{params[:password]}" }
	end


	def self.logout_user( query_text, token)
	  	uri = URI.join(API_URL, query_text) 
     	req = Net::HTTP::Get.new(uri)
		req['auth_token'] = token 
		return Net::HTTP.start(uri.hostname, uri.port) {|http|
			http.request(req)
		}
	end
end