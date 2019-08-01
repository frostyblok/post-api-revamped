require 'rails_helper'

RSpec.describe UsersController, type: :request do
  let(:user) { build(:user) }
  let(:valid_credentials) do
    attributes_for(:user, password_confirmation: user.password)
  end
  valid_headers = { 'CONTENT_TYPE' => 'application/json' }
  let(:headers) { valid_headers }

  describe 'Signup' do
    context 'when credentials are valid' do
      before do
        post '/signup',
             params: valid_credentials.to_json, headers: headers
      end
      it 'should successfully sign up' do
        expect(response).to have_http_status(201)
      end
      it 'should return a token' do
        expect(json['token']).not_to be_nil
      end
      it 'should return a success message' do
        expect(json['message']).to match(/User successfully created/)
      end
    end

    context 'when credentials are invalid/empty' do
      before { post '/signup', params: {} }
      it 'should return a 422 status code' do
        expect(response).to have_http_status(422)
      end
      it 'should return an error message' do
        expect(response.body).to include('Validation failed')
      end
    end
  end

  describe 'POST /login' do
    let(:user) { create(:user) }
    let(:headers) { valid_headers.except('Authorization') }
    let(:valid_credentials) do
      {
        email: user.email,
        password: user.password
      }.to_json
    end
    let(:invalid_credentials) do
      {
        email: 'email@email.com',
        password: 'password'
      }.to_json
    end

    context 'when the request is valid' do
      before do
        post '/login', params: valid_credentials, headers: headers
      end

      it 'returns authentication token' do
        expect(json['auth_token']).not_to be_nil
      end
      it 'returns login successful message' do
        expect(json['message']).to eq('Login successful!')
      end
    end

    context 'when the request is invalid' do
      before do
        post '/login', params: invalid_credentials, headers: headers
      end

      it 'returns invalid credentials error' do
        expect(response.body).to match(/Invalid credentials/)
      end

      it 'returns 401 status code' do
        expect(response.status).to eq(401)
      end
    end
  end
end
