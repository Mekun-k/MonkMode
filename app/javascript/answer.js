$(document).ready(function() {
  $('.tool-btn').on('click', function () {
    var target = $(this).data('box-link');
    console.log(target);
    var box = $('#' + target);
    console.log(box);
    $(box).parent().addClass('is-inactive');
    $(box).fadeIn();
    $(this).parent().addClass('is-inactive');
    $('.box .tool-btn').on('click', function () {
      $(this).not($(this).parents('.box').fadeOut());
      $(this).parents('.box').toggleClass('is-inactive');
    });
  });
});
