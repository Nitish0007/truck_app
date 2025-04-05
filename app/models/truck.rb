class Truck < ApplicationRecord
  has_many :rides

  has_one :document
end