;

var sections = $('div.entry-content h2, div.entry-content h3');

var titles = $('ul#markdown-toc a');
titles[0].className = 'toc-active';

var tops = [];

sections.each(function () {
  var that = $(this);
  tops.push(that.offset().top);
});

$(window).scroll(function () {
  var that = $(this);
  var nowTop = that.scrollTop();
  var i;
  for (i = 0; i < tops.length; i++) {
    if (nowTop <= tops[i]) {
      titles.removeClass();
      titles[i].className = 'toc-active';
      break;
    }
  }
});
