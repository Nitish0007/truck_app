class Api::V1::RidesController < ApplicationController
  before_action :allow_driver_only, only: [:create, :update]

  def index
    if current_user.driver?
      # filter driver specific rides
      rides = Ride.includes(:worksheet, :pre_check).where(user_id: params[:user_id]) if params[:user_id].present?
    else # for admin users only
      filters = {}
      filters[:user_id] = params.dig(:filter_by, :user_id) if params.dig(:filter_by, :user_id).present?
      filters[:truck_id] = params.dig(:filter_by, :truck_id) if params.dig(:filter_by, :truck_id).present?
      rides = Ride.includes(:worksheet, :pre_check).where(filters)
    end

    # order by newest updated ride
    rides = rides.order(updated_at: :desc)
    render json: { data: rides.as_json(
      include: [:worksheet, :pre_check]
    ) }, status: :ok
  end

  def create
    ride = Ride.new(ride_params)
    ride.user = current_user
    # if ride.worksheet.present?
    #   ride.worksheet.user_id = current_user.id
    # end
    if ride.save
      render json: { data: {ride: ride, worksheet: ride.worksheet, pre_check: ride.pre_check} }, status: :created
    else
      render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    ride = Ride.find_by_id(params[:id])
    unless ride.present?
      return render json: { errors: ['Ride Not found'] }, status: :not_found
    end
    render json: { data: {ride: ride, worksheet: ride.worksheet, pre_check: ride.pre_check} }, status: :ok
  end

  def update
    ride = Ride.find_by_id(params[:id])
    unless ride
      return render json: { errors: ["Ride not found"] }, status: :not_found
    end

    if ride.user_id != current_user.id
      return render json: { errors: ["User can't update this ride"] }, status: :forbidden
    end

    if ride.update(ride_params)
      render json: { data: {ride: ride, worksheet: ride.worksheet, pre_check: ride.pre_check} }, status: :ok
    else
      render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def ride_params
    params.require(:ride).permit(
      :truck_id, :start_location, :end_location, 
      # worksheet_attributes: [:start_kms, :end_kms, :started_on, :completed_on, :pickup_doc_id, :delivery_doc_id]
    )
  end
end