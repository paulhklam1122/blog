class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :users, through: :favourites
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :ratings, dependent: :destroy
  has_many :rating_users, through: :ratings, source: :user
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

  def rated_by?(user)
    ratings.exists?(user: user)
  end

  def rate_for(user)
    ratings.find_by_user_id user
  end

  def rated_1_by?(user)
    rated_by?(user) && rate_for(user).star_count == 1
  end

  def rated_2_by?(user)
    rated_by?(user) && rate_for(user).star_count == 2
  end

  def rated_3_by?(user)
    rated_by?(user) && rate_for(user).star_count == 3
  end

  def rated_4_by?(user)
    rated_by?(user) && rate_for(user).star_count == 4
  end

  def rated_5_by?(user)
    rated_by?(user) && rate_for(user).star_count == 5
  end


end
