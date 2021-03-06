require_relative '../../../config/environment.rb'

class NewTicket

  attr_accessor :client, :pu_addr, :pu_cont, :drop_addr, :drop_cont, :time_ready, :time_due, :rush, :os, :notes
  def initialize
      @client = { name: "Guest" }
      @pu_addr = nil
      @pu_cont = nil
      @drop_addr = nil
      @drop_cont = nil
      @time_ready = Time.now
      @time_due = nil
      @rush = false
      @os = false
      @notes = ""
  end

  def create_ticket
    validate = @pu_addr && @pu_addr.length > 0 &&  @pu_cont && @pu_cont.length > 0 && @drop_addr && @drop_addr.length > 0 && @drop_cont && @drop_cont.length > 0

    if validate
      if @client[:name] == 'Guest'
        @client = Client.create(name: "GUEST_#{Time.now.ctime}")
      end
      t = Ticket.create(pickup_address: @pu_addr,
                        pickup_contact: @pu_cont,
                        dropoff_address: @drop_addr,
                        dropoff_contact: @drop_cont,
                        rush: @rush,
                        notes: @notes,
                        oversize: @os,
                        time_ready: @time_ready,
                        time_ordered: Time.now,
                        time_due: @time_due,
                        client_id: @client.id )
      clear_screen
      puts "\nTicket saved! Redirecting to ticket detail page..."
      puts "Press enter."
      gets
      clear_screen
      ticket_detail(t)
      ticket_detail_menu(t)
    else
      puts 'Please make sure all required fields are filled out!'
      puts 'Press enter to continue.'
      gets
      form
    end
  end

  def menu
    puts "\n====================  NEW TICKET  ==================="
    puts "[0] CLIENT: #{@client[:name]}"
    if @client[:name] != "Guest" && @client.has_contact_info
      puts "  Address: #{@client.address}"
      puts "  Contact: #{@client.contact_person if not nil}"
      puts "  Phone: #{@client.contact_phone if not nil}"
    end
    puts "[1] PICKUP ADDRESS (required): #{@pu_addr if not nil}"
    puts "[2] PICKUP CONTACT (required): #{@pu_cont if not nil}"
    puts "[3] DROPOFF ADDRESS (required): #{@drop_addr if not nil}"
    puts "[4] DROPOFF CONTACT (required): #{@drop_cont if not nil}"
    puts "[5] TIME READY (default: now): #{@time_ready.ctime}"
    puts "[6] feature not implemented."
    puts "[7] RUSH? #{@rush.to_s}"
    puts "[8] OVERSIZE? #{@os.to_s}"
    puts "[9] NOTES: #{@notes}"
    puts ""
    if client[:name] != "Guest" && client.has_contact_info
      puts "[pick] Use client's information for PICKUP INFORMATION"
      puts "[drop] Use client's information for DROPOFF INFORMATION"
    end
    puts "[save] Type 'save' to SAVE THIS TICKET"
    puts "========================================================\n"
    puts "  [t] BACK to TICKETS MENU"
    puts "  [i] Switch to CLIENT MENU"
    puts "  [c] Switch to COURIERS MENU"
    puts "  [m] Back to MAIN MENU"
    puts "  [x] EXIT Application"
  end

  def confirm_exit(str)
    clear_screen
    puts "\nDISCARD TICKET AND EXIT TO #{str.upcase}?"
    print "(y/n)> "
    confirm = gets.chomp.downcase
    clear_screen
    confirm == 'y' ? true : false
  end

  def select_client(res)
      clear_screen
      res = ''
      while res.length == 0 do
        puts "\nSELECT CLIENT FOR NEW TICKET"
        puts "  [:id] client details by ID"
        puts "  [a] ALL clients"
        puts "  [t] Clients with open TICKETS"
        puts "  [b] Go BACK to new ticket form"
        puts "WARNING: FOLLOWING OPIONS WILL DISCARD THIS TICKET"
        puts "  [i] Switch to CLIENTS MENU"
        puts "  [c] Switch to COURIERS MENU"
        puts "  [t] Back to TICKETS MENU"
        puts "  [m] Back to MAIN MENU"
        puts "  [x] EXIT application"
        print "\n> "
        res = gets.chomp
        case res
        when 'a'
          list_clients(Client.all)
          res=''
        when 'b'
          form
        when 'i'
          confirm_exit('clients menu') ? courier_board_menu : res = ''
        when 'c'
          confirm_exit('couriers menu') ? courier_board_menu : res = ''
        when 'm'
          confirm_exit('main menu') ? main_menu : res = ''
        when 't'
          confirm_exit('tickets menu') ? courier_board_menu : res = ''
        when 'x'
          confirm_exit('system console') ? courier_board_menu : res = ''
        else
          begin
            c = Client.find(res.to_i)
            clear_screen
            @client = c
            form
          rescue
            clear_screen
            res = ""
          end
        end
      end
  end

  def update(prompt)
    clear_screen
    self.menu
    print "\n#{prompt}: > "
    res = gets.chomp
    res
  end

  def refresh
    clear_screen
  end

  def form
    clear_screen
    menu
      print "\n> "
      res = gets.chomp.downcase

      case res
      when 'pick'
        @pu_addr = @client.address
        @pu_cont = "#{@client.contact_person} | #{@client.contact_phone}"
        form
      when 'drop'
        @drop_addr = @client.address
        @drop_cont = "#{@client.contact_person} | #{@client.contact_phone}"
        form
      when '0' # CHANGE CLIENT
        select_client(res)
      when '1'
        @pu_addr = update('PICKUP ADDRESS')
        form
      when '2'
        @pu_cont = update('PICKUP CONTACT')
        form
      when '3'
        @drop_addr = update('DROPOFF ADDRESS')
        form
      when '4'
        @drop_cont = update('DROPOFF CONTACT')
        form
      when '5'
        puts 'Datetime methods not implemented. Press enter to continue.'
        gets
        form
      when '6'
        puts 'Datetime methods not implemented. Press enter to continue.'
        gets
        form
      when '7'
        @rush = !@rush
        form
      when '8'
        @os = !@os
        form
      when '9' # NOTES
        clear_screen
        menu
        print "\nNEW NOTE: > "
        new_note = gets.chomp
        @notes += "#{new_note}\n"
        form
      when 'save'
        create_ticket
      when 'm'
        refresh
        confirm_exit('main menu') ? main_menu : form
      when 'i'
        refresh
        confirm_exit('clients menu') ? client_board_menu : form
      when 't'
        refresh
        confirm_exit('tickets menu') ? ticket_board_menu : form
      when 'c'
        refresh
        confirm_exit('couriers menu') ? courier_board_menu : form
      when 'x'
        refresh
        confirm_exit('system console') ? exit : form
      else
        form
      end
  end
end
