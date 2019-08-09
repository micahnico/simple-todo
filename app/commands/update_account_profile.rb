class UpdateAccountProfile < CommandModel::Model
  parameter :user, presence: true
  parameter :email, :time_zone, :password, :password_confirmation
  parameter :current_password

  def load_parameters_from_user
    set_parameters user.slice(:email)
  end

  def execute
    unless user.authenticate(current_password)
      errors.add :base, "Incorrect current password"
      return
    end

    unless password === password_confirmation
      errors.add :base, "Password confirmation does not match new password"
      return
    end

    unless user.update user_params
      user.errors.each do |attr, msg|
        errors.add attr, msg
      end
    end
  end

  private def user_params
    parameters.slice(:email, :time_zone, :password, :password_confirmation)
  end
end
