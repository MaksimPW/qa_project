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

  $(document).on 'click', ".comments [data-method='delete']", (e) ->
    $(".comments [data-method='delete']").bind 'ajax:success', (e, data, status, xhr) ->
      $("[data-comment-id=#{data.id}]").remove()

  $('.comments .new_comment').bind 'ajax:success', (e, data, status, xhr) ->
    if (typeof(data.comment) != 'undefined' && data.comment.body && data.comment.commentable_id && data.comment.commentable_type)
      commentable = $("[data-object-id='#{data.comment.commentable_id}'][data-object-type='#{data.comment.commentable_type.toLowerCase()}']")
      render_link_delete = "<a data-remote='true' rel='nofollow' data-method='delete' href='/comments/#{data.comment}'>Delete</a>"
      commentable.find('.list').append("<p data-comment-id='#{data.comment}'>#{data.comment.body} #{render_link_delete}</p>")

  $('.comments .new_comment').bind 'ajax:error', (e, xhr, status, error) ->
    errors = xhr.responseJSON.errors
    for message of errors
      $('.comments .new_comment .errors').append "<p>#{errors[message]}</p>"


unless $(document).on('ready', comment)
  $(document).on('turbolinks:load', comment)