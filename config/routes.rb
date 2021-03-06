require 'sidekiq/web'

Rails.application.routes.draw do
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end

  use_doorkeeper
  devise_for :users, controllers: { omniauth_callbacks: 'omniauth_callbacks' }
  root 'questions#index'

  namespace :api do
    namespace :v1 do
      resources :profiles do
        get :me, on: :collection
      end

      resources :questions, only: [:index, :show, :create], shallow: true do
        resources :answers, only: [:index, :show, :create]
      end
    end
  end

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
    post   '/subscribe'   => 'subscriptions#create'
    delete '/unsubscribe' => 'subscriptions#destroy'
  end

  resources :authorizations, only: [:new, :create]

  get '/search', to: 'search#search', as: 'search'
end
