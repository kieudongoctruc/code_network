require 'rails_helper'

RSpec.describe 'Posts', type: :request do
  let(:url) { '/api/v1/posts' }
  let!(:user) { FactoryGirl.create :user }
  let!(:other_user) { FactoryGirl.create :user, username: 'ta_la_sieu_nhan' }
  let(:content) { Faker::Lorem.sentence }
  let(:post_params) { { content: content } }

  describe 'POST create a new post' do
    context 'when user is not in the system' do
      it 'returns error unauthorized' do
        post url, params: post_params.merge(username: 'someone')
        expect(response).to have_http_status 401
        expect(error_message).to eql I18n.t('error.unauthorized')
      end
    end

    context 'when user is in the system, and send valid params' do
      it 'returns post object, request successfully' do
        post url, params: authen_params(user).merge(post_params)
        expect(response).to have_http_status 201
        expect(json.with_indifferent_access[:creator][:id]).to eql user.id
        expect(json.with_indifferent_access[:content]).to eql content
      end
    end
  end

  describe 'GET all posts' do
    before do
      FactoryGirl.create(:post, creator: user)
      FactoryGirl.create(:post, creator: other_user)
    end
    context 'when user is not in the system' do
      it 'returns error unauthorized' do
        get url, params: { username: 'someone' }
        expect(response).to have_http_status 401
        expect(error_message).to eql I18n.t('error.unauthorized')
      end
    end

    context 'when user is in the system' do
      it 'returns list all posts, request successfully' do
        get url, params: authen_params(user)
        expect(response).to have_http_status 200
        expect(json.length).to eql 2
      end
    end
  end
end
