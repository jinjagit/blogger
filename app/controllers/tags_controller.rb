class TagsController < ApplicationController
  #before_action :require_login, only: [:destroy]
  before_action :admin, only: [:destroy]

  def admin
    unless current_user.username == "admin"
      redirect_to root_path
      return false
    end
  end

  def index
    @tags = Tag.all
  end

  def show
    @tag = Tag.find(params[:id])
  end

  def destroy
    @tag = Tag.find(params[:id])
    @tag.destroy

    flash.notice = "Tag '#{@tag.name}' deleted!"

    redirect_to tags_path
  end

end
