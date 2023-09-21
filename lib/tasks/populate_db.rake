
namespace :db do
  desc 'Populate database with seed data'
  task populate: :environment do
    students_per_school = ARGV[0].to_i
    27.times do
      governorate = Faker::Nation.unique.capital_city

      10.times do
        district = FactoryBot.create(:district, governorate:)

        10.times do
          school = FactoryBot.create(:school, district:)

          students_per_school.times do
            FactoryBot.create(:student, school:)
          end
        end
      end
    end
    puts 'Seed data has been successfully created!'
  end
end
