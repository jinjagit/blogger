# Issues with / fixes for Blogger 2 tutorial:

Many of the issues may well be due to my using Rails 5.2.0, not 4.0.0 as in the tutorial. Many of the extra tweaks / ideas, however, will work for many versions of Rails.

I found these solutions either by comparing my code with that of student examples where the functionality in question worked, searching the web, or experimentation. Since I am a Rails novice, my solutions / tweaks may not be best practice!

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

### L5 Tweak to allow other students to test functionality:

Since this is a blog, no sign up option should be available to the general public, but only via a trusted user (yourself, for example). Thus, the tutorial ensures the New Author form can only be accessed by a logged in user.

However, if you wish others to be able to test out most of the functionality of your blog, this step should skipped (or the relevant code commented out). This may well mean that you then want to limit editing of posts to only those created by the user that is editing.

### L5 Restrict activity of user (both logged in and not logged in):

If, like me, you would like other students of the Odin course to peruse your app, but NOT have the ability to edit / delete other peoples' posts, nor edit / delete authors, nor delete tags, there are a number of things to do:

1. Do not implement the feature in the tutorial that prevents new author creation by a non-logged in author (otherwise nobody can sign up without the help of a logged in user!), but rather include the code and comment it out (it will be a useful template for some of the steps below).

2. Work out how to add an 'author' column to the articles database. I then implemented showing the author name at the top of each article (created after adding the new database column) to confirm this works, before using this parameter in step 3, below.

3. Implement conditional statements in the various views to prevent the inclusion of the relevant links to non-authors / non-admins / non-logged in users (article edit / delete in /articles/show.html.erb, for example). Don't forget to do this for the 'create new article' link, author delete / edit (I restricted this to 'admin' only), and tag delete (also 'admin' only).

4. Prevent navigation to the relevant pages by non-authors / non-admin (for example, navigation to '.../articles/15/edit'). This is where the code from the tutorial, mentioned above, will come in handy. Basically, this needs a careful selection of <code>before_action...</code> declarations, and writing some associated functions in the relevant controller files. See [my .../controllers/articles_controller.rb file](https://github.com/jinjagit/blogger/blob/master/app/controllers/articles_controller.rb), for an example.

5. Change the "logged out" message to a "login" link and add a "sign up" link that takes the user to the new author page.

Note: Also remember <code>before_filter</code> is deprecated in Rails 5.0.0->, where <code>before_action</code> is used instead.

### L6 Sidebar:

I found [this YouTube video](https://www.youtube.com/watch?v=Cixzw30bg10) helpful to get me started on creating a sidebar, in that it includes the basic structure for creating a partial for the sidebar, though you will have to add your own css to style it (including making it appear by giving it a size, position, etc.).

Basically, it involves creating a layout partial, like my [\_sidebar.html.erb](https://github.com/jinjagit/blogger/blob/master/app/views/layouts/_sidebar.html.erb), which contains everything you want to appear on the sidebar, and then inserting the following 3 lines into every view file where you wish to have the sidebar visible (all of them):

<code><% content_for(:sidebar) do %></code><br />
&nbsp;&nbsp;<code><%= render :partial => "layouts/sidebar" %></code><br />
<code><% end %></code><br />

As, for example, in my [app/views/articles/show.html.erb](https://github.com/jinjagit/blogger/blob/master/app/views/articles/show.html.erb).

### Preserve newlines in body text of articles:

I found this worked:

add to style.css.scss<br />
<code>.body_text {</code><br />
&nbsp;&nbsp;<code>white-space: pre-line;</code><br />
<code>}</code><br />

edit line in app/views/articles/show.html.erb<br />
<code>\<p class="body_text"><%= \@article.body %>\</p></code><br />

Taken from [here](https://stackoverflow.com/questions/3137393/rails-add-a-line-break-into-a-text-area).

### Remove <code>max-width</code> in css, for 4k screens:

I found the containers for the articles and other page content would not span the full width of my screen (4k) when the window was maximized. Somewhere in that huge block of code in screen.css.scss is a <code>max-width</code> declaration. Delete it.

### Limited control of button attributes:

I probably should have created my own buttons (for example, for the links on the sidebar) using JavaScript, but instead decided to try to do this using only Ruby in the layout file(s). I found that if I just stuck to the default style (delivered by the screen.css.scss file), then I could get quite a good result that included a nice hover background color change. As soon as I changed the button background color (actually a gradient background-image), however, I lost this hover effect. I tried introducing special classes and many other methods, but I think that without understanding the screen.css.scss file better (which isn't really my focus for this project), I cannot do better. Also, since it looks OK to me, I am not too worried.
