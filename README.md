# Issues with / fixes for Blogger 2 tutorial:

Note: Some / all of these issues may be fixed by the time you read this (as I, and others, have reported some to the github repo 'issues' page for the tutorial).

## L2 / L3 Deleting article breaks app, after previously working:
  * After creating comments and tags functionality, the delete article function breaks. (i.e. deleting an article will throw an error and stop the app). A solution is to edit the article.rb file to include; <code>dependent: :delete_all</code> in the lines:

   <code>has_many :comments, dependent: :delete_all</code><br />
   <code>has_many :taggings, dependent: :delete_all</code>

  * I guess the error occurs because the relationships to any comments / tags are not deleted along with the article, without this code being added.

## L3 Deleting tag(s) breaks app:

Similar to the above issue, to be able to delete tags, tag.rb needs to include the line:

<code>has_many :taggings, dependent: :destroy</code><br />
