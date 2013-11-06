module PrinterMonitor
  extend self

  def attendees
    @attendees ||= []
  end

  def get_attendees
    JSON.parse(api.attendees).map{ |atts| Attendee.new(atts) }
  end

  def update_attendees
    get_attendees.each do |attendee|
      self.attendees << attendee unless self.attendees.find{ |a| a.uniq_id == attendee.uniq_id }
    end
  end

  def send_result(attendee, printer_result)
    update_result = api.update_prints(attendee.attendee_id, printer_result)
    update_result["ok"] ? puts("print #{attendee.uniq_id} updated") : puts("print #{attendee.uniq_id} failed")
  end

  def print_attendees
    update_attendees
    if attendees.empty?
      puts "nothing to print"
    else
      puts "having #{attendees.count} attendees to print"
      attendees.delete_if do |attendee|
        send_result(attendee, Printer.print_attendee(attendee))
        true
      end
    end
  end

  def api
    PrinterApi
  end
end