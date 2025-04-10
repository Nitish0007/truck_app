FactoryBot.define do
  factory :truck do
    registration_number { Faker::Vehicle.unique.license_plate }
    model { Faker::Vehicle.model }
    make { Faker::Vehicle.make }
  end
end