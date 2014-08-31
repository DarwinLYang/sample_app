class UsersController < ApplicationController
	before_action :signed_in_user, only: [:index, :edit, :update, :destroy]
	before_action :correct_user,   only: [:edit, :update]
	before_action :admin_user,     only: :destroy

	def index
    	@users = User.paginate(page: params[:page])
  	end
  	
	def show
		@user = User.find(params[:id])
	end

	def new
		unsigned_in_user
		@user = User.new
	end

	def create
		unsigned_in_user
		@user = User.new(user_params)
		if @user.save
			sign_in @user
			flash[:success] = "Welcome to the Sample App!"
			redirect_to @user
		else
			render 'new'
		end
	end

	def edit
	end

	def update
		if @user.update_attributes(user_params)
			flash[:success] = "Profile updated"
			redirect_to @user
		else
			render 'edit'
		end
	end

	def destroy
		# User.find(params[:id]).destroy
		# flash[:success] = "User deleted."
		# redirect_to users_url

		@user = User.find(params[:id])
		if !current_user?(@user)
			@user.destroy
			flash[:success] = "User deleted."
		else
			flash[:error] = "Cannot delete current user."
		end
		redirect_to users_url
	end

	private

		def user_params
			params.require(:user).permit(:name, :email, :password, :password_confirmation)
		end

		# Before filters

		def signed_in_user
			unless signed_in?
				store_location
				redirect_to signin_url, notice: "Please sign in."
			end
		end

		def correct_user
			@user = User.find(params[:id])
			redirect_to(root_url) unless current_user?(@user)
		end

		def admin_user
			redirect_to(root_url) unless current_user.admin?
		end

		def unsigned_in_user
			redirect_to(root_url) unless !signed_in?
		end

end