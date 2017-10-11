module API
  module V1
    class Comments < Grape::API
      include API::V1::Default

      resource :posts do
        before { authenticate! }

        desc 'Create a comment in a post'
        params do
          requires :username, type: String, desc: 'Name which user chose to use in the system'
          requires :content, type: String, desc: 'Comment\'s content'
        end
        post ':post_id/comments' do
          ActiveRecord::Base.transaction do
            post.comments.create!(creator: current_user, content: params[:content])
          end
        end
      end

      helpers do
        def post
          @post ||= Post.find(params[:post_id]) if params[:post_id].present?
        end
      end
    end
  end
end
