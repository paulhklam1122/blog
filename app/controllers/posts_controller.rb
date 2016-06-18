class PostsController < ApplicationController
  before_action :find_post, only:[:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:show, :index]
  before_action :authorize_owner, only: [:edit, :destroy, :update]
  def new
    @post = Post.new
  end
  def create
    # post_params = params.require(:post).permit(:title, :body)
    post_params
    @post = Post.new post_params
    @post.user = current_user
    if @post.save
      redirect_to posts_path(@post), notice: "Post created"
    else
      flash[:alert] = "Post not created"
      render :new
    end
  end

  def show
    # @post = Post.find params[:id]
    @comment = Comment.new
  end

  def index
    if params[:search]
      @posts = Post.search(params[:search]).order("created_at DESC")
    else
      # @posts = Post.all.order(created_at: :desc)
      @posts = Post.paginate(:page => params[:page], :per_page => 7)
    end
  end

  def edit
    # @post = Post.find params[:id]
  end

  def update
    # @post = Post.find params[:id]
    # post_params = params.require(:post).permit(:title, :body)
    post_params
    if @post.update post_params
      redirect_to post_path(@post), notice: "Post updated"
    else
      flash[:alert] = "Post not updated"
      render :edit
    end
  end

  def destroy
    # @post = Post.find params[:id]
    @post.destroy
    redirect_to posts_path
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end

  def find_post
    @post = Post.find params[:id]
  end

  def authenticate_user!
    redirect_to new_sessions_path, alert: "please sign in" unless user_signed_in?
  end

  def authorize_owner
    redirect_to root_path, alert: "Access Denied" unless can? :manage, @post
  end
end
