require 'rails_helper'

RSpec.describe 'User Signup', type: :request do
  describe 'POST /api/v1/users/sign_up' do
    let(:valid_params) do
      {
        user: {
          name: 'John Doe',
          email: 'john@example.com',
          password: 'secure123',
          password_confirmation: 'secure123',
          phone: '1234567890',
          role: :admin
        }
      }
    end

    it "register the new user with valid data" do
      post '/api/v1/users/sign_up.json' , params: valid_params

      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["message"]).to eq("User Signed Up successfully")
      expect(json['user']['email']).to eq('john@example.com')
    end

    it "return error message if data is invalid" do
      post '/api/v1/users/sign_up.json', params: { user: { email: '', password: '' } }

      expect(response).to have_http_status(:unprocessable_entity)
      json = JSON.parse(response.body)
      expect(json['errors']).to be_present
    end
  end
end