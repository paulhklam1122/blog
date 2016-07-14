class User < ActiveRecord::Base
  has_secure_password
  has_many :posts, dependent: :nullify
  has_many :favourites, dependent: :destroy
  has_many :favourite_posts, through: :favourites, source: :post
  has_many :ratings, dependent: :destroy
  has_many :rated_posts, through: :ratings,source: :post
  validates :first_name, presence: true, unless: :using_oauth?
  validates :last_name, presence: true, unless: :using_oauth?
  validates :email, presence: true, uniqueness: true, format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, unless: :using_oauth?
  validates :uid, uniqueness: {scope: :provider}, if: :using_oauth?

  PROVIDER_TWITTER = "twitter"

  serialize :twitter_raw_data, Hash

  def using_oauth?
    uid.present? && provider.present?
  end

  def using_twitter?
    using_oauth? && provider == PROVIDER_TWITTER
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def self.find_or_create_from_twitter(twitter_data)
    user = User.where(uid: twitter_data["uid"], provider: twitter_data["provider"]).first
    user = create_from_twitter(twitter_data) unless user
    user
  end

  def self.create_from_twitter(twitter_data)
    user = User.new
    full_name               = twitter_data["info"]["name"].split(" ")
    user.first_name        = full_name.first
    user.last_name         = full_name.last
    user.uid                 = twitter_data["uid"]
    user.provider            = twitter_data["provider"]
    user.twitter_token      = twitter_data["credentials"]["token"]
    user.twitter_secret     = twitter_data["credentials"]["secret"]
    user.twitter_raw_data = twitter_data
    user.password = SecureRandom.urlsafe_base64
    user.save
    user
  end


  before_create { generate_token(:auth_token) }
  def generate_token(user)
    begin
      self[user] = SecureRandom.urlsafe_base64
    end while User.exists?(user => self[user])
  end

  def password_reset_token_expired?
    password_reset_sent_at < 3.days.ago
  end

  def increment_login_lockout_count
    if self.login_lockout_count <= 10
      self.login_lockout_count += 1
      update_attribute(:login_lockout_count, self.login_lockout_count)
    else
      update_attribute(:account_lockout, true)
      update_attribute(:login_lockout_count, 0)
    end
  end

  def unlock_account
    update_attribute(:account_lockout, false)
  end
end
