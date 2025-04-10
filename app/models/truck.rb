class Truck < ApplicationRecord
  has_many :rides

  has_one :document

  def current_ride_and_driver_if_exists?
    latest_ride = rides.order(updated_at: :desc).try(:first)
    return {active_ride: nil, active_driver: nil} if latest_ride.nil?

    start_date = latest_ride&.worksheet&.started_on&.in_time_zone
    end_date = latest_ride&.worksheet&.completed_on&.in_time_zone
    # end_data will not be present if ride doesn't have worksheet doesn't have details, so can be evaluated as ride must not be compeleted yet.
    if !start_date.present? || !end_date.present?
      return {active_ride: latest_ride, active_driver: latest_ride.driver}
    else
      if start_date.present? && end_date.present? && Time.zone.now().to_date >= start_date.to_date && Time.zone.now().to_date <= end_date.to_date
        return {active_ride: latest_ride, active_driver: latest_ride.driver}
      end
    end

    return {active_ride: nil, active_driver: nil}
  end
end