class PostsController < ApplicationController

  before_action :set_post, except: [:index, :new, :create, :destroy_multiple, :post_modal_form]
  before_filter :authenticate_user!, except: [:index, :read]
  load_and_authorize_resource

  def index
    @posts = Post.paginate(:page => params[:page], :per_page => 10).order('created_at DESC')
  end

  def read
    @post = Post.find(params[:id])
    @obj = @post
    @comment = Comment.build_from(@obj, current_user.id, "") if signed_in?
    @all_comments = @obj.comment_threads

    # Count Views
    if signed_in?
      @post.views.create(user_id: current_user.id, created_at: Time.now, updated_at: Time.now, ip: current_user.current_sign_in_ip) if (@post.views.where(user_id: current_user.id).blank?) && (@post.views.where(ip: current_user.current_sign_in_ip).blank?)
    else
      @post.views.create(user_id: @cached_guest_user.id, created_at: Time.now, updated_at: Time.now, ip: guest_user.current_sign_in_ip) if (@post.views.where(user_id: @cached_guest_user.id).blank?) && (@post.views.where(ip: @cached_guest_user.current_sign_in_ip).blank?)
    end

    if request.path != post_path(@post)
      redirect_to @post, status: :moved_permanently
    end
  end

  def new
    @post = Post.new
    @post.attachments.build
  end


  def edit

  end

  def create
    @post = Post.new(post_params)
    @post.blog_id = current_user.blog.id if current_user.blog.present?
    @post.user = current_user

    respond_to do |format|
      if @post.save
        flash[:success] = t("performed.posts.create")

        format.html { redirect_to blog_show_path(current_user.username) }
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
      format.html { redirect_to blog_show_path(current_user.username) }
      format.json { head :no_content }
    end
  end

  def like
    if current_user.voted_on?(@post)
      flash[:warning] = t("votes.warning.like")
      # redirect_to "/blog/#{current_user.username}"
    else
      current_user.vote_for(@post)
      # redirect_to "/blog/#{current_user.username}"
      redirect_to :back
    end
  end

  def unlike
    if current_user.voted_on?(@post)
      current_user.unvote_for(@post)
      # redirect_to "/blog/#{current_user.username}"
      redirect_to :back
    else
      flash[:warning] = t("votes.warning.unlike")
      # redirect_to "/blog/#{current_user.username}"
    end
  end

  def destroy_multiple

    Post.where(id: params[:post_ids]).delete_all

    respond_to do |format|
      flash[:alert] = t("performed.posts.destroy")
      format.html { redirect_to blog_show_path(current_user.username) }
      format.json { head :no_content }
    end
  end

  private
  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content, :slug, :tag_list, :attachments_attributes => [:attachable_id, :attachable_type, :_destroy, :file_name, :id])
  end


  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t("unauthorized.#{controller_name}.#{exception.action}")
    redirect_to :back
  end

end
