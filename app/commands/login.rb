class Login < CommandModel::Model
  attr_reader :session

  parameter :email, presence: true
  parameter :password, presence: true

  parameter :time, presence: true
  parameter :client_ip, presence: true

  def execute
    user = User.where("email = :q", q: email).first

    if user&.authenticate(password)
      @session = LoginSession.create! user: user,
        login_time: time,
        login_ip: client_ip,
        last_access_time: time,
        last_ip: client_ip
    else
      errors.add :base, "Incorrect email or password"
    end
  end
end