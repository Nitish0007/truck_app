class Api::V1::UsersController < ApplicationController

  def show
    user = User.find_by(id: params[:user_id])
    unless user.present?
      render json: { errors: ['User not found']}, status: :not_found
    end
    render json: user.as_json(only: [:id, :name, :email, :phone, :license_number, :license_expiry_date, :role])
  end

  # This is for update profile parameters not passwords
  def update
    user = User.find_by_id params[:user_id]
    if user.present?
      if user.update(update_params)
        render json: {
          message: "User Updated successfully",
          user: user.as_json(only: [:id, :name, :email, :phone, :license_number, :license_expiry_date])
        }, status: :ok
      else
        render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["User not Found!"] }, status: :not_found
    end
  end

  def reset_password
    user = User.find_by(id: params[:user_id])
    
    if user.nil?
      return render json: { errors: ["User not found"] }, status: :not_found
    end
    
    unless params[:old_password].present?
      return render json: { errors: ["Old password is required"] }, status: :unprocessable_entity
    end

    unless user.valid_password?(params[:old_password])
      return render json: { errors: ["Incorrect old password"] }, status: :unprocessable_entity
    end

    if user.update(reset_password_params)
      render json: { message: "Password reset successfully" }, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def update_params
    params.require(:user).permit(:name, :email, :phone, :license_number, :license_expiry_date, :license_id, :visa_id, :passport_id, :medical_certificate_id, :police_check_id, :license_history_id)
  end

  def reset_password_params
    params.permit(:password, :password_confirmation)
  end
end