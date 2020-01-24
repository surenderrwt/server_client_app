class UsersController < ApplicationController
  #before_action :authenticate_user, except: [:index]
  before_action :set_user, only: [:edit, :show, :update, :destroy]
  

  # GET /users
  def index
    @users = User.all

    render json: @users
    #response.headers["X-AUTH-TOKEN"] = "auth_token"
  end

  # GET /users/1
  def show
    render json: @user
  end

  # POST /users
  def create
    @user = User.new(user_params)

    if @user.save
      render json: @user, status: :created, location: @user
    else
      render json: @user.errors, status: :unprocessable_entity	
    end
  end

  # PATCH/PUT /users/1
  def update
    if @user.update(user_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # DELETE /users/1
  def destroy
    @user.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
    	# puts request.headers
    	# debugger
      #@user = User.where(id: params[:id], auth_token: params[:auth_token])
      token = authenticate_user
      @user = User.where(id: params[:id], auth_token: token).first

		# HTTP_AUTH_TOKEN
    end

    # Only allow a trusted parameter "white list" through.
    def user_params
      params.require(:user).permit(:name, :username, :password, :password_confirmation)
    end

	def authenticate_user
 	 	if request.headers["HTTP_AUTH_TOKEN"].present? 
	      	return request.headers["HTTP_AUTH_TOKEN"]
	  else 
	    	nil
	  end
	end
end
