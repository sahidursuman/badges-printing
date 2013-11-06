require File.expand_path("config/boot")
require File.expand_path('config/environment')
include Clockwork

every(5.seconds, 'printer.print') { PrinterMonitor.print_attendees }
