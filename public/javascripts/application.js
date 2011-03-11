// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

// Time Ago in Words for datestamps
jQuery(document).ready(function() {
	jQuery("abbr.timeago").timeago();
});

// Admin Actions
$(document).ready(function () {
	$('img.lock').click(function() {
		$.post($(this).parent()[0] + '.js');
		return false;
	});
});

$(document).ready(function () {
	$('img.unlock').click(function() {
		$.post($(this).parent()[0] + '.js');
		return false;
	});
});

$(document).ready(function () {
	$('img.stick').click(function() {
		$.post($(this).parent()[0] + '.js');
		return false;
	});
});

$(document).ready(function () {
	$('img.unstick').click(function() {
		$.post($(this).parent()[0] + '.js');
		return false;
	});
});

// Alternate comment highlighting
$(document).ready(function () {
	$('#comments .comment:nth-child(odd)').addClass('even');
	$('#comments .comment:nth-child(even)').addClass('odd');	
})

// Ajaxy stuff for comment updating.
$(function () {
	if ($('#comments').length > 0) {
		setTimeout(updateComments, 10000);
	}
});

function updateComments() {
	var post_id = $('#post').attr('data-id');
	if ($('.comment').length > 0) {
		var after = $('#comments .comment:first').attr('data-time');
		var comments_count = $('#comments .comment').length;
	}
	else {
		var after = 0;
		var comments_count = 0;
	}
	
	$.getScript('/posts/' + post_id + '/comments.js?post_id=' + post_id + '&after=' + after + '&comments_count=' + comments_count);
	setTimeout(updateComments, 10000)
}

if (history && history.pushState) {
	$(function () {
		$('#posts .pagination a').live("click", function(e) {
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			e.preventDefault();
		});
		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});
	});
}