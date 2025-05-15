# Create a dummy user for testing
user = User.create!(
  email: 'vdaubry@gmail.com',
  password: 'Azerty123',
  firstname: 'Vincent',
  lastname: 'Daubry',
  token: SecureRandom.hex(16),
  refresh_token: SecureRandom.hex(16),
  language: 'fr',
  admin: false
)

puts "Created test user with email: #{user.email}" 