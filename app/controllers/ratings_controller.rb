class RatingsController < ApplicationController
  before_action :authenticate_user!, except: [:show, :index]

  def create
    rating = Rating.new rating_params
    rating.user = current_user
    rating.post = current_post
    rating.save
    redirect_to post_path(current_post), notice: "Rating saved!"
  end

  def update
    rating = Rating.find_by_id params[:id]
    if rating
      rating.update(rating_params)
      redirect_to post_path(current_post), notice: "Rating changed"
    else
      redirect_to post_path(current_post) #case when vote has already been deleted
    end
  end

  def destroy
    rating = Rating.find_by_id params[:id]
    if rating
      rating.destroy
      redirect_to post_path(current_post), notice: "Rating removed"
    else
      redirect_to post_path(current_post)
    end
  end

  private
  def rating_params
    params.require(:rating).permit(:star_count)
  end
end
