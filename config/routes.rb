Rails.application.routes.draw do
  mount Cfa::Styleguide::Engine => "/cfa"

  root "static_pages#index"
end
