$( document ).on('turbolinks:load', function() {
  $('#edit-password').keyup(e => {
    if ($(e.target).val() != '') {
      $(e.target).closest('form').find('#edit-password-confirmation-field').removeClass('d-none')
    } else {
      $(e.target).closest('form').find('#edit-password-confirmation-field').addClass('d-none')
    }
  })
})