require 'cups'

module Printer
  extend self

  def print_attendee(attendee)
    page = Cups::PrintJob.new(attendee.get_badge)
    page.print
  end
end