# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

admin_user = AdminUser.find_or_initialize_by(email: "admin@example.com")
admin_user.update!(password: "password")
puts "Found or created: Admin user with email '#{admin_user.email}' and pass '#{admin_user.password}'"

report = Report.find_or_initialize_by(case_number: "8675309")
report.update!(phone_number: "5551231234")
puts "Found or created: Case report with case number '#{report.case_number}'"

member = HouseholdMember.find_or_initialize_by(first_name: "Todd", last_name: "Chavez")
member.update!(report: report)
puts "Found or created: Member with name '#{member.first_name} #{member.last_name}'"
