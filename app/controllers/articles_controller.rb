class ArticlesController < ApplicationController
  include ArticlesHelper
  before_action :require_login, except: [:show, :index]
  before_action :author_or_admin, only: [:edit, :destroy]

  def author_or_admin
    @article = Article.find(params[:id])
    unless @article.author == current_user.username
      redirect_to root_path
      return false
    end
  end

  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
    @comment = Comment.new
    @comment.article_id = @article.id
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)
    @article.author = current_user.username
    @article.save

    flash.notice = "Article '#{@article.title}' created!"

    redirect_to article_path(@article)
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    @article.update(article_params)

    flash.notice = "Article '#{@article.title}' updated!"

    redirect_to article_path(@article)
  end

  def destroy
    @article = Article.find(params[:id])
    @article.destroy

    flash.notice = "Article '#{@article.title}' deleted!"

    redirect_to articles_path(@articles)
  end

end
