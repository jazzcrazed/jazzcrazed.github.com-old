$(document).ready(function() {
  var $mainContent = $('#content'),
      windowWidth = window.innerWidth || document.documentElement.clientWidth,
      windowHeight = window.innerHeight || document.documentElement.clientHeight,
      chromeArea = {
        vertical: $mainContent.offset().top,
        horizontal: $mainContent.offset().left + 10
      },
      paneSize = {
        height: windowHeight - chromeArea.vertical,
        width: windowWidth - chromeArea.horizontal
      },
      isLandscape = paneSize.height < paneSize.width;

  $mainContent.find('.pane').height(paneSize.height);

  if (isLandscape) {
    $('.paneBackground').width("120%");
  } else {
    $('.paneBackground').height("120%");
  }

  (function() {
    $('.overContent.line').each(function() {
      $(this).height(paneSize.height - ($(this).siblings('.opaqueContent').outerHeight() + 34));
    });
  })();
});
