class MovementPdf < Prawn::Document

  def initialize(movement)
    super(top_margin: 70)
    @movement = movement
    movement_header
    movement_details
    if @movement.device_movements.count > 0   # In case No Devices
      table( device_movement_rows,  :header  =>  true,
                                    # :position =>  :center,
                                    :row_colors =>  ["FFFFFF", "FFFFCC"] ) do
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

  def movement_header
    text "Movement \# " + "#{@movement}" + " #{@movement.action}",
        :size   =>  20,
        :align  =>  :center,
        :style  =>  :bold
  end

  def movement_details
    move_down 20
    font_size 10
    table([["Customer", "Client Representative","Site", "Movement Date", "Operator", "Notes"],
          [ @movement.customer.name, @movement.client_rep.name, @movement.site.name, 
            @movement.created_at.to_date, @movement.operator.name, @movement.notes]]) do
      row(0).font_style = :bold
      row(0).align = :center
      row(0).background_color = "DDDDDD"
      row(1).background_color = "FFFFCC"
    end
  end

  
  def device_movement_rows
    move_down 20
    font_size 8
    item = 0  # Item Count
    [["Item", "Product", "Serial #", "Accessories", "Notes"]] +
      @movement.device_movements.map do |d|
        [(item += 1), d.device.product.name, d.device.name, accessories(d), d.notes ]
      end
  end

  def accessories(dev)
    @dev = dev
    if (@dev.bundled_accessories.count > 0)
       [] +
        @dev.bundled_accessories.map do |ba|
          [ba.qty, ba.status, ba.accessory.name]
        end
    else      # In case No Bundled accesories
      [['No Accessories']]
    end
  end


end
