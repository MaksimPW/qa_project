# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  $(document).on 'click', '.edit-question-link', (e) ->
    e.preventDefault()
    $(this).hide()
    question_id = $(this).data('questionId')
    $('form#edit-question-' + question_id).show()

# For turolinks:
$(document).ready(ready)
$(document).on('turbolinks:load', ready)

$ ->
  PrivatePub.subscribe '/questions', (data, channel) ->
    question = $.parseJSON(data['question'])
    $('.questions').append("<p><a href='/questions/#{question.id}'>#{question.title}</a></p>");
