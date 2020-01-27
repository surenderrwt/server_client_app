class SessionsController < ApplicationController

    def create
      	@user = User.find_by(username: params[:username]);
      	if @user &.authenticate(params[:password])
      		token = generate_token
      		@user.update(auth_token: token )
      		render json: @user, status: :created, location: @user
      		response.headers["auth_token"] = token
      	else
      		render json: @user.errors, status: 401
      	end
    end

    def logout
        token = request.headers["HTTP_AUTH_TOKEN"]
      	user = User.where(id: params[:id], auth_token: token).first
      	if user && user.update(auth_token: nil )
      	    response.headers["auth_token"] = nil
            render status: 200, :json => {:message => "success"}.to_json
        else
            render status: 400, :json => {:status => "Unauthorized Access"}.to_json
        end    
    end

    private

    def generate_token
      		key = "Learining ruby on rails"
    		data = params[:password]
    		return mac = OpenSSL::HMAC.hexdigest("SHA256", key, data)
    end


    def session_params
        params.permit(:username, :password)
    end
end
