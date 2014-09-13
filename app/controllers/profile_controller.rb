class ProfileController < ApplicationController
  include ApplicationHelper

  def cover

    if (params[:profile][:attachments_attributes]["0"][:file_name].blank? || params[:profile].blank?)
      flash[:error] = t("flash.cover.empty_attachment")
      return redirect_to :back
    end

    @profile = current_user.profile

    logger.debug "프로필 : #{@profile.inspect}"

    respond_to do |format|
      if @profile.update(safe_params)
        flash[:success] = t("flash.cover.success_upload")
        format.html { redirect_to root_path }
        format.json { head :no_content }
      end
    end

  end

  def show
    @profile = Profile.where(user_id: @parsed_user).first
    @profile.attachments.build
    # Count Views
    if signed_in?
      @profile.views.create(user_id: current_user.id, created_at: Time.now, updated_at: Time.now, ip: current_user.current_sign_in_ip) if (@profile.views.where(user_id: current_user.id).blank?) && (@profile.views.where(ip: current_user.current_sign_in_ip).blank?)
    else
      @profile.views.create(user_id: @cached_guest_user.id, created_at: Time.now, updated_at: Time.now, ip: guest_user.current_sign_in_ip) if (@profile.views.where(user_id: @cached_guest_user.id).blank?) && (@profile.views.where(ip: @cached_guest_user.current_sign_in_ip).blank?)
    end
  end

  def destroy
    @profile = Profile.where(user_id: params[:username]).first
    cover = @profile.attachments.first
    respond_to do |format|
      if cover.present?
        flash[:success] = t("flash.cover.success_destroy")
      else
        flash[:error] = t("flash.cover.error_destroy")
      end
      format.html { redirect_to :back }
      format.json { head :no_content }
    end

  end

  def safe_params
    params.require(:profile).permit(:url, :cover, :attachments_attributes => [:attachable_id, :attachable_type, :_destroy, :file_name, :id])
  end
end
