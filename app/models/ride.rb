class Ride < ApplicationRecord
  belongs_to :truck
  belongs_to :user # consider user as driver
  has_one :pre_check, dependent: :destroy
  has_one :worksheet, dependent: :destroy
  accepts_nested_attributes_for :worksheet
  accepts_nested_attributes_for :pre_check

  validate :check_active_rides_of_truck

  before_save :validate_associations

  def driver
    return user
  end

  def ride_documents
    docs = Document.where(worksheet_id: self.worksheet.id) if self.worksheet.present?
  end

  def is_ride_editable_or_deletable?
    end_date = self.worksheet&.completed_on&.in_time_zone&.to_date
    if end_date.present? && (end_date - Time.zone.today <= 2) || end_date.blank?
      return true
    end
    return false
  end

  private
  def validate_associations
    unless self.pre_check.present?
      self.errors.add(:base, "Pre check is required")
      throw :abort
    end

    # Ensure the pre-check is valid
    unless self.pre_check&.valid?
      self.pre_check.errors.full_messages.each do |msg|
        self.errors.add(:base, msg)
      end
    end
    unless self.errors.empty?
      throw :abort
    end
  end

  def check_active_rides_of_truck
    truck = Truck.find_by(id: self.truck_id)
    data = truck.current_ride_and_driver_if_exists?
    active_ride = data[:active_ride]
    active_driver = data[:active_driver]
    unless active_ride.nil?
      # start_date = latest_ride&.worksheet&.started_on
      end_date = active_ride&.worksheet&.completed_on
      if end_date.present? && end_date.to_date > Time.zone.today || end_date.blank?
        errors.add(:base, "Truck is already on another ride, ask driver(#{active_driver.name}) or admin, driver contact number: #{active_driver.phone}, email: #{active_driver.email}")
      end
    end
  end
end