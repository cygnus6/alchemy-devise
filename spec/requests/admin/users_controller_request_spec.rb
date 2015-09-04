require 'spec_helper'

RSpec.describe Alchemy::Admin::UsersController, type: :request do
  before do
    authorize_user create(:alchemy_admin_user)
  end

  context 'with error happening while sending mail' do
    before do
      allow_any_instance_of(Alchemy::Admin::BaseController).
        to receive(:raise_exception?) { false }
      allow_any_instance_of(Alchemy::User).
        to receive(:deliver_welcome_mail) { raise(Net::SMTPAuthenticationError) }
    end

    context 'on create' do
      it 'does not raise DoubleRender error' do
        expect {
          post admin_users_path, user: attributes_for(:alchemy_user).merge(send_credentials: '1')
        }.to_not raise_error
      end
    end

    context 'on update' do
      it 'does not raise DoubleRender error' do
        user =  create(:alchemy_member_user)
        expect {
          patch admin_user_path(user), user: {send_credentials: '1'}
        }.to_not raise_error
      end
    end
  end
end