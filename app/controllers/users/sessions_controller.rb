class Users::SessionsController < Devise::SessionsController

  def create
    self.resource = warden.authenticate!(auth_options)

    Profile.create(url: "http://www.wingstar.net/profile/#{resource.username}", user_id: "#{resource.id}") if resource.profile.blank?

    if resource.blog.blank?
      Blog.create(
          title: "#{name_mapper(resource)}",
          url: "http://www.wingstar.net/blog/#{resource.username}",
          user_id: "#{resource.id}",
          created_at: Time.now,
          updated_at: Time.now
      )
    end

    set_flash_message(:success, :signed_in, :name => resource.first_name ) if is_flashing_format?
    sign_in(resource_name, resource)
    yield resource if block_given?
    respond_with resource, location: after_sign_in_path_for(resource)
  end

  def destroy
    # self.resource = warden.authenticate!(auth_options)
    signed_out = (Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name))
    # set_flash_message(:success, :signed_out, :name => resource.first_name ) if signed_out && is_flashing_format?
    yield if block_given?
    respond_to_on_destroy
  end

  private
  def respond_to_on_destroy
    # We actually need to hardcode this as Rails default responder doesn't
    # support returning empty response on GET request
    respond_to do |format|
      format.all { head :no_content }
      format.any(*navigational_formats) { redirect_to after_sign_out_path_for(resource_name) }
    end
  end

end