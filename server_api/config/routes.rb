Rails.application.routes.draw do
	
	resources 	:users
	post 		'user/login' 			=> 		'sessions#create' 
	get 		'/logout/user/:id'		=> 		'sessions#logout'																		
end
