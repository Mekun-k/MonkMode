$(document).on("turbolinks:load", () => {
  $("body").on("click", ".js-edit-comment-button",(e) => {
    const commentId = $(e.target).parent().data('commentId');
    const commentLabelArea = $('#js-comment-label-' + commentId);
    const commentTextArea = $('#js-textarea-comment-edit-' + commentId);
    const commentButton = $('#js-comment-button-' + commentId);
    commentLabelArea.hide();
    commentTextArea.show();
    commentButton.show();
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
})