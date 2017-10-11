class PostSerializer < ActiveModel::Serializer
  attributes :id, :content, :created_at, :updated_at

  belongs_to :creator, serializer: UserSerializer
end
