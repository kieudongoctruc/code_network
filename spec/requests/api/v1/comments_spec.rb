require 'rails_helper'

RSpec.describe 'Comments', type: :request do
  let(:user) { FactoryGirl.create :user }
  let(:post1) { FactoryGirl.create(:post, creator: user) }
  let(:url) { "/api/v1/posts/#{post1.id}/comments" }
  let(:content) { Faker::Lorem.sentence }
  let(:comment_params) { { content: content } }

  describe 'POST create a new comment in a post' do
    context 'when user is not in the system' do
      it 'returns error unauthorized' do
        post url, params: comment_params.merge(username: 'someone')
        expect(response).to have_http_status 401
        expect(error_message).to eql I18n.t('error.unauthorized')
      end
    end

    context 'when user is in the system, and send valid params' do
      it 'returns post object, request successfully' do
        post url, params: authen_params(user).merge(comment_params)
        expect(response).to have_http_status 201
        expect(json.with_indifferent_access[:creator][:id]).to eql user.id
        expect(json.with_indifferent_access[:post][:id]).to eql post1.id
        expect(json.with_indifferent_access[:content]).to eql content
      end
    end
  end
end
