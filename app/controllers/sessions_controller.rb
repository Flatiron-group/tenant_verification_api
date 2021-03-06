class SessionsController < ApplicationController

  def create
    user = Landlord.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      user_id = user.id
      token = JWT.encode({user_id: user_id}, ENV['SECRET_TOKEN'])
      render json: {token: token}
    else
      render json: {error: true}
    end
  end

  def get_current_user
    token = request.headers['Authorization']
    user_id = decoded_token(token)[0]["user_id"]
    Landlord.find(user_id)
  end

  def destroy
    # not sure what to put here since the token would be destroyed
    # on the front end
  end

  private

  def decoded_token(token)
    begin
      JWT.decode(token, ENV['SECRET_TOKEN'])
    rescue JTWT::DecodeError
      nil
    end
  end

end
