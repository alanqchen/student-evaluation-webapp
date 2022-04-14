FactoryBot.define do
  factory :user do
    name { Faker::Internet.username(specifier: 1..100, separators: ['.', '_', '-', ' '].freeze) }
    email { Faker::Internet.safe_email }
    password { Faker::Internet.password(min_length: 4, max_length: 68, mix_case: true, special_characters: true) + 'Aa_1' }
    # workaround to add default trait https://github.com/thoughtbot/factory_bot/issues/528
    password_confirmation { password }
    not_admin
    not_instructor
    not_approver

    trait :not_admin do
      admin { false }
    end

    trait :admin do
      admin { true }
    end

    trait :not_instructor do
      instructor { false }
    end

    trait :instructor do
      instructor { true }
    end

    trait :not_approver do
      approver { false }
    end

    trait :approver do
      approver { true }
    end
  end
end
