
	# require 'net/http'
	# require 'uri'
	# API_URL = "http://localhost:4000"




	## ------- To debug the controller ----------##


	#  To print the value into console
	#    puts @user.inspect
	#
	#
	#  To output the responce and search the data
	# debugger

class UsersController < ApplicationController

	 before_action :set_user, only: [:edit, :update, :destroy, :show ]

	#before_action :authenticate, except: [ :index, :new, :create ]



	def index
		res = Net::HTTP.get_response(UriCreaterServices.create_uri("/users"))
		@users = JSON.parse(res.body)
		# puts UriCreater.uri
		# puts @suggestion = UriCreater.new(text: "/users").call
		# uri = URI.join(API_URL, "/users")
		# res = Net::HTTP.get_response(uri)
		# @users = JSON.parse(res.body)
		# res = Net::HTTP.get('http://localhost:4000', '/users')
		# req = Net::HTTP::Get.new(BASE_URL)
		# res = Net::HTTP.start(BASE_URL.hostname) {|http|
		#   http.request(req)
		# }
		# puts res.body if res.is_a?(Net::HTTPSuccess)	
		# @users = JSON.parse(res.body)
		#@user = user.to_hash
		# puts @user.inspect
	end
	
	def new
	end

	def create

		res = Net::HTTP.post_form(UriCreaterServices.create_uri("/users"),
			 "user[name]" => "#{params[:user][:name]}",
			 "user[username]" => "#{params[:user][:username]}", 
			 "user[password]" => "#{params[:user][:password]}", 
			 "user[password_confirmation]" => "#{params[:user][:password_confirmation]}")
		# #res = Net::HTTP.post(BASE_URL, user_params.to_query)
		# uri = URI.join(API_URL, "/users")

		# res = Net::HTTP.post_form URI(UriCreaterServices.create_uri("/users")), 
		# 	{"user[name]" => "#{params[:user][:name]}",
		# 	 "user[username]" => "#{params[:user][:username]}", 
		# 	 "user[password]" => "#{params[:user][:password]}", 
		# 	 "user[password_confirmation]" => "#{params[:user][:password_confirmation]}" }
		#res = http.post(BASE_URL, user_params.to_query)
		puts res.body if res.is_a?(Net::HTTPSuccess)
		JSON.parse(res.body)

		render :login
		#debugger


	end


	# Show User details from API 
	def show

		# There is no need to send the request to API, we can fetch details from session

		# id = session["id"]
		# token = session["auth_token"]
		# uri = URI.join(API_URL, "/users/#{id}")

		# req = Net::HTTP::Get.new(uri)
		# req['auth_token'] = token
		# res = Net::HTTP.start(uri.hostname, uri.port) {|http|
		#   http.request(req)
		# }
		# puts res.body if res.is_a?(Net::HTTPSuccess)
		# @user = JSON.parse(res.body)


		# 	puts params
		# debugger
		#response.set_header('auth_token', '710fb5d3f0c5a90b862ed4796676c5d21bb6447700a82a524373ca8c08b9d707')

	end

	
	# 	Edit function to fetch info from API
	# 	this OpenStruct.new method is need to be explored	
	def edit
		id = @user["id"]
		token = @user["auth_token"]
		puts uri = UriCreaterServices.create_uri("/users/#{id}") 
		# uri URI.join(API_URL, "/users/#{id}")

		req = Net::HTTP::Get.new(uri)
		req['auth_token'] = token
		res = Net::HTTP.start(uri.hostname, uri.port) {|http|
		  http.request(req)
		}
		puts res.body if res.is_a?(Net::HTTPSuccess)	
		@user = OpenStruct.new JSON.parse(res.body)
		# @user = user.to_hash
		# puts @user.inspect

	end

	

	# Update Users name and username through API
	def update
		# id = @user["id"] 
		token = @user["auth_token"]
		uri = UriCreaterServices.create_uri("/users/#{id}")
		req = Net::HTTP::Put.new(uri)
		req.set_form_data("user[name]" => "#{params[:user][:name]}", "user[username]"  => "#{params[:user][:username]}")
		req['auth_token'] = token
		
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end
		# puts res.body if res.is_a?(Net::HTTPSuccess)
		# JSON.parse(res.body)

		if res.is_a?(Net::HTTPSuccess)
			session["user"]= JSON.parse(res.body)
			@user= JSON.parse(res.body)
			redirect_to action: 'show'
		else
			render :edit
		end
	end


# To create session 
	def login
	end

	def user_login
		# uri = URI.join(API_URL, "/user/login")
		res = Net::HTTP.post_form URI(UriCreaterServices.create_uri("/user/login")), 
			{"username" => "#{params[:username]}", "password" => "#{params[:password]}" }
		#res = http.post(BASE_URL, user_params.to_query)
		puts res.body if res.is_a?(Net::HTTPSuccess)
		session["user"]= JSON.parse(res.body)
		@user= JSON.parse(res.body)
		# puts "session"
		puts session["user"]

		redirect_to action: 'show'

	end 

