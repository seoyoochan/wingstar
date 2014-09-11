class VotesController < ApplicationController

  # before_filter :fetch

  def like

    voter = User.find(params[:user])
    voteable = params[:model].constantize.find(params[:model_id])

    if voter.voted_on?(voteable)
      flash[:warning] = "회원님은 #{voteable}을 이미 좋아합니다."
    else
      voter.voted_for(voteable)
    end
  end

  def unlike
    if @voter.voted_on?(@voteable)
      flash[:warning] = "회원님은 #{@voteable}을 이미 좋아하지 않습니다."
    else
      @voter.vote_exclusively_for(@voteable)
    end
  end

  private
  def fetch
    @voter = User.find(params[:user])
    @voteable = params[:model].constantize.find(params[:model_id])
  end
end