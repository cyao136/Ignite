$(document).on('turbolinks:load', function() {
  $('.comment-reply').click( function(){
     $(this).closest('.comment').find('.reply-form').toggle();
  });
});
