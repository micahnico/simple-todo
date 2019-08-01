# frozen_string_literal: true

class SessionsController < ApplicationController
  skip_before_action :require_current_user
  layout 'login_sign_up'

  def new
    @login = Login.new
  end

  def create
    @login = Login.execute login_params

    reset_session
    if @login.success?
      set_login_session(@login.session)
      redirect_to root_path, notice: "Signed in successfully"
    else
      render :new
    end
  end

  def destroy
    LoginSession.where(id: session[:login_session_id]).update_all ["logout_time=?", Time.zone.now]
    reset_session
    cookies.delete(:remember_me)
    redirect_to new_session_path, notice: "Logged out successfully"
  end

private

  def set_current_user
    Current.user = nil
  end

  def login_params
    params.require(:login).permit(:email, :password).merge(
      time: Time.zone.now,
      client_ip: request.remote_ip
    )
  end
end
