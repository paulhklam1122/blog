class NewpostsJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    @posts = Post.select("posts.id, created_at").
                         joins(:created_at).
                         group("posts.id").
                         order("time_created DESC").
                         where("posts.created_at >= ? AND posts.created_at <= ?",
                                Time.now.2_days_ago,
                                Time.now.1_days_ago).
    AdminMailer.send_daily_report(@posts).deliver_now
  end
end
