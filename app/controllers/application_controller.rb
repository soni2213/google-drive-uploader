require 'google_drive'

class ApplicationController < ActionController::Base

  def session
    GoogleDrive::Session.from_config("gdrive.json")
  end

end
