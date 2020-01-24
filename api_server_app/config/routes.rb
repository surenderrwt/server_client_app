Rails.application.routes.draw do
	  resources :users, except: [:destroy]
	 # resources :users
	  post 'user/login' => 'sessions#create' 
	  get 'user/:id'	=> 'sessions#destroy'																		


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
