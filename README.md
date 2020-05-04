
# google-drive-uploader

API interface to facilitate upload of files on Google Drive using Google drive API gateway.

## Getting Started

### Setup Ruby

* Use `rbenv` or `rvm` for ruby setup. Installation steps are specified [here](https://github.com/rbenv/rbenv) and [here](https://rvm.io/).
* Rails version- *6.0.2*
* Ruby version - *2.7.0*.
Install with the following commands (for `rvm`):
```
rvm install ruby-2.7.0
rvm use 2.7.0
```

### Prerequisites
Follow these [steps 1-8](https://github.com/gimite/google-drive-ruby/blob/master/doc/authorization.md#command-line) to get the needed credentials.
Add `client_id` and `client_secret` creds in google_drive.json file of project.
The file should reside in `config` folder in `Rails.root`. Have added a `google_drive.json.sample` file for reference.

### Local Setup
Install the dependencies and start the server.
```
gem install bundler # if not already
bundle install
rails console

# Perform the below in the rails console
> drive_session = GoogleDrive::Session.from_config('config/google_drive.json')
> # open the google link that comes up, grant the permissions, and paste the resultant code back in your terminal.
> exit
rails server
```

### Usage
* Use an API client to call the REST API http://localhost:3000/upload (type POST), which requires one parameter to be passed as request body of form-data type.
* In form-data, add one `key-value` pair: key `file` value will be the `file` to upload.
* To add filter check append query param to the end of the url: key `enable_filter` value will be `true`

### Output
* Create a folder in google drive and upload files to it.