class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :path, :created_at
end
