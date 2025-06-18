require_relative 'password_store'

store = PasswordStore.new

loop do
  puts "\n== RubyPass =="
  puts "1. Add new password"
  puts "2. View all passwords"
  puts "3. Delete a password"
  puts "4. Exit"
  print "> "

  choice = gets.chomp

  case choice
  when "1"
    print "Website: "
    site = gets.chomp
    print "Username: "
    user = gets.chomp
    print "Password: "
    pass = gets.chomp
    store.add(site, user, pass)
    puts "Saved."
  when "2"
    puts "\nSaved Credentials:"
    store.list
  when "3"
    print "Enter website to delete: "
    site = gets.chomp
    store.delete(site)
  when "4"
    puts "Goodbye!"
    break
  else
    puts "Invalid option."
  end
end
