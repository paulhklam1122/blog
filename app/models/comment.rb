class Comment < ActiveRecord::Base
  validates :body, presence: {message: "must be present!"}, length: {minimum: 7}
end
