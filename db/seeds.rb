# Create default admin user
admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "password123"
  user.password_confirmation = "password123"
end
puts "Admin user created: #{admin.email_address}"

# Create sample products
products = [
  { name: "Laptop", description: "15-inch laptop with 16GB RAM", price: 999.99, quantity: 25 },
  { name: "Wireless Mouse", description: "Ergonomic wireless mouse", price: 29.99, quantity: 50 },
  { name: "USB-C Cable", description: "2m USB-C charging cable", price: 12.99, quantity: 8 },
  { name: "Keyboard", description: "Mechanical keyboard with RGB", price: 79.99, quantity: 15 },
  { name: "Monitor Stand", description: "Adjustable monitor stand", price: 45.99, quantity: 5 }
]

products.each do |attrs|
  Product.find_or_create_by!(name: attrs[:name]) do |product|
    product.description = attrs[:description]
    product.price = attrs[:price]
    product.quantity = attrs[:quantity]
  end
end
puts "Created #{products.size} sample products"
