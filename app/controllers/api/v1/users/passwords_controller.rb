class Api::V1::Users::PasswordsController < Devise::PasswordsController
  respond_to :json
  skip_before_action :authenticate_request!, only: [:create]

  # Override Devise method to customize the reset password and to avoid multiple render errors
  def create
    user = User.find_by(email: params[:email])

    if user.present?
      # need to setup mailing to send token via mail only not in 
      user.send_reset_password_instructions
      render json: { message: "Password reset instructions sent", reset_password_token: user.reset_password_token }, status: :ok
    else
      render json: { errors: ["User not found"] }, status: :unprocessable_entity
    end
  end

  private
  # # Override Devise method to customize the reset password response
  # def respond_with(resource, _opts = {})
  #   if resource.errors.empty?
  #     render json: { message: "Password reset instructions sent to #{resource.email}" }, status: :ok
  #   else
  #     render json: { errors: resource.errors.full_messages }, status: :unprocessable_entity
  #   end
  # end

  # # Override method for successful password reset
  # def after_resetting_password_path_for(resource)
  #   render json: { message: "Password reset successfully" }, status: :ok
  # end
end