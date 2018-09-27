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

### L5 Extra Credit: Restrict activity of user (both logged in and not logged in):

The 'Extra Credit' part of L5 only asks for restricting the editing of articles to only their original 'owner' (author). I also added further restrictions, whereby only an "admin" (me) can edit / delete other authors' posts, edit / delete authors, or delete tags. This involved:

1. Do not implement the feature in the tutorial that prevents new author creation by a non-logged in author (otherwise nobody can sign up without the help of a logged in user!), but rather include the code and comment it out (it will be a useful template for some of the steps below).

2. Work out how to add an 'author' column to the articles database ([this post](https://stackoverflow.com/questions/20383503/add-new-view-to-a-controller-in-rails) might help). I then implemented showing the author name at the top of each article (created after adding the new database column) to confirm this works, before using this parameter in step 3, below.

3. Add conditional statements to the various views to prevent the inclusion of the relevant links to non-authors / non-admins / non-logged in users (article edit / delete links in .../articles/show.html.erb, for example). Don't forget to do this for the 'create new article' button, author delete / edit links (I restricted this to "admin" only), and tag delete (also "admin" only).

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

Note: Because we are given a huge (and unreadable) block of css styling in screen.css.scss, the sidebar and main body of the web pages are not set up as 2 distinct columns. This makes centering the content of the pages relative to the sidebar somewhat messy. I have found a reasonable compromise (see .body css in [style.css.scss](https://github.com/jinjagit/blogger/blob/master/app/assets/stylesheets/style.css.scss)), but it can look a bit 'off' when viewed in a large window on a 4k screen. If this app was intended for real-life use, I would write all my own css. Since I need to learn about Rails more than develop my css skills, however, I can live with this.

### L6 Date-based navigation links [Not implemented]:

Although suggested in the tutorial as an 'extra', I didn't implement this, as it seems unlikely I will have enough articles to warrant it, nor of enough different creation dates to test it well (without manually resetting my system date and creating new articles, several times). I did include a time-stamp on each article, however, (top left), and it seems trivial to parse this for the number of the month / year and then filter articles to display accordingly (if this were desired). Creating such a new view would also be very similar to creating the new 'Top 3 Most Viewed Articles' view, as described below.

### L6 Implement view_count for articles:

I added a new 'view_count' column, of type integer, to the articles database table. For a recap of how to this, I found [this post](https://stackoverflow.com/questions/4834809/adding-a-column-to-an-existing-table-in-a-rails-migration) helpful. After doing that (and running <code>rake db:migrate</code>), I decided to go for the 'calling a model method from the controller' approach.

The necessary code was added to the show method in the [articles_controller.rb](https://github.com/jinjagit/blogger/blob/master/app/controllers/articles_controller.rb) controller, and a new method, called 'increment_view_count' in the [articles.rb](https://github.com/jinjagit/blogger/blob/master/app/models/article.rb) model. The new parameter also needs to be 'permitted' in [articles_helper.rb](https://github.com/jinjagit/blogger/blob/master/app/helpers/articles_helper.rb).

After that, it is a simple task to show the view count on the article(s) page(s), by adding the relevant code to [.../views/articles.show.html.erb](https://github.com/jinjagit/blogger/blob/master/app/views/articles/show.html.erb).

### L6 Create new view; list of top 3 most viewed articles:

First, I created a new route in [routes.rb](https://github.com/jinjagit/blogger/blob/master/config/routes.rb), called 'index_by_views', using information in [this post](https://stackoverflow.com/questions/20383503/add-new-view-to-a-controller-in-rails) as a template. Then, I created a new method in [articles_controller.rb](https://github.com/jinjagit/blogger/blob/master/app/controllers/articles_controller.rb), modeled on the 'index' method, but with a different ordering (by number of views, in descending order). I also changed 'index' to specify ascending created_at order. This meant I could now add a button to my sidebar that linked to the new 'index_by_views'.

Adding <code>.limit(3)</code> to the end of the 'index_by_views' article sorting statement, in [articles_controller.rb](https://github.com/jinjagit/blogger/blob/master/app/controllers/articles_controller.rb), ensured only three articles are returned to this new view. Lastly, I made the view count of each article visible in this new view (and the original index view) and changed the page title to something appropriate.

### L6 Create a simple RSS feed [Not implemented]:

Whilst the <code>respond_to</code> [looks quite interesting and flexible](https://ryanbigg.com/2009/04/how-rails-works-2-mime-types-respond_to), I don't use any RSS feeds and happen to know their use is generally declining. I, therefore, did not implement this last 'extra' step in L6.

### Preserve newlines in body text of articles:

I found this worked:

add to style.css.scss<br />
<code>.body_text {</code><br />
&nbsp;&nbsp;<code>white-space: pre-line;</code><br />
<code>}</code><br />

edit line in app/views/articles/show.html.erb<br />
<code>\<p class="body_text"><%= \@article.body %>\</p></code><br />

Taken from [here](https://stackoverflow.com/questions/3137393/rails-add-a-line-break-into-a-text-area).

### Limited control of button attributes:

I probably should have created my own buttons (for example, for the links on the sidebar) using JavaScript, but instead decided to try to do this using only Ruby in the layout file(s). I found that if I just stuck to the default style (delivered by the screen.css.scss file), then I could get quite a good result that included a nice hover background color change. As soon as I changed the button background color (actually a gradient background-image), however, I lost this hover effect. I tried introducing special classes and many other methods, but I think that without understanding the screen.css.scss file better (which isn't really my focus for this project), I cannot do better. Also, since it looks OK to me, I am not too worried.

### Add ability for admin to delete any comment:

It took me a while to discover a way to delete comments. After getting most of the way there, (adding a destroy function to comments_controller.rb, etc.), the last piece of the jigsaw fell into place when I found the syntax for the delete link in the [...views/articles/\_comment.html.erb partial](https://github.com/jinjagit/blogger/blob/master/app/views/articles/_comment.html.erb) in [this post](https://stackoverflow.com/questions/34476250/how-can-i-delete-comments-in-a-rails-blog-app).

After that, it was simply a matter of adding a conditional to the delete link, so it is only shown when "admin" (or any other specified user) is logged in, and adding the usual relevant before_action filter and related function to [comments_controller.rb](https://github.com/jinjagit/blogger/blob/master/app/controllers/comments_controller.rb).

### Delete orphaned tags:

This is _kind of_ related to the final extra task listed in the Odin Project instructions for this tutorial exercise, where it says;

"...if you delete a tag, all related orphaned taggings will remain there."

__Except they don't!__ Using the rails console to observe all tags and all taggings when all articles associated with a particular tag are deleted, shows all taggings are correctly destroyed. Likewise, the console also reveals that when a tag is deleted (manually), all the related taggings are also correctly destroyed. The <code>dependent: :destroy</code> mentioned in the Odin instructions has already been included, so taggings are __not__ the problem.

Tags _are_ an issue however. When all articles that contain a reference to a tag are deleted, the tag remains. Thus, orphaned tags (__not__ taggings) are the issue.

To further confirm this, I created a couple of orphaned tags (by creating an article with 2 new, unique tags), and then inserted <code><%= "#{tag.taggings.count}" %></code> into the <code>@tags.each do |tag|</code> in the tags index view. Sure enough, the two orphaned tags had 0 taggings associated, (and the non-orphans had 1 or more taggings associated).

Thus, it would be trivial to filter out orphaned tags from the tags index view using a conditional; <code><% if tag.taggings.count != 0 %></code>, but that wouldn't actually remove the tags! In this app, that wouldn't matter, but in another context a database table could be filling with a large number of orphaned items which are never removed. Really, the tag needs removing when the article is deleted, which means the delete method in the articles controller needs to trigger a check for whether associated tags have only one tagging associated, and if so, then trigger the deletion of any such tags.

After some experimenting, I achieved this by inserting the following code into the delete method of [articles_controller.rb](https://github.com/jinjagit/blogger/blob/master/app/controllers/articles_controller.rb), _before_ <code>@article.destroy</code> is called:

<code>@article.tags.each do |tag|</code><br />
&nbsp;&nbsp;<code>if tag.taggings.count == 1</code><br />
&nbsp;&nbsp;&nbsp;&nbsp;<code>@tag = Tag.find(tag.id)</code><br />
&nbsp;&nbsp;&nbsp;&nbsp;<code>@tag.destroy</code><br />
&nbsp;&nbsp;<code>end</code><br />
<code>end</code><br />

### Ability to add links in article body text:

I used a gem that should enable full mark up syntax, but actually only some of it's functionality works (including links, which was what I wanted). I suspect this may because of the screen.css.scss file we were given early in the tutorial (perhaps preventing italic, bold, etc?).

I used this article as a guide. Only installation of the gem, restart of your rails server, and copying the relevant code into your [application_helper.rb](https://github.com/jinjagit/blogger/blob/master/app/helpers/application_helper.rb) file is required (I also added <code>require 'redcarpet'</code>, for good measure).

[Here](https://daringfireball.net/projects/markdown/syntax) is a list of the syntax it uses (based on Daring Fireball syntax).

Note: This has the effect of reducing multiple new-lines (enabled in a previous step, above) to one new-line (maximum), but this can be overcome by using multiple '<br />' statements where needed.

A link can now be included in an article body text using the following format: \[text_label_to_show]\(some_url_here)
