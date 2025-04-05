class Api::V1::WorksheetsController < ApplicationController
  before_action :allow_driver_only, only: [:create, :update]

  def index
    if current_user.admin? 
      filters = {}
      filters[:user_id] = params.dig(:filter_by, :user_id) if params.dig(:filter_by, :user_id).present?
      filters[:ride_id] = params.dig(:filter_by, :ride_id) if params.dig(:filter_by, :ride_id).present?
      worksheets = Worksheet.where(filters)

      truck_id = params.dig(:filter_by, :truck_id)
      if truck_id.present?
        ride_ids = Ride.where(truck_id: truck_id).pluck(:id)
        worksheets = worksheets.where(ride_id: ride_ids)
      end
    else
      worksheets = Worksheet.where(user_id: params[:user_id], ride_id: params[:ride_id])
    end

    render json: { data: worksheets }, status: :ok
  end

  def create
    w = Worksheet.new(worksheet_params)
    w.user = current_user
    if w.save
      render json: { data: w }, status: :created
    else
      render json: { errors: w.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    w = Worksheet.find_by(id: params[:id])
    if w.update_attributes(worksheet_params)
      render json: { data: w }, status: :ok
    else
      render json: { errors: w.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def worksheet_params
    params.require(:worksheet).permit(:start_kms, :end_kms, :delivery_doc_id, :pickup_doc_id, :ride_id, :started_on, :completed_on)
  end
end