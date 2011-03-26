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
		setTimeout(updateComments, 5000);
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
	setTimeout(updateComments, 5000)
}

$(function () {
	if ($('#comments .commentpic_processing').length > 0) {
		setTimeout(updateStale, 1000);
	}
});


function updateStale() {
	if ($('#comments .commentpic_processing').length > 0) {
		$('#comments .commentpic_processing').each( function () {
			var post_id = $('#post').attr('data-id');
			var comment_id = $(this).data('id');
			$.getScript('/posts/' + post_id + "/comments/" + comment_id + '.js');
		});		
	}
	setTimeout(updateStale, 1000);
}

// Posts Pagination
if (history && history.pushState) {
	$(function () {
		$('#posts .pagination a').live("click", function(e) {
			$(".pagination").css({opacity:0.5});
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			e.preventDefault();
		});
		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});
	});
}

// Picwalls Pagination
if (history && history.pushState) {
	$(function () {
		$('#picwalls .pagination a').live("click", function(e) {
			$("#picwalls").css({opacity:0.5});
			$.getScript(this.href);
			history.pushState(null, document.title, this.href);
			e.preventDefault();
		});
		$(window).bind("popstate", function() {
			$.getScript(location.href);
		});
	});
}

// Helps with in-line comment replies

$(document).ready( function () {
	$('#comments .comment a.permalink').each( function() {
		$(this).after('  <a href="#" class="comment-reply">Reply</a>');
	});
	$('a.comment-reply').click( function() {
		var comment_id = $(this).parent().parent().data('id');
		var reply_string = '@' + comment_id + "\r\n\r\n";
		$('#new_comment_form').show();
		$('#new_comment_form textarea').val(reply_string);
	});
});

// Picwall fancybox
$(document).ready( function() {
	$(".fancybox").fancybox({
			'transitionIn'	:	'none',
			'transitionOut'	:	'none',
			'overlayShow'		:	true,
			'showNavArrows'	: false,
	    'changeFade'    : 0,
	    'cyclic'				: true,
			'hideOnContentClick' : true,
			'showCloseButton'	: false
		});
});