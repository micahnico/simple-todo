class CreateAccount < CommandModel::Model
  attr_reader :user

  parameter :email, :password, :password_confirmation
  parameter :time, presence: true
  parameter :client_ip, presence: true

  def load_parameters_from_user
    set_parameters user.slice(:email)
  end

  def execute
    unless password === password_confirmation
      errors.add :base, "Password confirmation does not match password"
      return
    end

    unless @user = User.create!(user_params)
      @user.errors.each do |attr, msg|
        errors.add attr, msg
      end
    end
  end

  private def user_params
    parameters.slice(:email, :password, :password_confirmation)
  end
end
