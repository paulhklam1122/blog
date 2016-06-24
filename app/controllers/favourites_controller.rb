class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.favourite_posts
  end
  def create
    post = Post.find params[:post_id]
    f = Favourite.new(post: post, user: current_user)
    if f.save
      redirect_to post_path(post), notice: "Thanks for favouriting!"
    else
      redirect_to post_path(post), alert: "Failed to favourite."
    end
  end

  def destroy
    favourite = Favourite.find params[:id]
    post = Post.find params[:post_id]
    favourite.destroy
    if can? :destroy, Favourite
      redirect_to post_path(post), notice: "Un-favourited"
    else
      redirect_to post_path(post), alert: "Failed to Un-favourite"
    end
  end
end
