FactoryBot.define do
  # projectモデルに belongs_to :owner, class_name: User, foreign_key: :user_id という記述があるから
  # user関連はownerという名前になっている
  factory :user, aliases: [:owner] do
    first_name "Aaron"
    last_name  "Sumner"
    # シーケンスを設定　tester1.@example.com, tester2.@example.com
    sequence(:email) { |n| "tester#{n}@example.com" }
    password "dottle-nouveau-pavilion-tights-furze"
  end
end