$(document).ready(function(){
	$("#search_term").focus(function() {
		var search = $("#search_term");
		if (search.val() == "Search this site"){
			search.val("");
		}
	});

  $('#notice').delay(1000).fadeOut(400)
  $('#alert').delay(1000).fadeOut(400)
});

