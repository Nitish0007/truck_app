class Worksheet < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  has_many :documents

  validates :started_on, presence: true
  validates :start_kms, presence: true
  validate :ride_dates_validation

  before_save :match_with_ride_user

  private
  def ride_dates_validation
    # frontend should send datetime in given format
    # format -> "2025-04-05T09:00:00+10:00"
    # format name -> ISO8601
    start_date = started_on.present? ? started_on.in_time_zone.to_date : nil
    return if start_date.nil?
    end_date = completed_on.present? ? completed_on.in_time_zone.to_date : nil
    if start_date < Time.zone.today
      errors.add(:base, "Ride can't be started in past")
    end

    if end_date < start_date
      errors.add(:base, "Start date can't be ahead of End date")
    end

    if end_date.present?
      if (end_date - start_date).to_i > 15
        errors.add(:base, "Ride should be completed within 2 weeks, Contact admin if you want to be changed")
      end
    end
  end

  def match_with_ride_user
    ride = Ride.find_by(id: self.ride_id)
    unless ride.present?
      errors.add(:base, "Ride must exist")
      throw :abort
    end

    if self.user_id != ride.user_id
      errors.add(:base, "Ride does not belongs to this user")
      throw :abort
    end
  end
end