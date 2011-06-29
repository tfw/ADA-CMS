/*
Copyright (c) 2011, Australian National University.
Written by Rohan Mitchell.
*/

/**
 * @fileOverview Plugin to clean ".Apple-style-span" cruft added by Webkit browsers.
 */


(function() {
    function onSelectionChangeCleanBody(ev) {
	$("iframe").each(function() {
	    $(this).contents().find("span.Apple-style-span").each(function() {
		this.parentNode.replaceChild(this.firstChild, this);
	    });
	});
    }

    CKEDITOR.plugins.add('clean_apple_style_span', {
	init: function(editor) {
	    editor.on('editingBlockReady', function() {
		editor.on('selectionChange', onSelectionChangeCleanBody, null, null, 1);
	    });
	}
    });
})();
