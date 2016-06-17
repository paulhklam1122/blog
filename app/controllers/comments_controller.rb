class CommentsController < ApplicationController
  before_action :find_comment, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]

  def new
    @comment = Comment.new
  end

  def create
    @comment = Comment.new comment_params
    @post = Post.find params[:post_id]
    @comment.user = current_user
    @comment.post = @post
    if @comment.save
      redirect_to post_path(@post), notice: "Comment created!"
    else
      render "/posts/show"
    end
  end

  def show
  end

  def index
    @comments = Comment.order(created_at: :desc)
  end

  def edit
    @post = Post.find params[:post_id]
  end

  def update
    @post = Post.find params[:post_id]
    comment_params = params.require(:comment).permit(:body)
    if @comment.update comment_params
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find params[:post_id]
    comment.destroy
    redirect_to post_path(post), notice: "Comment deleted!"
  end

  private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def comment_params
    params.require(:comment).permit(:body)
  end

  def authenticate_user!
    redirect_to new_sessions_path, alert: "please sign in" unless user_signed_in?
  end
end
