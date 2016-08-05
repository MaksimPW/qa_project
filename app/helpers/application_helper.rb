module ApplicationHelper
  def button_vote(object, action)

    if vote = Vote.find_by(user: current_user, votable_id: object.id)
      right_vote = true if action == 'up' && vote.value == 1
      right_vote = true if action == 'down' && vote.value == -1
    end


    if current_user.voted?(object) && right_vote
      link = {
          path: '_vote_destroy_path',
          class: "vote-#{action} active",
          span: "chevron-#{action}",
          method: 'delete'
      }
    else
      link = {
          path: "_vote_#{action}_path",
          class: "vote-#{action}",
          span: "chevron-#{action}",
          method: 'patch'
      }
    end

    link_to send(object.class.name.downcase+link[:path], object), class: link[:class], method: link[:method], remote: true do
      raw "<span class='glyphicon glyphicon-#{link[:span]}'></span>"
    end
  end
end
