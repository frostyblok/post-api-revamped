require 'rails_helper'

RSpec.describe UsersController, type: :request do
	let(:user) { build(:user) }
	let(:valid_credentials) do
		attributes_for(:user, password_confirmation: user.password)
	end
	valid_headers = { 'CONTENT_TYPE' => 'application/json'}
	let(:headers) { valid_headers }


	describe 'Signup' do
		context 'when credentials are valid' do
			before { post '/signup', params: valid_credentials.to_json, headers: headers}
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
				expect(response.body).to include("Validation failed")
			end
		end
	end
end
