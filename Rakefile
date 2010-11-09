# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)
require 'rake'

Ada::Application.load_tasks

task :layout => :environment do
  Theme.content
  content_layout = Theme.first
  content_layout.body = @@content_layout
  content_layout.save!
end

@@content_layout = <<-THEME
<!DOCTYPE html>
<html>
	<head>
		<meta charset="UTF-8"/>
		<title>- Australian Data Archive - <%= @page.name %></title>
		<link rel="stylesheet" href="css/import.css" media="all"/>
		<!-- Include this BEFORE the body to ensure older browsers can read new html5 elements -->
    <%= stylesheet_link_tag :all %>
    <%= csrf_meta_tag %>
		<%= javascript_include_tag 'modernizr-1.5.min', 'jquery.min', 'jquery.effects.core', 'scripts' %>		
	</head>
    
    <body onLoad=" resizeTo(1050,1100);" id="<%= archive_css(@page) %>">
		<header>
			<div class="login">
				<h1>USER Log-in </h1>
				<form action="" method="post" enctype="multipart/form-data" name="form2" class="formtastic">
					
					<input type="text" name="textfield" id="login_name"/>
					<input type="text" name="login_pass" id="login_pass"/>
					<input type="image" alt="Log In" name="imageField" id="enter_button" src="images/structure/bttn_enter.png"/>
				</form>
			</div>
			<div class="masthead"><a href="../index.html">Australian Data Archive</a></div>
	</header>
		<nav class="mainnav clearfix">
		  <ul>
		    <li class="current"><a href="index.html" id="menufirst">ADA home</a></li>
		    <li><a href="ada/about.html">about</a></li>
		    <li><a href="ada/archive.html">sub-archive</a>
		      <ul>
		        <li> <%= link_to('social science', Archive.social_science.slug )%> </li>
		        <li> <%= link_to('Historical', Archive.historical.slug )%> </li>
		        <li> <%= link_to('Indigenous', Archive.indigenous.slug )%> </li>
		        <li> <%= link_to('Longitudinal', Archive.longitudinal.slug )%> </li>
		        <li> <%= link_to('Qualitative', Archive.qualitative.slug )%> </li>
		        <li> <%= link_to('International', Archive.international.slug )%> </li>
          </ul>
	        </li>
		    <li> <a href="ada/access.html">data access</a>
		      <ul>
		        <li><a href="#">ASSDA Data Catalogue</a></li>
		        <li><a href="#">Search data </a></li>
		        <li><a href="#">Register</a></li>
		        <li><a href="#">Undertaking forms</a></li>
	          </ul>
	        </li>
		    <li><a href="ada/deposit.html">data deposit</a>
		      <ul>
		        <li><a href="#">Why deposit data?</a></li>
		        <li><a href="#">Sharing data and setting</a></li>
		        <li><a href="#">conditions for access</a></li>
		        <li><a href="#">How to deposit data</a></li>
		        <li><a href="#">Deposit forms</a></li>
	          </ul>
	        </li>
		    <li><a href="ada/guides.html">user guides</a></li>
		    <li><a href="ada/news.html">ada news</a></li>
		    <li><a href="ada/contact.html">contact</a></li>
		    <li><a href="ada/account.html" id="menuLast">my account</a>
		      <ul>
		        <li><a href="#">Register</a></li>
		        <li><a href="#">Account details</a></li>
		        <li><a href="#">Edit details</a></li>
		        <li><a href="#">change passwords</a></li>
		        <li><a href="#">retrieve login</a> </li>
	          </ul>
	        </li>
	      </ul>
		  <div class="searchContainer">
		    <form action="" method="post" enctype="multipart/form-data" name="form1" class="formtastic">
		      <label for="menusearch"></label>
		      <input name="textfield" type="text" id="menusearch" value="Search this site"/>
		      <input type="image" alt="Go" name="imageField" id="search_button" src="images/structure/bttn_go.png"/>
	        </form>
	      </div>
    </nav>
        
    <nav class="subnav"> </nav>
        
		<nav class="breadcrumbs">
			<p><strong>YOU ARE HERE:</strong><a href="<%= request.path %>"> <%= yield(:breadcrumbs) %></a></p>
		</nav>
		
        <section class="content">
			<nav>
				<ul>
					<li id="science"> <%= link_to('social science', Archive.social_science.slug )%> </li>
	        <li id="historical"> <%= link_to('Historical', Archive.historical.slug )%> </li>
	        <li id="indigenous"> <%= link_to('Indigenous', Archive.indigenous.slug )%> </li>
	        <li id="longitudinal">  <%= link_to('Longitudinal', Archive.longitudinal.slug )%> </li>
	        <li id="qualitative"> <%= link_to('Qualitative', Archive.qualitative.slug )%> </li>
	        <li id="international">  <%= link_to('International', Archive.international.slug )%> </li>
			  </ul>
			</nav>
      

	<div class="notice"><%= notice %></div>
  <div class="alert"><%= alert %></div>
			
	<aside></aside>
	<article> <%= yield %> </article>
</section>
        
		<section class='partners'>
<div class="captions">
				<p>Funding Partners </p>
				<p>Collaboration Partners</p>
		  </div>
			
            <div class="logos">
				<img src="images/content/logo_arc.gif" alt="logo_arc" width="90" height="56" class="partnersFirst"/>
				<img src="images/content/logo_ncr.gif" alt="logo_nrc" width="109" height="56"/>
				<img src="images/content/logo_anu.gif" width="90" height="56" alt="Logo_anu"/>
				<img src="images/content/logo_uwa.gif" width="114" height="56" alt="logo_uwa"/>
				<img src="images/content/logo_uts.gif" width="110" height="56" alt="logo_uts"/>
				<img src="images/content/logo_um.gif" width="110" height="56" alt="logo_um"/>
				<img src="images/content/logo_uq.gif" width="110" height="56" alt="logo_uq"/>
			</div>
		</section>
		<footer>
		  <p>General Enquiries: <a href="#">assda@anu.edu.au</a></p>
		  <p>Web Enquiries: <a href="#">webmaster@assda.anu.edu.au</a></p>
		  <p>This page was last updated on Tuesday the 27th of April 2010 at 11:07am.</p>
		  <p> &#xA9; Australian Data Archive</p>
    </footer>
<script src="scripts/jquery.min.js" type="text/javascript" charset="utf-8"></script>
		<script src="scripts/jquery.effects.core.js" type="text/javascript"></script>
		<script src="scripts/scripts.js" type="text/javascript"></script>
	
    </body>
</html>
THEME