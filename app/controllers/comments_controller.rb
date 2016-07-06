class CommentsController < ApplicationController
  before_action :find_comment, only: [:show, :edit, :update, :destroy]
  before_action :find_post, only: [:create, :edit, :update]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :authorize_owner, only: [:edit, :destroy, :update]

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new comment_params
    @comment.user = current_user
    @comment.post = @post

    respond_to do |format|

      if @comment.save
        CommentsMailer.notify_post_owner(@comment).deliver_now if should_notify?
        format.html {redirect_to post_path(@post), notice: "Comment created!"}
        format.js {render :create_success}
      else
        format.html {render "/posts/show"}
        format.js {render :create_failure}
      end
    end
  end

  def show
  end

  def index
    @comments = Comment.order(created_at: :desc)
  end

  def edit
  end

  def update
    if @comment.update comment_params
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find params[:post_id]
    @comment.destroy
    respond_to do |format|
      format.html {redirect_to post_path(post), notice: "Comment deleted!"}
      format.js {render}
    end
  end

  private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def find_post
    @post = Post.find params[:post_id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authenticate_user!
    redirect_to new_sessions_path, alert: "please sign in" unless user_signed_in?
  end

  def authorize_owner
    redirect_to root_path, alert: "Access Denied" unless can? :manage, @comment
  end

  def should_notify?
    @post.user != current_user
  end
end
