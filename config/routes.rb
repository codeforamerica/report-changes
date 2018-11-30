Rails.application.routes.draw do
  mount Cfa::Styleguide::Engine => "/cfa"

  devise_for :admin_users

  authenticate :admin_user do
    namespace :admin do
      match "/delayed_job" => DelayedJobWeb, :anchor => false, :via => %i[get post]

      resources :reports, only: %i[index show]
      get "download_all", to: "reports#download", format: "csv"

      root to: "reports#index"
    end
  end

  root "static_pages#index"

  resources :screens, controller: :forms, only: (Rails.env.production? ? %i[show] : %i[show index]) do
    collection do
      FormNavigation.form_controllers.uniq.each do |controller_class|
        { get: :edit, put: :update }.each do |method, action|
          match "/#{controller_class.to_param}",
                action: action,
                controller: controller_class.controller_path,
                via: method
        end
      end
    end
  end
end
