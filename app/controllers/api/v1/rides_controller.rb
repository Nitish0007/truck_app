class Api::V1::RidesController < ApplicationController
  before_action :allow_driver_only, only: [:create, :update]

  def index
    if current_user.role == 1
      # filter driver specific rides
      rides = rides.where(user_id: params[:user_id]) if params[:user_id].present?
    else # for admin users only
      rides = Ride.all
      # if admin wants driver specific rides, then in params we need driver_id
      rides = rides.where(user_id: params[:driver_id]) if params[:driver_id].present?
    end
    # filter truck specific rides
    rides = rides.where(truck_id: params[:truck_id]) if params[:truck_id].present?

    # order by newest updated ride
    rides = rides.order(updated_at: :desc)
    render json: { data: rides }, status: :ok
  end

  def create
    ride = Ride.new(ride_params)
    ride.user = current_user
    if ride.save
      render json: { data: ride }, status: :created
    else
      render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def show
    ride = Ride.find_by_id(params[:id])
    unless ride.present?
      render json: { errors: ['Ride Not found'] }, status: :not_found
    end
    render json: { data: ride }, status: :ok
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
      render json: { data: ride }, status: :ok
    else
      render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def ride_params
    params.require(:ride).permit(:truck_id, :start_location, :end_location)
  end
end