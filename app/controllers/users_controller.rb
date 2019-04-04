class UsersController < ApplicationController
  
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy, :show, :following]
  before_action :correct_user,   only: [:edit, :update, :followers]
  before_action :admin_user,     only: :destroy
  skip_before_action :verify_authenticity_token, :only => :create

  def show
    #@user = User.find(params[:id])
   @user = User.find_by(id: params[:id])
   if @user.blank?
     flash[:info] = "Users not exist."
     redirect_to request.referrer || root_url
   else
     redirect_to root_url and return unless @user.activated?
     @microposts = @user.microposts.paginate(page: params[:page])
   end
  end
  
  def index
    #@users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end


  def New
    @user = User.new
  end

  def create
    @user = User.new(user_params)    # Not the final implementation!
    if @user.save
       # log_in @user
       # flash[:success] = "Welcome to the Sample App!"
       # redirect_to @user
      # Handle a successful save.
      #UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = "Please check your email to activate your account."
      redirect_to root_url
    else
      render 'New'
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  
  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
        # Handle a successful update.
        flash[:success] = "Profile updated"
        redirect_to @user
    else
       render 'edit'
    end
  end

 def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
          params.require(:user).permit(:name, :email, :password,
                                        :password_confirmation)
    end

    # Before filters


    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
    
    # Confirms an admin user.
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end
