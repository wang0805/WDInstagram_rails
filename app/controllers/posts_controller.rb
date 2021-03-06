class PostsController < ApplicationController
  before_action :authenticate_user!, :except => [ :show, :index ]

  def index
    # byebug
    @posts = Post.all
  end

  def show
    @post = Post.find(params[:id])
  end

  def new
    @tags = Tag.all
    @post = Post.new
  end

  def create
    # render plain: params[:post].inspect
    #byebug #can use post_params["caption"] to get the string and split into tags; create tag
    @post = Post.new(post_params)
    @post.user = current_user

    if @post.save
      redirect_to @post
    else
      render 'new'
    end
  end

  def edit
    @tags = Tag.all
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])

    if @post.user == current_user
      @post.update(post_params)
      redirect_to @post
    else
      redirect_to @post
    end
  end

  def destroy
    @post = Post.find(params[:id])

    @post.destroy
    redirect_to posts_path
  end

  # this is tell ruby what is permited to be inputed into req.body => require(:post) which is the form_for :post
  # we arent able to call @post = Post.new(params[:post]) as rails doesnt know whats permited
  private 
  def post_params
    params.require(:post).permit(:author, :photo_url, :date_taken, :tag_ids => [], tags_attributes: [:id, :tag], comments_attributes: [:id, :comment, :username])
  end
end
