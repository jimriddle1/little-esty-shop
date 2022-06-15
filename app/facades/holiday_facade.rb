class HolidayFacade

  def service
    HolidayService.new
  end

  def upcoming_holidays
    service.holidays.map do |data|
      Holiday.new(data)
    end
  end
end
