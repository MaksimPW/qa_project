Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    patch :vote_up
    patch :vote_down
    delete :vote_destroy
  end

  resources :questions do
    resources :answers, only: [:create, :destroy, :update] do
      patch :best, on: :member
    end
  end

  #FIXME: Refactor this:
  patch 'answer_vote_up/:id', to: 'answers#vote_up', as: 'answer_vote_up'
  patch 'answer_vote_down/:id', to: 'answers#vote_down', as: 'answer_vote_down'
  delete 'answer_vote_destroy/:id', to: 'answers#vote_destroy', as: 'answer_vote_destroy'

  patch 'question_vote_up/:id', to: 'questions#vote_up', as: 'question_vote_up'
  patch 'question_vote_down/:id', to: 'questions#vote_down', as: 'question_vote_down'
  delete 'question_vote_destroy/:id', to: 'questions#vote_destroy', as: 'question_vote_destroy'
end
