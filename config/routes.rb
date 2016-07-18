Rails.application.routes.draw do
  devise_for :users
  root 'questions#index'

  resources :questions do
    resources :answers, only: [:create, :destroy, :update] do
      patch :best, on: :member
    end
  end
end
