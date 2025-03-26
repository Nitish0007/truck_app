class Api::V1::TrucksController < ApplicationController
  before_action :allow_admin_only, only: [:create, :update, :destroy]

  def index
    trucks = Truck.all
    render json: { data: trucks }, status: :ok
  end

  def create
    truck = Truck.new(truck_params)
    if truck.save
      render json: { data: truck }, status: :created
    else
      render json: { errors: truck.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    truck = Truck.find_by_id(params[:id])
    unless truck.present?
      render json: { errors: ['Truck not found'] }, status: :not_found
    end
    render json: { data: truck }, status: :ok
  end

  def update
    truck = Truck.find_by(id: params[:id])
    unless truck.present?
      render json: { errors: ['Truck not found'] }, status: :not_found
    end
    if truck.update(truck_params)
      render json: { data: truck }, status: :ok
    else
      render json: { errors: truck.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    truck = Truck.find_by_id(params[:id])
    unless truck.present?
      render json: { errors: ['Truck not found'] }, status: :not_found
    end

    if truck.destroy
      render json: { message: "Truck Removed successfully" }, status: :ok
    else
      render json: { errors: truck.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def truck_params
    params.require(:truck).permit(:registration_number, :model, :make, :image_id)
  end
end