class SalePdf < Prawn::Document

  def initialize(sale)
    super(top_margin: 70)
    @sale = sale
    sale_header
    sale_details
    if @sale.device_sales.count > 0   # In case No Devices
      table( device_sale_rows,  :header  =>   true,
                                # :position =>  :center,
                                :row_colors => ["FFFFFF", "FFFFCC"] ) do
        row(0).font_style = :bold
        row(0).align = :center
        row(0).background_color = "DDDDDD"
      end
    end
    string = "Page <page> of <total>"
    options = { :at => [bounds.right - 150, 0],
                :width => 150,
                :align => :center,
                # :page_filter => (1..7),
                :start_count_at => 1,
                :color => "555555" }
    number_pages string, options
  end

  def sale_header
    text "Sale \# " + "#{@sale}" + " #{@sale.action}",
        :size   =>  20,
        :align  =>  :center,
        :style  =>  :bold
  end

  def sale_details
    move_down 20
    font_size 10
    table([["Seller", "Buyer", "Sale Date", "Operator", "Notes"],
          [@sale.seller.name, @sale.buyer.name, @sale.created_at.to_date, @sale.operator.name, @sale.notes]]) do
      row(0).font_style = :bold
      row(0).align = :center
      row(0).background_color = "DDDDDD"
      row(1).background_color = "FFFFCC"
    end
  end

  
  def device_sale_rows
    move_down 20
    font_size 8
    item = 0  # Item Count
    [["Item", "Product", "Serial #", "Cost", "Lifetime", "Notes"]] +
      @sale.device_sales.map do |d|
        [(item += 1), d.device.product.name, d.device.name, d.cost, d.lifetime, d.notes ]

      end
  end

end
