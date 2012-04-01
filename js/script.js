$(document).ready(function() {
  var postPreviews = $('.postPreview');
  if (postPreviews.length) {
    setTimeout(function() {
      postPreviews.each(function() {
        console.log($(this), $(this).position());
        if ($(this).position().left > 0) {
          $(this).addClass('right');
        }
      });
    }, 125);
  }
});
