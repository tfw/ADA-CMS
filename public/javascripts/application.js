$(document).ready(function(){
	$("#search_term").focus(function() {
		var search = $("#search_term");
		if (search.val() == "Search this site"){
			search.val("");
		}
	});
});

