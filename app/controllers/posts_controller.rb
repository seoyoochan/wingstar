class PostsController < ApplicationController

  before_action :set_post, only: [:read, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :read]
  load_and_authorize_resource

  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 100).order('created_at desc')
  end

  def read
    @posts = Post.paginate(:page => params[:page], :per_page => 10).order('created_at desc')
    @post = Post.find(params[:id])
  end


  def new
    @post = Post.new
  end


  def edit

  end


  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        flash[:success] = t("performed.posts.create")
        format.html { redirect_to posts_url }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @post.update(post_params)
        flash[:success] = t("performed.posts.update")
        format.html { redirect_to post_path(@post) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  def destroy
    @post.destroy
    respond_to do |format|
      flash[:alert] = t("performed.posts.destroy")
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end


  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = I18n.t("unauthorized.#{controller_name}.#{exception.action}")
    redirect_to ""
  end

end
