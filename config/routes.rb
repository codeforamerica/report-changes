Rails.application.routes.draw do
  mount Cfa::Styleguide::Engine => "/cfa"

  root "static_pages#index"

  resources :sections, controller: :forms, only: %i[index show] do
    collection do
      FormNavigation.all.each do |controller_class|
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
