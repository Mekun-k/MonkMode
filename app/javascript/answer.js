$(document).ready(function() {
  $('.tool-btn').on('click', function () {
    let target = $(this).data('box-link');
    let box = $('#' + target);
    $(box).parent().addClass('is-inactive');
    $(box).fadeIn();
    $(this).parent().addClass('is-inactive');
    $('.box .tool-btn').on('click', function () {
      $(this).not($(this).parents('.box').fadeOut());
      $(this).parents('.box').toggleClass('is-inactive');
    });
  });
});
