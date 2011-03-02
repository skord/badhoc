// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

jQuery(document).ready(function() {
	jQuery("abbr.timeago").timeago();
});

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

$(function () {
	if ($('#comments').length > 0) {
		setTimeout(updateComments, 10000);
	}
});

function updateComments() {
	var post_id = $('#post').attr('data-id');
	if ($('.comment').length > 0) {
		var after = $('#comments .comment:first').attr('data-time');
	}
	else {
		var after = 0;
	}
	
	$.getScript('/posts/' + post_id + '/comments.js?post_id=' + post_id + '&after=' + after);
	setTimeout(updateComments, 10000)
}