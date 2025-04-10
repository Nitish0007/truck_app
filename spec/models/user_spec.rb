require 'rails_helper'

RSpec.describe User, type: :model do
  subject { build(:user) }
  describe 'validations' do
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_uniqueness_of(:email).case_insensitive }
  end

  describe "associations" do
    it { should have_many(:rides) }
    it { should have_many(:worksheets) }
    it { should have_many(:documents) }
  end
end