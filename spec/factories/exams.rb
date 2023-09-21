# == Schema Information
#
# Table name: exams
#
#  id          :bigint           not null, primary key
#  examiner_id :bigint           not null
#  start_time  :datetime         not null
#  end_time    :datetime         not null
#  max_grade   :decimal(, )      not null
#  questions   :text             not null
#  answers     :text             not null
#  name        :string
#
FactoryBot.define do
  factory :exam do
    name { Faker::Alphanumeric.alpha(number: rand(5..8)) }
    association :examiner, factory: :examiner_user
    factory :exam_with_branches, parent: :exam do
      branches { create_list :branch, 1 }
    end
    start_time { Faker::Time.between(from: DateTime.now + 28.hours, to: DateTime.now + 30.hours) }
    end_time { Faker::Time.between(from: DateTime.now + 32.hours, to: DateTime.now + 35.hours) }
    max_grade { Faker::Number.between(from: 10, to: 100) }
    questions { [{'question':'Qes1','choices':['c1','c2','c3','c4']},
                 {'question':'ques2','choices':['c1','c2','c3','c444']},
                 {'question':'ques3','choices':['c1','c2','c3','c4','c5555','c6']}] }

    answers { [1, 2, 3] }
  end
end
