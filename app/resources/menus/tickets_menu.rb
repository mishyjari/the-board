
require_relative "../../../config/environment.rb"

def ticket_board_menu
  puts "\n\n=====================  TICKET BOARD MENU =========================\n"
  puts "\nOPTIONS:"
  puts "  [:id] Enter Job ID Number to Edit, Assign or Complete Ticket."
  puts "  [a] View ALL INCOMPELTE / ACTIVE Tickets"
  puts "  [u] View only UNASSIGNED Tickets"
  puts "  [p] View only PENDING Tickets"
  puts "  [t] View all tickets TODAY"
  puts ""
  puts "  [n] Create a NEW Ticket"
  puts ""
  puts "  [s] Switch to SEARCH MENU"
  puts "  [c] Switch to the COURIER MENU."
  puts "  [i] Switch to CLIENT MENU."
  puts "  [b] or [m] go BACK to the MAIN MENU."
  puts "  [x] Enter 'x' to exit."

  print "\n> "
  res = gets.chomp.downcase
  puts "\n"

  case res
    when "a"
      clear_screen
      tickets_list('incomplete')
      ticket_board_menu
    when "u"
      clear_screen
      tickets_list('unassigned')
      ticket_board_menu
    when 'p'
      clear_screen
      tickets_list('pending')
      ticket_board_menu
    when 't'
      clear_screen
      tickets_list('today')
      ticket_board_menu
    when "s"
      clear_screen
      puts "\nSearch not implemented, press enter to continue"
      gets.chomp
      clear_screen
      ticket_board_menu
    when "n"
      clear_screen
      puts "\nNew ticket form not implemented. Press enter to continue"
      gets
      clear_screen
      ticket_board_menu
    when "b"
      main_menu
    when "m"
      main_menu
    when "c"
      clear_screen
      courier_board_menu
    when "i"
      clear_screen
      client_board_menu
    when "x"
      exit
    else
      begin
        ticket = Ticket.find(res.to_i)
        clear_screen
        ticket_detail(ticket)
        ticket_detail_menu(ticket)
      rescue
        clear_screen
        puts "\nInvalid Entry, press enter to try again!"
        gets.chomp
        clear_screen
        ticket_board_menu
      end
    end
end
