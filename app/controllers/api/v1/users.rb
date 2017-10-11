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
      end

      helpers do
        def user_params
          ActionController::Parameters.new(params).require(:user).permit(:username, :email, :password)
        end
      end
    end
  end
end