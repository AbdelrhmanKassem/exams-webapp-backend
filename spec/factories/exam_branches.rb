FactoryBot.define do
  factory :exam_branch do
    exam
    branch { Student.branches.keys.sample }
  end
end
