Rails.application.routes.draw do
    
    root 'pages#index'

    controller :sessions do 
        get     '/login'   =>      :new
        post    '/login'   =>      :create
        get     '/logout'  =>      :logout
    end

    controller :users do
    	get    'signup'    =>      :new
    	post   'signup'    =>      :create	
	    get    'edit'      =>      :edit
	    post   'edit'      =>      :update
	    get    'show'      =>      :show
  	end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
