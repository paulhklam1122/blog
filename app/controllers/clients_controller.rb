class ClientsController < ApplicationController
  def index
    render json: Post.all
  end

  def create
    post = Post.create!(title: params[:title], body: params[:body])
  end

  def show
    post = Post.find(params[:id])
    # comments = post.comments
    # comments = post.comments.map do |c|
    # result = { id: post.id, title: post.title, body:, post.body, created_at: post.created_at}
    render json: post
  end
end
