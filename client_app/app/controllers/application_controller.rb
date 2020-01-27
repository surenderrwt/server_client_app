class ApplicationController < ActionController::Base

	def set_user
		 if !session[:user_id]
       		redirect_to controller: "sessions", action: "new"
       	else 
       		@user = session[:user_id] 
       	end
    end
end
