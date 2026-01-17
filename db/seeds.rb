# Create default admin user
admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end

puts "Admin user created: #{admin.email_address}"
