require 'sinatra/base'

class FakeOnfidoAPI < Sinatra::Base
  get '/v3/addresses/pick' do
    json_response(200, 'addresses.json')
  end

  post '/v3/applicants' do
    json_response(201, 'applicant.json')
  end

  put '/v3/applicants/:id' do
    json_response(200, 'applicant.json')
  end

  get '/v3/applicants/:id' do
    json_response(200, 'applicant.json')
  end

  get '/v3/applicants' do
    response = json_response(200, 'applicants.json')
    { applicants: JSON.parse(response)['applicants'][pagination_range] }.to_json
  end

  delete '/v3/applicants/:id' do
    status 204
  end

  post '/v3/applicants/:id/restore' do
    if params["id"] == "a2fb9c62-ab10-4898-a8ec-342c4b552ad5"
      json_response(422, 'not_scheduled_for_deletion_error.json')
    else
      status 204
    end
  end

  post '/v3/documents' do
    json_response(201, 'document.json')
  end

  post '/v3/extractions' do
    json_response(201, 'extraction.json')
  end

  get '/v3/documents/:id' do
    json_response(200, 'document.json')
  end

  get '/v3/documents' do
    json_response(200, 'documents.json')
  end

  get '/v3/documents/:id/download' do
    status 200
    content_type 'application/octet-stream'
    "\x01\x02\x03" # acts as binary file data
  end

  post '/v3/live_photos' do
    json_response(201, 'live_photo.json')
  end

  get '/v3/live_photos/:id' do
    json_response(200, 'live_photo.json')
  end

  get '/v3/live_photos' do
    if params["applicant_id"] != "1030303-123123-123123"
      status 404
    else
      json_response(200, 'live_photos.json')
    end
  end

  get '/v3/live_photos/:id/download' do
    status 200
    content_type 'image/jpeg'
    "\x01\x02\x03" # acts as binary file data
  end

  get '/v3/live_videos/:id' do
    json_response(200, 'live_video.json')
  end

  get '/v3/live_videos' do
    if params["applicant_id"] != "1030303-123123-123123"
      status 404
    else
      json_response(200, 'live_videos.json')
    end
  end

  get '/v3/live_videos/:id/download' do
    status 200
    content_type 'video/quicktime'
    "\x01\x02\x03" # acts as binary file data
  end

  post '/v3/checks' do
    params["applicant_id"].nil? ? status(422) : json_response(201, 'check.json')
  end

  get '/v3/checks/:id' do
    json_response(200, "check.json")
  end

  get '/v3/checks' do
    json_response(200, "checks.json")
  end

  post '/v3/checks/:id/resume' do
    status 204 # no_content
  end

  get '/v3/reports' do
    json_response(200, 'reports.json')
  end

  get '/v3/reports/:id' do
    json_response(200, 'report.json')
  end

  post '/v3/reports/:id/resume' do
    status 204
  end

  post '/v3/reports/:id/cancel' do
    status 204
  end

  post '/v3/sdk_token' do
    json_response(201, 'sdk_token.json')
  end

  post '/v3/webhooks' do
    json_response(201, 'webhook.json')
  end

  get '/v3/webhooks/:id' do
    json_response(200, 'webhook.json')
  end

  delete '/v3/webhooks/:id' do
    content_type "application/json; charset=utf-8"
    status 204
  end

  get '/v3/webhooks' do
    json_response(200, 'webhooks.json')
  end

  get '/v3/4xx_response' do
    json_response(422, '4xx_response.json')
  end

  get '/v3/unexpected_error_format' do
    json_response(400, 'unexpected_error_format.json')
  end

  get '/v3/unparseable_response' do
    content_type :json
    status 504
    ''
  end

  private

  def json_response(response_code, file_name)
    content_type "application/json; charset=utf-8"
    status response_code
    File.open(File.dirname(__FILE__) + '/fixtures/' + file_name, 'rb').read
  end

  def pagination_range
    start = (params.fetch('page').to_i - 1) * 20
    limit = start + params.fetch('per_page').to_i - 1
    start..limit
  end
end
