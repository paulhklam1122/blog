class Post < ActiveRecord::Base
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
end
