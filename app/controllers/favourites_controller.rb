class FavouritesController < ApplicationController
  before_action :authenticate_user!

  def index
    @posts = current_user.favourite_posts
  end
  def create
    @post = Post.find params[:post_id]
    @favourite = Favourite.new(post: @post, user: current_user)
    @favourite.save
    respond_to do |format|
      format.html {redirect_to post_path(@post), notice: "Thanks for favouriting!"}
      format.js {render :toggle_heart}
    end
  end

  def destroy
    @favourite = Favourite.find params[:id]
    @post = Post.find params[:post_id]
    @favourite.destroy if can? :destroy, Favourite
    respond_to do |format|
      format.html {redirect_to post_path(@post), notice: "Un-favourited"}
      format.js {render :toggle_heart}
    end
  end
end
