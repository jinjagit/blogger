# Issues with / fixes for Blogger 2 tutorial:

Note: Some / all of these issues may be fixed by the time you read this (as I, and others, have reported some to the github repo 'issues' page for the tutorial).

I found these solutions either by comparing my code with that of student examples where the functionality in question worked, or by experimentation. Since I am a Rails novice, my solutions may not be best practice!

### L2 / L3 Deleting article breaks app, after previously working:
After creating comments and tags functionality, the delete article function breaks. (i.e. deleting an article will throw an error and stop the app). A solution is to edit the article.rb file to include; <code>dependent: :delete_all</code> in the lines:

   <code>has_many :comments, dependent: :delete_all</code><br />
   <code>has_many :taggings, dependent: :delete_all</code>

I guess the error occurs because the relationships to any comments / tags are not deleted along with the article, without this code being added.

### L3 Deleting tag(s) breaks app:

Similar to the above issue, to be able to delete tags, tag.rb needs to include the line:

<code>has_many :taggings, dependent: :destroy</code><br />

### L4 Remove the (ugly) image icon from posts without an image:

Simply replace the line <code><%= image_tag @article.image.url(:medium)</code> in ...articles/show.html.erb with the conditional code used in ...articles/\_form.html.erb

<code><% if @article.image.exists? %></code><br />
&nbsp;&nbsp;<code><%= image_tag @article.image.url %><br/></code><br />
<code><% end %></code>

### L4 Change the (ugly) green background color:

For me, the green background clashes with the blue theme used elsewhere. After creating the style.css.scss file (L4), add the following lines to it:

<code>html {</code><br />
&nbsp;&nbsp;<code>background-color: #CBD3F8;</code><br />
<code>}</code>

...and adjust the color ("#CBD3F8") to taste.
