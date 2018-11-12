class SessionController < ApplicationController
  skip_before_action :verify_authenticity_token
  
	def index
  end
def new
   @user = User.new
end
  def create_session
    user = User.find_by(email: params[:user][:email])
    if user && user.authenticate(params[:user][:password])
      session[:user_id] = user.id
      cookies[:token] = user.token
      # render ('create_session')
      redirect_to devices_path
    else
      flash[:error]= "Email or password is invalid"
      redirect_to root_path
    end     
  end

  def register
  end

  def create_register
    @user =  User.find_by(email: user_params[:email])
    if @user.try(:email).present?
      flash[:notice] = "This email is taken by another user"
      redirect_to register_session_index_path
    else 
      @user = User.new
      @user.first_name = user_params[:first_name]
      @user.last_name = user_params[:last_name]
      @user.email = user_params[:email]
      @user.password = user_params[:password]
      if @user.save
        session[:user_id] = @user.id
        cookies[:token] = @user.token
        UserMailer.welcome_user(@user)
        # flash[:notice] = "Sign up successfully"
         render ('index')
      else
        redirect_to root_path, notice: "email or password incorrect"
      end
    end
  end

  def forget_password
  end
  
  def reset_password
    @user = User.find_by(email: params[:email])
    if @user.present?
      @url  = "http://localhost:3000/session/change_password_view?id=#{@user.id}"
      UserMailer.reset_password_email(@user, @url).deliver_now
      flash[:notice] = " An email has been sent to reset your password "
      redirect_to root_path
    else
      flash[:notice] = "Email does not Exists. Please provide valid email"
     end
  end

  def change_password_view
  end

  def change_password
    @user = User.find_by(id: params[:id])
    if @user
      @user.update_attributes!(password: params[:password])
      redirect_to root_path
    else
      flash[:notice] = "No user exists"
    end
  end

  def logout
    session[:user_id] = nil
    cookies[:token] = nil
    redirect_to root_path
  end

  def edit
    @user = User.find_by(id: params[:id])
    respond_to do |format|
      format.js
    end
  end

def update
  params.permit!
  @user = User.find_by(id: params[:user][:id])
    if  @user && @user.authenticate(params[:user][:current_password])
      # if params[:user][:password] == params[:user][:password_confirmation]
        @user.update!(user_update_params)
      # end 
    end
   redirect_to devices_path
end  
  protected
  def user_update_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :user_name, :avatar)
  end

  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :user_name)
  end

end
