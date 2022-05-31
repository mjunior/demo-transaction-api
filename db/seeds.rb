# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
1100.times  do
	Transaction.create({
		product: [0,1,2].sample,
    transaction_date: Faker::Date.between(from: Date.today - 30.days, to: Date.today),
    amount: Faker::Number.decimal(l_digits: 4, r_digits: 2),
	})
end