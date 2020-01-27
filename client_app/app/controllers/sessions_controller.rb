class SessionsController < ApplicationController
	# before_action :authenticate_access, only: [:new, :create ]

	def new
	end

	def create
		res = Net::HTTP.post_form URI(UriCreaterServices.create_uri("/user/login")), 
			{"username" => "#{params[:username]}", "password" => "#{params[:password]}" }
		puts res.body if res.is_a?(Net::HTTPSuccess)
		@user= JSON.parse(res.body)
		puts session[:user_id] = @user["id"]
		puts session[:auth_token] = @user["auth_token"]
		flash[:alert] = 'Welcome back!!!.' 
		redirect_to show_url(@user)
	end

	def logout
		if session[:user_id]
			uri = UriCreaterServices.create_uri("/logout/user/#{@user}")
			req = Net::HTTP::Get.new(uri)
			req['auth_token'] = session["auth_token"] 
			res = Net::HTTP.start(uri.hostname, uri.port) {|http|
			  http.request(req)
			}
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

	# def authenticate_access
	# 	if session[:user_id]
	# 		redirect_to controller: "users", action: "show"
	# 	else
	# 		redirect_to controller: "sessions", action: :new
	# 	end
	# end

	def user_params
      	params.permit(:username, :password)
    end

end
