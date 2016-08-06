button_vote = ->
  $('.vote-up, .vote-down').bind 'ajax:success', (e, data, status, xhr) ->
    this_object = $("[data-object-id=#{data.object}]")
    this_object.find('.score').html("<h3>" + data.score + "</h3>")

    this_object.find('.buttons>a').each (index, element) =>

      if $(element).attr('class').indexOf('up') != -1
        klass = 'up'
      else
        klass = 'down'

      if $(element).attr("class") == "vote-#{data.button_vote}"

        $(element).attr({
          class: "vote-#{data.button_vote} active",
          href: "/#{data.kontroller}_vote_destroy/#{data.object}"
        });
        $(element).data('method', 'delete')

      else if ($(element).attr('class').indexOf('active') != -1) && ($(this).attr('class').indexOf('active') != -1)

        $(element).attr({
          class: "vote-#{klass}",
          href: "/#{data.kontroller}_vote_#{klass}/#{data.object}"
        });
        $(element).data('method', 'patch')

      else

        $(element).attr({
            class: "vote-#{klass}",
            href: "/#{data.kontroller}_vote_#{klass}/#{data.object}"
        });
        $(element).data('method', 'patch')


unless $(document).on('ready', button_vote)
  $(document).on('turbolinks:load', button_vote)