FactoryBot.define do

  factory :course do
    sequence(:title) { |n| "Course #{n}" }
    description { "Description" }
  end

  factory :tutor do
    sequence(:name) { |n| "Tutor #{n}" }
    course
  end

end