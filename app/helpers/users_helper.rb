module UsersHelper

  def email_required?(provider)
    super && provider.blank?
  end


end