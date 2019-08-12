require 'rails_helper'

RSpec.describe AuthorizeRequests do
  let(:user) { create(:user) }
  let(:header) { { 'Authorization' => token_generator(user.id) } }
  subject(:invalid_request) { described_class.new({}) }
  subject(:valid_request) { described_class.new(header) }

  describe '#call' do
    context 'when request is valid' do
      it 'returns user object' do
        response = valid_request.call
        expect(response[:user]).to eq(user)
      end
    end

    context 'when request is invalid' do
      it 'returns jwt decode error' do
        expect { invalid_request.call }
          .to raise_error(JWT::DecodeError, /Nil JSON web token/)
      end
    end
  end
end
