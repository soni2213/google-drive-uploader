Rails.application.routes.draw do
  post '/upload', to: 'upload#upload'
end
