Rails.application.routes.draw do
  post '/upload', to: 'uploads#upload'
end
