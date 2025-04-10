FactoryBot.define do
  factory :user do
    name { Faker::Name.name }
    email { Faker::Internet.email }
    password { Faker::Internet.password(min_length: 8) }
    password_confirmation { password }
    phone { Faker::PhoneNumber.phone_number }
    license_number { Faker::DrivingLicence.usa_driving_licence }
    license_expiry_date { Faker::Date.forward(days: 23) }
    role { [0, 1].sample }
  end
end