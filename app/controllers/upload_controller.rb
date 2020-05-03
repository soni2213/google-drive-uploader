class UploadController < ApplicationController

  def upload_local_file
    session.upload_from_file("/path/to/hello.txt", "hello.txt", convert: false)
  end

end