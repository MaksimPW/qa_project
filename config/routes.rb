Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, only: [:create, :destroy, :update] do
      patch :best, on: :member
    end
  end

  votable = proc { |model|
    patch "#{model}_vote_up/:id", to: "#{model}s#vote_up", as: "#{model}_vote_up"
    patch "#{model}_vote_down/:id", to: "#{model}s#vote_down", as: "#{model}_vote_down"
    delete "#{model}_vote_destroy/:id", to: "#{model}s#vote_destroy", as: "#{model}_vote_destroy"
  }

  votable.call('question')
  votable.call('answer')

end
