class UploadController < ApplicationController
  skip_before_action :verify_authenticity_token
  before_action :create_collection

  def upload
    if ActiveModel::Type::Boolean.new.cast(file_params[:enable_filter]) == true
      upload_filtered_file
    else
      upload_file
    end

    rescue StandardError => e
      render json: "Error occured, #{e}"
  end

  private

  # strong parameters
  def file_params
    params.permit(:file, :enable_filter)
  end

  def create_collection
    session = get_session
    session.root_collection.create_subcollection("riskcovry_uploads") if !session.collection_by_title("riskcovry_uploads")
  end

  def upload_file
    session = get_session
    collection = session.collection_by_title("riskcovry_uploads")
    file = session.upload_from_file(file_params[:file].tempfile, file_params[:file].original_filename, convert: false)
    collection.add(file)
    session.root_collection.remove(file)
    render json: "Upload Successful"
  end

  def get_session
    GoogleDrive::Session.from_config("config/google_drive.json")
  end

  def upload_filtered_file
    if File.extname(file_params[:file]) == ".png"
      upload_file
    else
      render json: "Only .png extension file is allowed to upload"
    end
  end

end