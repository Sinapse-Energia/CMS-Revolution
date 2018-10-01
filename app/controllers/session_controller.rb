class SessionController < ApplicationController
	def index
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      cookies[:token] = user.token
      puts user.id
      puts user.token
      render :json => { status: true, notice: 'login successful' }
    else
      flash[:error]= "Email or password is invalid"
      # redirect_to root_path
      puts "Fail"
      render :json => { status: true, notice: 'login successful' }
    end     
  end

  def register
    @user = User.new
  end

  def create_register
    @user_email =  User.find_by(email: user_params[:email])
    @user_phone = User.find_by(phone: user_params[:phone])
    if @user_email
      flash[:notice] = "This email is taken by another user"
      redirect_to register_path
    elsif @user_name
      flash[:notice] = "User name is taken by another user"
      redirect_to register_path
    elsif @user_phone 
      flash.notice = "Phone number is taken by another user"
      redirect_to register_path
    elsif 
      @user = User.new
      @user.name = user_params[:name]
      @user.phone = user_params[:phone]
      @user.email = user_params[:email]
      @user.password = user_params[:password]
      if @user.save
        session[:user_id] = @user.id
        cookies[:token] = @user.token
        UserMailer.welcome_user(@user)
        # puts "Hello"
        redirect_to dash_path
      else
        flash[:notice] = "email and password are incorrect"
        redirect_to register_path
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
