//custom JS for ADA written by TFW

//for the content tree in the CMS
// $(document).ready(function(){
// 
// $("li.tree-item span").droppable({
//     tolerance        : "touch",
//     hoverClass       : "tree-hover",
//     drop             : function(event, ui){
// 		alert('...')
//         var dropped = ui.draggable;
//         dropped.css({top: 0, left: 0});
//         var me = $(this).parent();
//         if(me == dropped)
//             return;
//         var subbranch = $(me).children("ul");
//         if(subbranch.size() == 0) {
//             me.find("span").after("<ul></ul>");
//             subbranch = me.find("ul");
//         }
//         var oldParent = dropped.parent();
//         subbranch.eq(0).append(dropped);
//         var oldBranches = $("li", oldParent);
//         var newParent = me.attr('id')
//         var child = dropped.attr('id')
//         $.post("/inkling/update_tree", {new_parent: newParent, child: child});
//     }
// });
// 
//     $("li.tree-item").draggable({
//         opacity: 0.5,
//         revert: true
//     });
// 
// });

// $(document).ready(function(){
// 	$("#search_term").focus(function() {
// 		var search = $("#search_term");
// 		alert(search.text());
// 		if (search.val() == "Search this site"){
// 			search.val() = "";
// 		}
// 		alert("2");
// 	});
// });

$(document).ready(function(){
	// $("#search_term").clearableTextField();
	$('input[type=text]').clearableTextField();
});
