module API
  module V1
    class Posts < Grape::API
      include API::V1::Default

      resource :posts do
        before { authenticate! }

        desc 'Create a new post'
        params do
          requires :username, type: String, desc: 'Name which user chose to use in the system'
          requires :content, type: String, desc: 'Post\'s content'
        end
        post do
          ActiveRecord::Base.transaction do
            Post.create!(creator: current_user, content: params[:content])
          end
        end

        desc 'Get all posts'
        params do
          requires :username, type: String, desc: 'Name which user chose to use in the system'
        end
        get do
          Post.all
        end
      end
    end
  end
end
