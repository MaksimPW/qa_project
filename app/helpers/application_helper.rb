module ApplicationHelper
  def collection_cache_key_for(model)
    klass = model.to_s.capitalize.constantize
    count = klass.count
    max_updated_at = klass.maximum(:updated_at).try(:utc).try(:to_s, :number)
    "#{model.to_s.pluralize}/collection-#{count}-#{max_updated_at}"
  end

  def button_vote(action, object)

    if vote = Vote.find_by(user: current_user, votable: object)
      right_vote = true if action == 'up' && vote.value == 1
      right_vote = true if action == 'down' && vote.value == -1
    end


    if current_user.voted?(object) && right_vote
      link = {
          action: 'vote_destroy',
          class: "vote-#{action} active",
          span: "chevron-#{action}",
          method: 'delete'
      }
    else
      link = {
          action: "vote_#{action}",
          class: "vote-#{action}",
          span: "chevron-#{action}",
          method: 'patch'
      }
    end

    link_to polymorphic_path([link[:action], object]), class: link[:class],
            method: link[:method], remote: true, data: {type: :json} do
      raw "<span class='glyphicon glyphicon-#{link[:span]}'></span>"
    end
  end
end
