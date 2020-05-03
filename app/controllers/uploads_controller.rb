# frozen_string_literal: true

# To handle file uploads
class UploadsController < ApplicationController
  ALLOWED_FILE_TYPES = ['.png'].freeze

  before_action :create_collection, only: [:upload]

  def upload
    if ActiveModel::Type::Boolean.new.cast(file_params[:enable_filter])
      upload_filtered_file
    else
      upload_file
    end
  rescue StandardError => e
    render json: "Error occured, #{e}", status: :unprocessable_entity
  end

  private

  # strong parameters
  def file_params
    params.permit(:file, :enable_filter)
  end

  def create_collection
    return if collection

    google_session.root_collection.create_subcollection('riskcovry_uploads')
  end

  def upload_file
    file = google_session.upload_from_file(file_params[:file].tempfile,
                                           file_params[:file].original_filename)
    collection.add(file)
    google_session.root_collection.remove(file)
    render json: 'Upload Successful'
  end

  def upload_filtered_file
    if ALLOWED_FILE_TYPES.include? File.extname(file_params[:file])
      upload_file
    else
      render json: 'Only .png extension file is allowed to upload', status: 422
    end
  end

  def google_session
    @google_session ||= GoogleDrive::Session.from_config('config/google_drive.json')
  end

  def collection
    @collection ||= google_session.collection_by_title('riskcovry_uploads')
  end
end
