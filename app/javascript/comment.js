document.addEventListener('turbolinks:load', function() {
  $("body").on("click", ".js-edit-comment-button", (e) => {
    const targetButton = $(e.target).closest('.js-edit-comment-button');
    if (targetButton.length) {
      const commentId = targetButton.data('comment-id');
      const commentLabelArea = $('#js-comment-label-' + commentId);
      const commentTextArea = $('#js-textarea-comment-edit-' + commentId);
      const commentButton = $('#js-comment-button-' + commentId);
      commentLabelArea.hide();
      commentTextArea.show();
      commentButton.show();
    }
  });

  $("body").on("click", ".comment-cancel-button", (e) => {
    const commentId = $(e.target).data('cancel-id');
    const commentLabelArea = $('#js-comment-label-' + commentId);
    const commentTextArea = $('#js-textarea-comment-edit-' + commentId);
    const commentButton = $('#js-comment-button-' + commentId);
    const commentError = $('#js-comment-post-error-' + commentId);
    commentLabelArea.show();
    commentTextArea.hide();
    commentButton.hide();
    commentError.hide();
  });
});
