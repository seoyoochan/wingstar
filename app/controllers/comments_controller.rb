class CommentsController < ApplicationController
  before_action :set_comments, only: [:show, :edit]
  before_filter :comment_params, only: [:create,:update]
  before_filter :authenticate_user!, except: [:index, :show]
  load_and_authorize_resource

  def index
    @comments = Comment.all
  end

  def new
    parent = Comment.find_by_id(params[:parent_id])
    obj = parent.commentable_type.constantize.find(parent.commentable_id)
    @child_comment = parent.children.build_from(obj, current_user.id, "")
  end

  def create

    if params[:comment][:body].present?
      @comment.user_id = current_user.id
      @comment.created_at = Time.now
      @comment.updated_at = Time.now

      if @comment.save
        flash[:success] = "댓글이 작성되었습니다."
        redirect_to :back
      else
        flash[:error] = "댓글작성에 실패했습니다."
        redirect_to :back
      end
    else
        flash[:error] = "비어있는 댓글을 입력할 수 없습니다."
        redirect_to :back
    end

  end

  def show

  end

  def edit

  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        flash[:success] = t("flash.comment.success_update")
        format.html { redirect_to :back }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy

  end

  def like
    if current_user.voted_on?(@comment)
      flash[:warning] = "이미 좋아합니다."
      # redirect_to "/blog/#{current_user.username}"
    else
      current_user.vote_for(@comment)
      # redirect_to "/blog/#{current_user.username}"
      redirect_to :back
    end
  end

  def unlike
    if current_user.voted_on?(@comment)
      current_user.unvote_for(@comment)
      # redirect_to "/blog/#{current_user.username}"
      redirect_to :back
    else
      flash[:warning] = "이미 좋아하지 않습니다."
      # redirect_to "/blog/#{current_user.username}"
    end
  end

  private
  def set_comments
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:body, :commentable_id, :commentable_type, :title, :subject, :parent_id, :lft, :rgt)
  end

  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = t("unauthorized.#{controller_name}.#{exception.action}")
    redirect_to :back
  end
end
