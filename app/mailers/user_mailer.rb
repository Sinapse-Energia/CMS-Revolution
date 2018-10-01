class UserMailer < ApplicationMailer
	default from: "from@example.com"

	def welcome_user(user)
	@user = user
    mail(to: user, subject: 'Welcome')
	end

	def reset_password_email(user, url)
	@user = user
    @url = url
    mail(to: user, subject: 'Reset Password')
  end
end
