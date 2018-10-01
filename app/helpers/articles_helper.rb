module ArticlesHelper

  def article_params
    params.require(:article).permit(:title, :body, :tag_list, :image, :view_count)
  end

end
