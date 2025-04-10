class Api::V1::RidesController < ApplicationController
  # before_action :allow_driver_only, only: [:create, :update]

  def index
    if current_user.driver?
      # filter driver specific rides
      rides = Ride.includes(:worksheet, :pre_check).where(user_id: params[:user_id]) if params[:user_id].present?
    else # for admin users only
      filters = {}
      filters[:user_id] = params.dig(:filter_by, :user_id) if params.dig(:filter_by, :user_id).present?
      filters[:truck_id] = params.dig(:filter_by, :truck_id) if params.dig(:filter_by, :truck_id).present?
      filters[:start_location] = params.dig(:filter_by, :start_location) if params.dig(:filter_by, :start_location).present?
      filters[:end_location] = params.dig(:filter_by, :end_location) if params.dig(:filter_by, :end_location).present?
      rides = Ride.includes(:worksheet, :pre_check).where(filters)
      if params.dig(:filter_by, :start_date).present? && params.dig(:filter_by, :end_date).present?
        # date_should be in iso format from fronend
        start_date = Time.zone.parse(params.dig(:filter_by, :start_date)).beginning_of_day
        end_date   = Time.zone.parse(params.dig(:filter_by, :end_date)).end_of_day

        rides = rides.joins(:worksheet).where(
          worksheets: {
            started_on: start_date..end_date,
            completed_on: start_date..end_date
          }
        )
      end
    end

    # order by newest updated ride
    rides = rides.order(updated_at: :desc)
    page = params[:page] || 1
    per_page = params[:per_page] || 10
    total_count = rides.count
    
    paginated_rides = rides.page(page).per(per_page)
    render json: { 
      data: paginated_rides.as_json(
        include: [:worksheet, :pre_check],
        methods: [:ride_documents]
      ),
      meta: {
        total_pages: paginated_rides.total_pages,
        total_count: rides.count,
        page: page.to_i,
        per_page: per_page.to_i
      }
    }, status: :ok
  end

  def create
    ride = Ride.new(ride_params)
    ride.user = current_user

    if ride.worksheet.present?
      if current_user.admin?
        ride.worksheet.user_id = params[:ride][:user_id]
      else
        ride.worksheet.user_id = current_user.id
      end
    end
    
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
    render json: { data: {ride: ride, worksheet: ride.worksheet, pre_check: ride.pre_check, driver: ride.driver, truck: ride.truck} }, status: :ok
  end

  def update
    ride = Ride.find_by_id(params[:id])
    permitted_params = ride_params.to_h

    if permitted_params.dig("worksheet_attributes", "id").blank?
      permitted_params.delete("worksheet_attributes")
    end

    if permitted_params.dig("pre_check_attributes", "id").blank?
      permitted_params.delete("pre_check_attributes")
    end
    
    unless ride.present?
      return render json: { errors: ["Ride not found"] }, status: :not_found
    end

    if current_user.driver? && ride.user_id != current_user.id
      return render json: { errors: ["User can't update this ride"] }, status: :forbidden
    end

    if ride.worksheet.present?
      if current_user.admin?
        ride.worksheet.user_id = params[:ride][:user_id]
      else
        ride.worksheet.user_id = current_user.id
      end
    end

    if current_user.admin? || ride.is_ride_editable_or_deletable?
      if ride.update(permitted_params)
        render json: { data: {ride: ride, worksheet: ride.worksheet, pre_check: ride.pre_check, driver: ride.driver, truck: ride.truck} }, status: :ok
      else
        render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["This Ride can't be edited as its already completed"] }, status: :unprocessable_entity
    end
  end

  def destroy
    ride = Ride.find_by(id: params[:id])
  
    unless ride.present?
      return render json: { errors: ["Ride not found"] }, status: :not_found
    end
  
    end_date = ride.worksheet&.completed_on&.in_time_zone&.to_date

    if current_user.admin? || ride.is_ride_editable_or_deletable?
      if ride.destroy
        render json: { message: "Ride deleted successfully" }, status: :ok
      else
        render json: { errors: ride.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { errors: ["This ride can't be deleted as its already completed"] }, status: :unprocessable_entity
    end
  end
  

  private
  def ride_params
    params.require(:ride).permit(
      :truck_id, :start_location, :end_location,
      worksheet_attributes: [:id, :start_kms, :end_kms, :started_on, :completed_on],
      pre_check_attributes: [
        :id,
        { truck_inspection: {} }, 
        { trailer_inspection: {} }, 
        { driver_self_inspection: {} }
      ]
    )
  end
end