class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_filter :authenticate_user!, except: [:index, :show]

  # GET /posts
  # GET /posts.json
  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 2).order('created_at desc')
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    @posts = Post.paginate(:page => params[:page], :per_page => 5).order('created_at desc')
    @post = Post.find(params[:id])
  end


  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    # flash[:error] = t("posts.auth.edit") unless @post.updatable_by? current_user
    # authorize_action_for @post
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.user = current_user

    respond_to do |format|
      if @post.save
        flash[:success] = t("posts.performed.create")
        format.html { redirect_to posts_url }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    # flash[:error] = t("posts.auth.edit") unless @post.updatable_by? current_user
    # authorize_action_for @post
    respond_to do |format|
      if @post.update(post_params)
        flash[:success] = t("posts.performed.edit")
        format.html { redirect_to post_path(@post) }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    # flash[:error] = t("posts.auth.destroy") unless @post.deletable_by? current_user
    # authorize_action_for @post
    @post.destroy
    respond_to do |format|
      flash[:alert] = t("posts.performed.destroy")
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

end
