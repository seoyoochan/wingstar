module CommentsHelper

  # All posts that current user commented on
  # Post.includes(:comments).where({comments: { user_id: '#{current_user.id}' } }).order('comments.updated_at')

end
