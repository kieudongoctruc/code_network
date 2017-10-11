module API
  module V1
    module Default
      extend ActiveSupport::Concern

      included do
        prefix "api"
        version "v1", using: :path
        default_format :json
        format :json
        formatter :json, Grape::Formatter::ActiveModelSerializers

        helpers do
          # log on production log file, should add to each try-catch exception
          def logger
            Rails.logger
          end

          # return the current user access the system, based on username
          def current_user
            User.find_by(username: params[:username])
          end

          def authenticate!
            error!(I18n.t('error.unauthorized'), 401) unless current_user
          end
        end

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: I18n.t('error.record_not_found', message: e.message), status: 404)
        end

        rescue_from ActiveRecord::RecordInvalid do |e|
          error_response(message: I18n.t('error.invalid_record', message: e.message), status: 422)
        end
      end
    end
  end
end
