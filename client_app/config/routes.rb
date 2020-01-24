Rails.application.routes.draw do
  root 'pages#index'
  # root 'users#new'
  # get 'users/edit'
  # get 'users/show'
  # get 'users/login'
  # post 'user/create'

    controller :users do
      get 'users' => :index
    	get 'signup' => :new
    	post 'signup' => :create	
	    get 'signin' => :login
	    post 'signin' => :user_login
	    get 'edit' => :edit
	    post 'edit' => :update
	    get 'logout' => :destroy
	    get 'show' => :show
  	end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
