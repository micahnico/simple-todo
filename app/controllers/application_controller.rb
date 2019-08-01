class ApplicationController < ActionController::Base
  before_action :set_current_request_details
  before_action :set_current_user
  before_action :require_current_user

  private

  def require_current_user
    redirect_to new_session_path unless Current.user
  end

  def set_current_user

    if cookies.permanent.encrypted[:remember_me] && !session[:login_session_id]
      session[:login_session_id] = cookies.permanent.encrypted[:remember_me]
    end

    Current.user = if session[:login_session_id]
      # This nifty bit of SQL finds the user and logs the request in a single
      # round trip. In addition, it disabled synchronous commit for just this
      # transaction to avoid waiting for the log update to be persisted.
      now = Time.zone.now
      User.find_by_sql([<<~SQL, now, request.remote_ip, session[:login_session_id]]).first
        with synchronous_commit as (
          select set_config('synchronous_commit', 'off', true) as result
        ), ls as (
          update login_sessions
          set last_access_time=?,
            last_ip=?,
            request_count=request_count+1
          from synchronous_commit
          where id=?
            and logout_time is null
            and synchronous_commit.result='off'
          returning login_sessions.user_id
        ), u as (
          select users.*
          from users
            join ls on users.id=ls.user_id
        )
        select * from u;
      SQL
    end
  end

  def set_current_request_details
    Current.request_uuid = request.uuid
    Current.request_ip = request.remote_ip
  end

  def create_login_session(user)
    now = Time.zone.now

    LoginSession.create! user_id: user.id,
      login_time: now,
      login_ip: request.remote_ip,
      last_access_time: now,
      last_ip: request.remote_ip
  end

  def set_login_session(login_session)
    session[:login_session_id] = login_session.id
    cookies.permanent.encrypted[:remember_me] = {value: login_session.id, httponly: true}
  end
end
