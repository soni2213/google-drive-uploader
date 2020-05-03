class UploadsController < ApplicationController
  before_action :create_collection, only: [:upload]
  ALLOWED_FILE_TYPES = [".png"]

  def upload
    if ActiveModel::Type::Boolean.new.cast(file_params[:enable_filter])
      upload_filtered_file
    else
      upload_file
    end

    rescue StandardError => e
      render json: "Error occured, #{e}", status: Unprocessable_entity
  end

  private

  # strong parameters
  def file_params
    params.permit(:file, :enable_filter)
  end

  def create_collection
    session.root_collection.create_subcollection("riskcovry_uploads") if !session.collection_by_title("riskcovry_uploads")
  end

  def upload_file
    collection = session.collection_by_title("riskcovry_uploads")
    file = session.upload_from_file(file_params[:file].tempfile, file_params[:file].original_filename, convert: false)
    collection.add(file)
    session.root_collection.remove(file)
    render json: "Upload Successful"
  end

  def upload_filtered_file
    if ALLOWED_FILE_TYPES.include? File.extname(file_params[:file])
      upload_file
    else
      render json: "Only .png extension file is allowed to upload", status: 422
    end
  end

  def session
    @session ||= GoogleDrive::Session.from_config("config/google_drive.json")
  end
end