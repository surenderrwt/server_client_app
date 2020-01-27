class PagesController < ApplicationController
	http_basic_authenticate_with name: "surender", password: "rawat", only: :index

  	def index
  		res = UriCreaterServices.show_users("/users")
		@users = JSON.parse(res.body)
		if res.is_a?(Net::HTTPSuccess)
		   	flash[:alert] = 'User was successfully Listed.' 
		else
		  	flash[:alert] = "There is no user till date, Become the first"
		end
  	end
end
show_users