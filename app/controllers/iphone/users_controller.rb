class Iphone::UsersController < ApplicationController
  unloadable
  
  layout "iphone"

  def show
    @user = User.find(params[:id])
    @memberships = @user.memberships.all(:conditions => Project.visible_by(User.current))
  end
end
