class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at

  belongs_to :creator, serializer: UserSerializer
  belongs_to :post, serializer: PostSerializer
end
