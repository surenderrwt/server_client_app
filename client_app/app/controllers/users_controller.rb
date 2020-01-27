class UsersController < ApplicationController
	before_action :set_user, except: [:new, :create]
	before_action :authenticate_access, only: [:new, :create]
	
	# Registration form  	
	def new
	end

	# Post registration from data to API
	def create
		res = UriCreaterServices.create_user("/users", params[:user])
		puts res.body if res.is_a?(Net::HTTPSuccess)
		if res.is_a?(Net::HTTPSuccess)
		   	flash[:alert] = 'User was successfully registered, Please login here.' 
		   	redirect_to login_url
		else
		  	flash[:alert] = "There is no user, Become the first"
		end
	end

	# Fetch and show USER details from API 
	def show
		res = UriCreaterServices.get_user("/users/#{@user}", session[:auth_token])
		puts res.body if res.is_a?(Net::HTTPSuccess)
		@user = JSON.parse(res.body)
	end
	
	# Fetch USER details from API and open edit form	
	def edit
		res = UriCreaterServices.edit_user("/users/#{@user}", session[:auth_token]) 
		puts res.body if res.is_a?(Net::HTTPSuccess)	
		@user = OpenStruct.new JSON.parse(res.body)
	end

	# Post changes to update USER details(name & username only) to API
	def update	

		res = UriCreaterServices.update_user("/users/#{@user}", params[:user], session[:auth_token])
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