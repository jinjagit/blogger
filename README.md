# Issues with / fixes for Blogger 2 tutorial:

Many of the issues may well be due to my using Rails 5.2.0, not 4.0.0 as in the tutorial. Many of the extra tweaks / ideas, however, may work for many versions of Rails.

I found these solutions either by comparing my code with that of student examples where the functionality in question worked, searching the web, or experimentation. Since I am a Rails novice, my solutions may not be best practice!

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

### L5 No \*\_sorcery\_core.rb file created on bin/rails generate...

This is very likely not a problem with Rails 4.0.0, but I don't know for sure (not tested). With Rails 5.0.0 however, following the tutorial instructions does not result in the creation of the \*\_sorcery\_core.rb file in db/migrate, when the <code>bin/rails generate sorcery:install --model=Author</code> command is run. This means none of the login / authentication stuff will work.

I found a solution [here](https://github.com/Sorcery/sorcery/issues/145#issuecomment-416462868), which involves locating the .../sorcery/lib/generators/sorcery/install_generator.rb file (you will need to search your computer for the location) and commenting out a line. The line actually looked a little different (another Rails version difference). For me, the line to comment out was:

<code>return unless defined?(Sorcery::Generators::InstallGenerator::ActiveRecord)</code>

For previous Rails versions it might be:

<code>return unless defined?(ActiveRecord)</code>

I then reran the <code>bin/rails generate sorcery:install --model Author</code> command, (Note the '=' character is no longer required, though it may well work with it), and the \*\_sorcery\_core.rb was created.

### L5 Poor formatting of layout for "Logged out" / "Logged in as" footer

If the code example in the tutorial, to insert a footer to hold "Logged out" / "Logged in as..." text, is copied into ...app/views/layouts/application.html.erb, various elements in the layout look worse (e.g. the "Create new article" button is offset and half outside of the body).
My solution (before moving the contents of the footer to a sidebar) was:

<code>\<body\></code><br />
&nbsp;&nbsp;<code>\<p class="flash"\><%= flash.notice %>\</p\></code><br />
&nbsp;&nbsp;<code>\<%= yield %\></code><br />
&nbsp;&nbsp;<code>\<div id="container"\></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;<code>\<div id="content"\></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>\<h6 align="center"\></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code><% if logged_in? %></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code><%= "Logged in as #{current_user.username}" %></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code><% else %></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code><%= "logged out" %></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code><% end %></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<code>\</h6\></code><br />
&nbsp;&nbsp;&nbsp;&nbsp;<code>\</div\></code><br />
&nbsp;&nbsp;<code>\</div\></code><br />
<code>\<body\></code><br />


### L5 <code>before_filter</code> throws error and stops app:

<code>before_filter</code> is deprecated for Rails 5.0.0->, and <code>before_action</code> should be used in its place.

### L5 Tweaks:

Since this is a blog, no sign up option should be available to the general public, but only via a trusted user (yourself, for example). Thus, links to the list of authors @ /authors, which links to 'New Author' are only visible to a logged in user, and the New Author form can only be accessed by a logged in user (as per the tutorial).

However, if you wish others to be able to test out most of the functionality of your blog, this step should skipped (or the relevant code commented out). This may well mean that you then want to limit editing of posts to only those created by the user that is editing.

### L6 Sidebar:

I found [this YouTube video](https://www.youtube.com/watch?v=Cixzw30bg10) helpful to get me started on creating a sidebar, in that it includes the basic structure for creating a partial for the sidebar, though you will have to add your own css to style it (including making it appear by giving it a size, position, etc.).

### Preserve newlines in body text of articles:

I found adding this to style.css.scss worked:

<code>p {</code><br />
&nbsp;&nbsp;<code>white-space: pre-line;</code><br />
<code>}</code><br />

Taken from [here](https://stackoverflow.com/questions/3137393/rails-add-a-line-break-into-a-text-area).
