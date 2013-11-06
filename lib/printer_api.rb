module PrinterApi
  extend self

  def connection
    Faraday.new(:url => 'http://google.com') do |faraday|
      faraday.request  :url_encoded             # form-encode POST params
      faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
    end
  end

  def attendees
    response = connection.get("/admin/attendee_prints")
    response.body
  end

  def update_prints(uniq_id, result)
    connection.put do |req|
      req.url "/admin/attendee_prints/#{uniq_id}.json"
      req.params['finished'] = result
    end.body
  end
end