# To logout and destroy sesssion
	
	def destroy
		if session["user"] 
			id = @user["id"]
			token = @user["auth_token"]
			uri = UriCreaterServices.create_uri("/user/#{id}")
			# uri = URI.join(API_URL, "/user/#{id}")

			req = Net::HTTP::Get.new(uri)
			req['auth_token'] = token
			res = Net::HTTP.start(uri.hostname, uri.port) {|http|
			  http.request(req)
			}

			@user = nil
			session["user"] = nil;
			@user = nil

			if res.is_a?(Net::HTTPSuccess)
				render :login
			else
				render :edit
			end

		else
			render :login
		end

	end



	private

	# Set user based on login 
	def set_user
      #@user = User.find(params[:id])
       @user = session["user"] 
    end

	# Only autanticated params are allowed 

	def user_params
		params.require(:user).permit(:name, :username,:password, :password_confirmation)
	end

	# def authenticate
	# 	if session["user"]
	# 		end
	# end
end	






# OLD is working and Start from here

#  	BASE_URL = URI('http://localhost:4000/users')
# 	BASE_URL1 = URI('http://localhost:4000')
	
# 	BASE_URL3 = URI('http://localhost:4000/users/3')
# 	BASE_URL2 = URI('http://localhost:4000/user/login')
#	localhost:4000/users?user[name]=rawat4&user[username]=rawat14&user[password]=123454&user[password_confirmation]=123454
#   before_action :set_user, only: [ :edit, :update, :destroy]
 

 
# 		Old Edit function working perfectly
# 	def edit
# 		req = Net::HTTP::Get.new(BASE_URL3)
# 		req['auth_token'] = "710fb5d3f0c5a90b862ed4796676c5d21bb6447700a82a524373ca8c08b9d707"
# 		res = Net::HTTP.start(BASE_URL3.hostname, BASE_URL3.port) {|http|
# 		  http.request(req)
# 		}
# 		puts res.body if res.is_a?(Net::HTTPSuccess)
# 		
#  this OpenStruct .new method is need to be expelored		
# 		@user = OpenStruct.new JSON.parse(res.body)
# 		#@user = user.to_hash
# 		puts @user.inspect
# 	end




# 	 def update	
# 		req = Net::HTTP::Put.new(BASE_URL3)
# 		req.set_form_data("user[name]" => "#{params[:user][:name]}", "user[username]"  => "#{params[:user][:username]}")
# 		req['auth_token'] = "710fb5d3f0c5a90b862ed4796676c5d21bb6447700a82a524373ca8c08b9d707"
# 		res = Net::HTTP.start(BASE_URL3.hostname, BASE_URL3.port) do |http|
# 		  http.request(req)
# 		end
# 		puts res.body if res.is_a?(Net::HTTPSuccess)
# 		JSON.parse(res.body)
# 	end




# To show user data after login

	# def show
	# 	# 	puts params
	# 	# debugger
	# 	#response.set_header('auth_token', '710fb5d3f0c5a90b862ed4796676c5d21bb6447700a82a524373ca8c08b9d707')
	# 	req = Net::HTTP::Get.new(BASE_URL3)
	# 	req['auth_token'] = "710fb5d3f0c5a90b862ed4796676c5d21bb6447700a82a524373ca8c08b9d707"
	# 	res = Net::HTTP.start(BASE_URL3.hostname, BASE_URL3.port) {|http|
	# 	  http.request(req)
	# 	}
	# 	puts res.body if res.is_a?(Net::HTTPSuccess)
	# 	@user = JSON.parse(res.body)

	# end


# # To create session 
# 	def login
# 	end

# 	def user_login

# 		res = Net::HTTP.post_form URI(BASE_URL2), 
# 			{"username" => "#{params[:username]}", "password" => "#{params[:password]}" }
# 		#res = http.post(BASE_URL, user_params.to_query)
# 		puts res.body if res.is_a?(Net::HTTPSuccess)
# 		session["user"]= JSON.parse(res.body)
# 		puts "session"
# 		puts session["user"]

# 	end 

# # To logout and destroy sesssion

# 	def destroy
# 		if session["user"] 
# 			session[user] = nil;
# 			@user = nil
# 		else
# 			render action: :login
# 		end

# 	end



# 	private

# 	def set_user
#       #@user = User.find(params[:id])
#       @user = session["user"] 
#     end

# 	def user_params
# 		params.require(:user).permit(:name, :username,:password, :password_confirmation)
# 	end
