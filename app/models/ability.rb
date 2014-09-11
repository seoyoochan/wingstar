class Ability
  include CanCan::Ability
  # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  def initialize(user)
    alias_action :edit, :update, :destroy, :to => :ud

    @user = user || User.new

    if @user.has_role? :admin
      admin_ability
    end

    if @user.has_role? :user
      user_ability
    end

    if @user.roles.size == 0
      guest_ability
    end

  end


  def admin_ability
    can :manage, :all
  end

  def user_ability
    can [:index, :new, :create, :read, :like, :unlike], Post
    can :ud, Post, :user_id => @user.id

    can [:index, :show, :new, :create], Blog
    can [:ud], Blog, :user_id => @user.id

    can [:show], Profile

    can :all, Vote
    can [:index, :show, :new, :create], Location
    can [:ud], Location, :user_id => @user.id

    can [:index, :new, :create, :like, :unlike], Comment
    can :ud, Comment, :user_id => @user.id
  end

  def guest_ability
    can :index, :all
    can :read, Post
    can :show, [Blog, Profile]
  end

end
