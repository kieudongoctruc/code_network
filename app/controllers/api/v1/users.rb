module API
  module V1
    class Users < Grape::API
      include API::V1::Default

      resource :users do
        desc 'Create a new user'
        params do
          requires :user, type: Hash do
            requires :username, type: String, desc: 'Name which user chose to use in the system'
            optional :email, type: String, regexp: User::EMAIL_REGEX, desc: 'user\'s email'
            optional :password, type: String, desc: 'User\'s password'
          end
        end
        post do
          user = User.find_by(username: user_params[:username])
          return error!(I18n.t('error.username_existed'), 422) if user.present?

          # use regex to check if username contains space
          return error!(I18n.t('error.no_space_in_username'), 422) if user_params[:username].match(/\s/)

          ActiveRecord::Base.transaction do
            User.create!(user_params)
          end
        end

        before { authenticate! }

        desc 'Get all posts from a specific user'
        params do
          requires :username, type: String, desc: 'Name which user chose to use in the system'
        end
        get ':id/posts' do
          user.posts
        end

        desc 'Get all comments from on all of a specific user\'s posts'
        params do
          requires :username, type: String, desc: 'Name which user chose to use in the system'
        end
        get 'posts/comments' do
          Comment.all_comments_of_user_posts(current_user).order(:created_at)
        end
      end

      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:username, :email, :password)
        end

        def user
          @user ||= User.find(params[:id]) if params[:id].present?
        end
      end
    end
  end
end
