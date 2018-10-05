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
      puts user.id
      puts user.token
      render :json => { status: true, notice: 'login successful' }
    else
      flash[:error]= "Email or password is invalid"
      puts "Fail"
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
      @user.name = user_params[:first_name]
      @user.email = user_params[:email]
      @user.password = user_params[:password]
      if @user.save
        session[:user_id] = @user.id
        cookies[:token] = @user.token
        UserMailer.welcome_user(@user)
        # puts "Hello"
         render :json => { status: true, notice: 'Sign up successfully' }
      else
        flash[:notice] = "email and password are incorrect"
        redirect_to root_path
      end
    end
  end

  def forget_password
  end
  
  def reset_password
       @user = User.find_by(email: params[:email])
       if @user.present?
         ap @url  = "http://localhost:3000/session/change_password_view?id=#{@user.id}"
          UserMailer.reset_password_email(@user, @url).deliver_now
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
  private
  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :password, :phone, :user_name)
  end

end
