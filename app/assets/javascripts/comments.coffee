# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
comment = ->

  $(document).on 'click', '.add-comment-link', (e) ->
    e.preventDefault()
    $(this).hide()
    commentable_id = $(this).data('commentableId')
    commentable_type = $(this).data('commentableType')
    $("form#new-comment-#{commentable_type.toLowerCase()}-#{commentable_id}").show()

  $('.comments .new_comment').bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    for message of errors
      $('.comments .new_comment .errors').append "<p>#{errors[message]}</p>"

  PrivatePub.subscribe "/comments", (data, channel) ->
    switch(data.method)
      when 'create'
        comment = (data['comment'])
        commentable = $("[data-object-id='#{comment.commentable_id}'][data-object-type='#{comment.commentable_type.toLowerCase()}']")
        render_link_delete = "<a data-remote='true' rel='nofollow' data-method='delete' href='/comments/#{data.comment}'>Delete</a>"
        commentable.find('.list').append("<p data-comment-id='#{comment}'>#{comment.body} #{render_link_delete}</p>")
      when 'destroy'
        $("[data-comment-id=#{data.id}]").remove()

unless $(document).on('ready', comment)
  $(document).on('turbolinks:load', comment)