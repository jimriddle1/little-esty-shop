require 'httparty'
require 'json'

class HolidayService
  def holidays
    response = HTTParty.get("https://date.nager.at/api/v3/NextPublicHolidays/US")
    JSON.parse(response.body, symbolize_names: true)
  end
end
