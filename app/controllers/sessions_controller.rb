class SessionsController < ApplicationController
  def create
    # find the email address
    email_address = EmailAddress.find_by(email: params[:session][:email].downcase)
    if email_address.nil?
      flash.now[:danger] = 'bad email'
      render 'new'
    else
      # authenticate the user
      if email_address.user.authenticate(params[:session][:password])
        if email_address.activated?
          log_in email_address.user
          params[:session][:remember_me] == '1' ?
            remember(email_address.user) : forget(email_address.user)
          redirect_to request.referrer || root_url
        else
          flash[:warning] = "Email address not activated.  Check your email for the activation link."
          redirect_to root_url
        end
      else
        flash.now[:danger] = 'bad password'
        render 'new'
      end
    end
  end

  def destroy
    log_out if logged_in?
    redirect_to root_url
  end
end
