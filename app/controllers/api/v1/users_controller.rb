class Api::V1::UsersController < ApplicationController
  before_action :allow_admin_only, only: [:index]

  def index
    # fetch list of drivers
    users = User.includes(:documents).where(role: 1)
    render json: users.as_json(
      only: [:id, :name, :email, :phone, :license_number, :license_expiry_date],
      include: {
        documents: {
          only: [:id, :document_type, :source_class, :created_at, :updated_at],
          methods: [:file_url]
        }
      }
      ), status: :ok
  end

  def show
    user = User.find_by(id: params[:user_id])
    unless user.present?
      render json: { errors: ['User not found']}, status: :not_found
    end
    render json: user.as_json(
      only: [:id, :name, :email, :phone, :license_number, :license_expiry_date, :role],
      include: {
        documents: {
          only: [:id, :document_type, :source_class, :created_at, :updated_at],
          methods: [:file_url]
        }
      }
    )
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
    params.require(:user).permit(:name, :phone, :license_number, :license_expiry_date)
  end

  def reset_password_params
    params.permit(:password, :password_confirmation)
  end
end