# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticateUser do
  let(:user) { create(:user) }
  subject(:valid_user) { described_class.new(user.email, user.password) }
  subject(:invalid_user) { described_class.new('foo', 'bar') }

  describe 'authenticate' do
    it 'returns a valid user object' do
      token = valid_user.call
      expect(token).not_to be_nil
    end

    it 'does not return a valid user object' do
      expect { invalid_user.call }
        .to raise_error(
          ExceptionHandler::AuthenticationError,
          /Invalid credentials/
        )
    end
  end
end
