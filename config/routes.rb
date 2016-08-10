Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
      delete :vote_destroy
    end
  end

  concern :commentable do
    resources :comments, only: [:create, :destroy], shallow: :true
  end

  resources :questions, :answers, concerns: [:votable, :commentable], only: []

  resources :questions do
    resources :answers, only: [:create, :destroy, :update] do
      patch :best, on: :member
    end
  end

end
