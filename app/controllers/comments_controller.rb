class CommentsController < ApplicationController
  before_action :require_login, except: [:create]
  before_action :admin, only: [:destroy]

  def admin
    unless current_user.username == "admin"
      redirect_to root_path
      return false
    end
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.article_id = params[:article_id]
    @comment.save

    flash.notice = "Comment created!"

    redirect_to article_path(@comment.article)
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    @article = Article.find(params[:article_id])

    flash.notice = "Comment deleted!"

    redirect_to article_path(@article)
  end

  def comment_params
    params.require(:comment).permit(:author_name, :body)
  end

end
