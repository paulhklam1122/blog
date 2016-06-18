class User < ActiveRecord::Base
  has_secure_password
  has_many :posts, dependent: :nullify
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true, format: /\A([\w+\-]\.?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i

  def full_name
    "#{first_name} #{last_name}"
  end

  before_create { generate_token(:auth_token) }
  def generate_token(user)
  begin
    self[user] = SecureRandom.urlsafe_base64
  end while User.exists?(user => self[user])
end

end
