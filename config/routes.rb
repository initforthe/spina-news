Spina::Engine.routes.draw do
  namespace :news do
    root to: 'articles#index'

    resources :articles, only: [:index, :show]

    get 'archive/:year(/:month)', to: 'articles#archive', as: :archive_articles
  end

  namespace :admin do
    namespace :news do
      resources :articles do
        collection do
          get :live
          get :draft
          get :future
        end
      end
    end
  end
end
