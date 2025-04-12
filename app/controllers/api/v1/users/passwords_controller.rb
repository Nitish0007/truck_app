class Api::V1::Users::PasswordsController < Devise::PasswordsController
  skip_before_action :validate_request_format, only: [:edit]
  skip_before_action :authenticate_request!, only: [:create, :edit]
  skip_before_action :verify_authenticity_token
  respond_to :json, except: [:edit]
  respond_to :html, only: [:edit]

  # Override Devise method to customize the forgot password and to avoid multiple render errors
  def create
    if params[:reset_password_token].present?
      user = User.reset_password_by_token(reset_password_params)
  
      if user.errors.empty?
        respond_to do |format|
          format.html { redirect_to api_v1_password_reset_success_path }
          format.json { render json: { message: "Password reset successfully" }, status: :ok }
        end
      else
        respond_to do |format|
          format.html do
            @token = params[:reset_password_token]
            @errors = user.errors
            render :edit, status: :unprocessable_entity
          end
          format.json { render json: { errors: user.errors.full_messages }, status: :unprocessable_entity }
        end
      end
    else
      user = User.find_by(email: params[:email])
  
      if user.present?
        user.send_reset_password_instructions
        render json: { message: "Password reset instructions sent to #{user.email}" }, status: :ok
      else
        render json: { errors: ["User not found"] }, status: :unprocessable_entity
      end
    end
  end
  

  def edit
    @token = params[:reset_password_token]
    user = User.with_reset_password_token(@token)

    unless user.present? && user.reset_password_period_valid?
      render plain: "Invalid or expired token", status: :forbidden
      return
    end
  
    render :edit
  end

  def password_reset_success
  end

  private
  def validate_request_format
    # defined it empty here because want to skip it, when request comes from devise controller
    # because in that case it doesn't respect 'skip_before_action' for callbacks which are defined in application controller
  end

  def reset_password_params
    params.permit(:reset_password_token, :password, :password_confirmation)
  end

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