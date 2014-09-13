class BlogsController < ApplicationController
  before_action :set_blog, except: [:index, :new, :create, :show]
  before_action :prepare_vars
  before_filter :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    # @blogs = Blog.paginate(:page => params[:page], :per_page => 100).order('created_at desc')
    @blogs = Blog.all
  end

  def new
    if current_user.blogs.present?
      flash[:error] = t("page.blog.create.error", user: "#{@name}")
      redirect_to root_path
    else
      @blog = Blog.new
    end
  end

  def create
    @blog = Blog.new(blog_params)
    @blog.url = "http://www.wingstar.net/blog/#{current_user.username}"
    @blog.user = current_user

    respond_to do |format|
      if @blog.save
        flash[:success] = t("page.blog.action.create.success", user: "#{@name}")
        format.html { redirect_to "/blog/#{current_user.username}" }
        format.json { render action: 'show', status: :created, location: blog  }
      else
        format.html { render action: 'new' }
        format.json { render json: @blog.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    if parsed_user.blog.present?
    @blog = Blog.find_by_url("http://www.wingstar.net/blog/#{params['username']}")
    @posts = Post.where("blog_id=?", "#{parsed_user.blog.id}").paginate(:page => params[:page], :per_page => 10).order('created_at desc')
    else
      flash["error"] = t("page.blog.action.show.blog_empty")
      redirect_to root_path
    end
  end

  def destroy

  end

  def edit

  end

  def update

  end

  private
  def prepare_vars
    @name = name_mapper(current_user)
  end

  def blog_params
    params.require(:blog).permit(:title, :url)
  end

  def set_blog
    @blog = Blog.find(params[:id])
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = I18n.t("unauthorized.#{controller_name}.#{exception.action}")
    redirect_to ""
  end


end