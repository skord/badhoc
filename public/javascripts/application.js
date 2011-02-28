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