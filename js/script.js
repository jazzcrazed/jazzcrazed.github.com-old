$(function() {
  var $postPreviews = $('.postPreview'),
      recentTweets, i,
      url = encodeURIComponent('marcocarag.com/' + document.location.pathname);

  if ($postPreviews.length) {
    setTimeout(function() {
      $postPreviews.each(function() {
        if ($(this).position().left > 0) {
          $(this).addClass('right');
        }
      });
    }, 125);
  }

  recentTweets = {
    '$container': $('#recentTweets'),
    avatars: '',
    populate: function(tweets) {
      var tweet;

      this.avatars = '<a href="http://twitter.com/search?q=' + url + '">';

      if (tweets.length) {
        for(i = 0; i < tweets.length; i++) {
          tweet = tweets[i];

          this.avatars = this.avatars +
            '<img src="' + tweet.profile_image_url + '" alt="@' + tweet.from_user +
            '" class="avatar" />'
        }

        this.avatars = this.avatars + '</a>';

        this.$container.append(this.avatars).removeClass('hidden');
      }
    }
  };

  if (recentTweets.$container.length) {

    $.ajax({
      url:      'http://search.twitter.com/search.json?q=' + url + '&rpp=100',
      dataType: 'jsonp',
      success:  function(r) { recentTweets.populate(r.results); }
    });
  }
});
