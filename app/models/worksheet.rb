class Worksheet < ApplicationRecord
  belongs_to :ride
  belongs_to :user
  has_many :documents

  before_save :match_with_ride_user

  private
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