class UsersController < ApplicationController
	before_action :set_user, except: [:new, :create]
	before_action :authenticate_access, only: [:new, :create]
	
	# Registration form  	
	def new
	end

	# Post registration from data to API
	def create
		res = Net::HTTP.post_form(UriCreaterServices.create_uri("/users"),
			 "user[name]" => "#{params[:user][:name]}",
			 "user[username]" => "#{params[:user][:username]}", 
			 "user[password]" => "#{params[:user][:password]}", 
			 "user[password_confirmation]" => "#{params[:user][:password_confirmation]}")
		puts res.body if res.is_a?(Net::HTTPSuccess)
		if res.is_a?(Net::HTTPSuccess)
		   	flash[:alert] = 'User was successfully registered, Please login here.' 
		   	render :login
		else
		  	flash[:alert] = "There is no user, Become the first"
		end
	end

	# Fetch and show USER details from API 
	def show
		uri = UriCreaterServices.create_uri("/users/#{session[:user_id]}")
		req = Net::HTTP::Get.new(uri)
		req['auth_token'] = session[:auth_token]
		res = Net::HTTP.start(uri.hostname, uri.port) {|http|
		  http.request(req)
		}
		puts res.body if res.is_a?(Net::HTTPSuccess)
		@user = JSON.parse(res.body)
	end
	
	# Fetch USER details from API and open edit form	
	def edit
		puts uri = UriCreaterServices.create_uri("/users/#{session[:user_id]}") 
		req = Net::HTTP::Get.new(uri)
		req['auth_token'] = session[:auth_token]
		res = Net::HTTP.start(uri.hostname, uri.port) {|http|
			http.request(req)
		}
		puts res.body if res.is_a?(Net::HTTPSuccess)	
		@user = OpenStruct.new JSON.parse(res.body)
	end

	# Post changes to update USER details(name & username only) to API
	def update	
		uri = UriCreaterServices.create_uri("/users/#{session[:user_id]}")
		req = Net::HTTP::Put.new(uri)
		req.set_form_data("user[name]" => "#{params[:user][:name]}", "user[username]"  => "#{params[:user][:username]}")
		req['auth_token'] = session[:auth_token]
		
		res = Net::HTTP.start(uri.hostname, uri.port) do |http|
		  http.request(req)
		end

		if res.is_a?(Net::HTTPSuccess)
			flash[:alert] = 'User was successfully updated.' 
			redirect_to action: 'show'
		else
			flash[:alert] = 'User is not updating' 
			render :edit
		end
	end


	private

	def authenticate_access
		if session[:user_id]
			redirect_to controller: "users", action: "show" 
		end
	end

	def user_params
		params.require(:user).permit(:name, :username,:password, :password_confirmation)
	end
end	