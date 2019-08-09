class RegistrationsController < ApplicationController
  layout 'login_sign_up', only: [:new, :create]
  skip_before_action :require_current_user, except: [:edit, :update]

  def new
    @create_account = CreateAccount.new
  end

  def create
    @create_account = CreateAccount.execute create_account_params
    if @create_account.success?
      reset_session
      login_session = create_login_session(@create_account.user)
      set_login_session(login_session)
      redirect_to root_path, notice: "Account created"
    else
      render :new
    end
  end

  def edit
    @update_account_profile = UpdateAccountProfile.new user: Current.user
    @update_account_profile.load_parameters_from_user
  end

  def update
    user = User.find Current.user.id # because we don't want to leave Current.user in an invalid state if update fails.
    @update_account_profile = UpdateAccountProfile.execute update_account_profile_params.merge(user: user)

    if @update_account_profile.success?
      redirect_to root_path, notice: "Account updated"
    else
      render :edit
    end
  end

  private 
  
  def update_account_profile_params
    params.require(:update_account_profile).permit :email, :time_zone, :password, :password_confirmation, :current_password
  end

  def create_account_params
    params.require(:create_account).permit(:email, :password, :password_confirmation).merge(
      time: Time.zone.now,
      client_ip: request.remote_ip
    )
  end

end