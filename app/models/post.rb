class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :users, through: :favourites
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :user
  validates :title, presence: {message: "must be present!"}, uniqueness: true, length: {minimum: 7}
  validates :body, presence: true

  def self.search(search)
    where("title ILIKE ? OR body ILIKE ?", "%#{search}%", "%#{search}%")
  end

  def body_snippet
    # if body.length > 100
    #   body[0...100] + "..."
    # else
    #   body
    # end
    body.length > 100 ? body[0...100] + "..." : body
  end

  def total_pages

  end

  def new_first_comments
     comments.order(created_at: :desc)
  end

  def favourited_by?(user)
    # favourites.find_by_user_id user
    favourites.exists?(user: user)
  end

  def favourite_for(user)
    favourites.find_by_user_id user
  end
end
