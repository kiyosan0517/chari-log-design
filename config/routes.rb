Rails.application.routes.draw do
  mount LetterOpenerWeb::Engine, at: '/letter_opener' if Rails.env.development?

  root 'static_pages#top'
  get 'privacy_policy', to: 'static_pages#privacy_policy'
  get 'terms', to: 'static_pages#terms'

  resources :user_sessions, only: [:create, :destroy]
  post 'login', to: 'user_sessions#create'
  delete 'logout', to: 'user_sessions#destroy'

  resources :users, only: [:index, :new, :create, :show] do
    resource :relationships, only: [:create, :destroy]
    member { get 'follows', 'followers' }
    collection { get 'search' }
  end

  resource :profile, only: [:edit, :update] do
    resources :attachments, controller: 'profile/attachments', only: [:destroy]
  end

  resources :posts do
    resource :like, only: [:create, :destroy]
    resources :comments, only: %i[create destroy], shallow: true
    get 'likes', on: :collection
    get 'search_rakuten', on: :collection
    post 'upload_image', on: :collection
  end

  resources :password_resets, only: [:new, :create, :edit, :update]

  get '*path', to: 'application#render_404', constraints: ->(req) { req.path.exclude? 'rails/active_storage' }
  post '*path', to: 'application#render_404'
end
