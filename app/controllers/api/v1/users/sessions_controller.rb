class Api::V1::Users::SessionsController < Devise::SessionsController
  skip_forgery_protection if: -> { request.format.json? }
  skip_before_action :authenticate_request!, only: [:create]
  respond_to :json

  def create
    user = User.find_by(email: sign_in_params[:email])
    if user.present? && user.valid_password?(sign_in_params[:password])
      payload = {
        id: user.id,
        email: user.email,
        role: user.role
      }
      token = JwtToken.generate(payload)
      render json: { message: "Logged in successfully", token: token }
    else
      render json: { message: "Invalid email or password" }, status: :unauthorized
    end
  end

  private
  def sign_in_params
    params.require(:user).permit(:email, :password)
  end

end