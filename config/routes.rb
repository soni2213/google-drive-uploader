Rails.application.routes.draw do
  resources :upload
  root 'upload#upload_local_file'
end
