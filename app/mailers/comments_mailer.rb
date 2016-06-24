class CommentsMailer < ApplicationMailer
  def notify_post_owner(comment)
    @comment   = comment
    @user = comment.user
    @post = comment.post
    @owner    = @post.user
    mail(to: @owner.email, subject: "You got a new comment from #{@user.full_name}!")
  end
end
