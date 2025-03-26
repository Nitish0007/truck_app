class Ride < ApplicationRecord
  belongs_to :truck
  belongs_to :user # consider user as driver
end