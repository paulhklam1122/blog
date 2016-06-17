class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user
  validates :body, presence: {message: "must be present!"}, length: {minimum: 7}
end
