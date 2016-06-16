class CommentsController < ApplicationController
  def new
    @comment = Comment.new
  end
  def create
    comment_params
    @comment = Comment.new comment_params
    @post = Post.find params[:post_id]
    @comment.post = @post
    if @comment.save
      redirect_to post_path(@post), notice: "Comment created!"
    else
      render "/posts/show"
    end
  end

  def show
    @comment = Comment.find params[:id]
  end

  def index
    @comments = Comment.order(created_at: :desc)
  end

  def edit
    @comment = Comment.find params[:id]
    @post = Post.find params[:post_id]
  end

  def update
    @post = Post.find params[:post_id]
    @comment = Comment.find params[:id]
    comment_params = params.require(:comment).permit(:body)
    if @comment.update comment_params
      redirect_to post_path(@post)
    else
      render :edit
    end
  end

  def destroy
    post = Post.find params[:post_id]
    comment = Comment.find params[:id]
    comment.destroy
    redirect_to post_path(post), notice: "Comment deleted!"
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
