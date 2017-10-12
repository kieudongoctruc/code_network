require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let(:url) { '/api/v1/users' }

  describe 'POST create a new user' do
    context 'when username has been existed' do
      before { FactoryGirl.create :user }

      it 'returns error username_existed' do
        user_params = { user: { username: 'truckieu' } }
        post url, params: user_params
        expect(response).to have_http_status 422
        expect(error_message).to eql I18n.t('error.username_existed')
      end
    end

    context 'when username contains white space' do
      it 'returns error no_space_in_username' do
        user_params = { user: { username: 'truc kieu' } }
        post url, params: user_params
        expect(response).to have_http_status 422
        expect(error_message).to eql I18n.t('error.no_space_in_username')
      end
    end

    context 'when params are valid' do
      it 'returns user object, request successfully' do
        user_params = { user: { username: 'ta_la_sieu_nhan' } }
        post url, params: user_params
        expect(response).to have_http_status 201
        expect(json.with_indifferent_access[:username]).to eql 'ta_la_sieu_nhan'
      end
    end
  end

  describe 'GET' do
    let(:user) { FactoryGirl.create :user }
    let(:other_user) { FactoryGirl.create :user, username: 'ta_la_sieu_nhan' }
    let(:other_user_posts_url) { "/api/v1/users/#{other_user.id}/posts" }
    let(:all_comments_url) { '/api/v1/users/posts/comments' }

    before do
      FactoryGirl.create_list(:post, 2, creator: other_user)
      FactoryGirl.create_list(:post, 1, creator: user)
    end

    context 'when user want to see a specific user\'s posts' do
      context 'when user is not in the system' do
        it 'returns error unauthorized' do
          get other_user_posts_url, params: { username: 'someone' }
          expect(response).to have_http_status 401
          expect(error_message).to eql I18n.t('error.unauthorized')
        end
      end

      context 'when user is in the system' do
        it 'returns list requested user\'s posts' do
          get other_user_posts_url, params: authen_params(user)
          expect(response).to have_http_status 200
          expect(json.length).to eql 2
        end
      end
    end

    context 'when user want to get all comments from all of his posts' do
      let!(:post1) { FactoryGirl.create(:post, creator: other_user) }
      let!(:post2) { FactoryGirl.create(:post, creator: user) }
      let!(:post3) { FactoryGirl.create(:post, creator: user) }
      let!(:comment1) { FactoryGirl.create(:comment, creator: other_user, post: post2) }
      let!(:comment2) { FactoryGirl.create(:comment, creator: user, post: post2) }
      let!(:comment3) { FactoryGirl.create(:comment, creator: other_user, post: post3) }
      let!(:comment4) { FactoryGirl.create(:comment, creator: other_user, post: post1) }

      context 'when user is not in the system' do
        it 'returns error unauthorized' do
          get all_comments_url, params: { username: 'someone' }
          expect(response).to have_http_status 401
          expect(error_message).to eql I18n.t('error.unauthorized')
        end
      end

      context 'when user is in the system' do
        it 'returns list comments' do
          get all_comments_url, params: authen_params(user)
          expect(response).to have_http_status 200
          expect(json.length).to eql 3
          expect(json.map {|comment| comment['id']} - [comment1.id, comment2.id, comment3.id]).to eql []
          expect(json.map {|comment| comment['id']}).to_not include comment4.id
        end
      end
    end
  end
end
