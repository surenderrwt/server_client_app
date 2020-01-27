class SessionsController < ApplicationController
	before_action :set_user, only: [:logout]
	before_action :authenticate_access, only:[:new, :create]

	def new
	end

	def create
		res = UriCreaterServices.login_user("/user/login", params)
		if res.is_a?(Net::HTTPSuccess)
			@user= JSON.parse(res.body)
			puts session[:user_id] = @user["id"]
			puts session[:auth_token] = @user["auth_token"]
			flash[:alert] = 'Welcome back!!!.' 
			redirect_to show_url(@user)
		else
			flash[:alert] = 'Username or password not mached'
			redirect_to action: "new"
		end

	end

	def logout
		if session[:user_id]
			res = UriCreaterServices.logout_user("/logout/user/#{@user}", session["auth_token"])
			if res.is_a?(Net::HTTPSuccess)
				reset_session
				@user = nil
				flash[:alert] = 'User was successfully Log out.' 
				redirect_to action: "new"
			else
				redirect_to show_url
			end
		else
			flash[:alert] = 'Please login or get registered' 
			redirect_to action: "new"
		end
	end


	private

	def authenticate_access
		if session[:user_id]
			redirect_to controller: "users", action: "show" 
		end
	end

	def user_params
      	params.permit(:username, :password)
    end

end
