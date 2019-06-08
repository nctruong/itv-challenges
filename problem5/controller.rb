class PostsController < ActionController::Base
  def index
    @posts = Post.includes(:user).all
  end
end