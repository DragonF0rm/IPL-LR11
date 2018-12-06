Rails.application.routes.draw do
  root to: 'database#index', as: :index
  get '/output', to: 'database#output', as: :output
  get '/fulldb', to: 'database#fulldb', as: :fulldb
end
