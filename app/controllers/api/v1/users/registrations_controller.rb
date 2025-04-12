class Api::V1::Users::RegistrationsController < Devise::RegistrationsController
  skip_forgery_protection if: -> { request.format.json? } # to disable CSRF protection for API only requests
  skip_before_action :authenticate_request!, only: [:create]
  before_action :set_devise_mapping
  respond_to :json

  def create
    user = build_resource(sign_up_params)
    if user.save
      payload = {
        id: user.id,
        email: user.email,
        role: user.role
      }
      token = JwtToken.generate(payload)
      render json: {
        message: "User Signed Up successfully",
        user: user.as_json(only: [:id, :name, :email, :phone, :license_number, :license_expiry_date, :role]),
        token: token
      }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def sign_up_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation, :phone, :license_number, :license_expiry_date, :role)
  end

  def set_devise_mapping
    request.env["devise.mapping"] = Devise.mappings[:user]
  end
end