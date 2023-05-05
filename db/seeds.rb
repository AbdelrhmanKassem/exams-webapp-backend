# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

roles = Rails.application.config.default_roles
branches = Rails.application.config.default_branches

roles.each { |name| Role.find_or_create_by(name:) }
branches.each { |name| Branch.find_or_create_by(name:) }

User.find_or_create_by(email: 'admin@example.com') do |admin|
  admin.full_name = 'Admin'
  admin.password = 'Pas$w0rd'
  admin.role = Role.find_by(name: 'admin')
end
