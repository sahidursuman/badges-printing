require 'barby'
require 'barby/outputter/png_outputter'
require 'barby/barcode/code_39'
require 'RMagick'

class Attendee
  include Magick
  include ActiveAttr::Model
  attribute :attendee_id
  attribute :firstname
  attribute :lastname
  attribute :company_name
  attribute :uniq_id
  attribute :code

  def barcode_options
    {
      height: 90,
      margin: 2,
      xdim: 4
    }
  end

  def barcode_path
    File.join([Rails.root, "public","images", "barcodes", "#{uniq_id}.png"])
  end

  def badge_path
    File.join([Rails.root, "public","images", "badges", "#{uniq_id}.pdf"])
  end

  def generate_barcode
    barcode = Barby::Code39.new(self.uniq_id)
    outputter = Barby::PngOutputter.new(barcode)
    write_barcode(outputter)
  end

  def write_barcode(barcode)
    File.open(barcode_path, 'w'){|f| f.write barcode.to_png(barcode_options) }
  end

  def get_barcode
    generate_barcode unless File.exists?(barcode_path)
    barcode_path
  end

  def get_badge
    generate_badge
    badge_path
  end

  def generate_badge
    view = ActionView::Base.new(ActionController::Base.view_paths, {})
    pdf = WickedPdf.new.pdf_from_string(
      view.render(pdf: "test.pdf", template: badge_template, locals: { attendee: self }),
      :page_height => '93mm',
      :page_width => '54mm',
      :margin => {:top    => 0,
                  :bottom => 0,
                  :left   => 0,
                  :right  => 0}
    )
    File.open(badge_path, 'wb') do |f|
      f << pdf
    end
  end

  def badge_template
    case code.upcase
    when "ATE"
      "attendees/barcode_badge.pdf.haml"
    else
      "attendees/no_barcode_badge.pdf.haml"
    end
  end
end