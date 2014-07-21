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
      visitor_ability
    end

  end


  def admin_ability
    can :manage, :all
  end

  def user_ability
    can :index, Post
    can :new, Post
    can :create, Post
    can :read, Post
    can :ud, Post, :user_id => @user.id
  end

  def visitor_ability
    can :index, :all
    can :show, :all
    can :read, :all
  end

end
