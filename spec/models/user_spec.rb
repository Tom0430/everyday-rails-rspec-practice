require 'rails_helper'

RSpec.describe User, type: :model do

  # 姓、名、メール、パスワードがあれば有効な状態であること
  it "is valid with a first name, last name, email, and password" do
    user = User.new(
      first_name: "Aaron",
      last_name:  "Sumner",
      email:      "test@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    expect(user).to be_valid
    # be_validはマッチャと呼ばれるものの一つ　モデルが有効な状態を理解できているかどうかを検証している
  end

  # 名がなければ無効な状態であること
  it "is invalid without a first name" do
    user = User.new(first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid without a last name" do
    user = User.new(last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    User.create(
      first_name:  "Joe",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    user = User.new(
      first_name:  "Jane",
      last_name:  "Tester",
      email:      "tester@example.com",
      password:   "dottle-nouveau-pavilion-tights-furze",
    )
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end

  it "returns a user's full name as a string" do
      # インスタンスメソッドのテスト　
      # def name
      #   [firstname, lastname].join(' ')
      # end

    user = User.new(
      first_name: "John",
      last_name:  "Doe",
      email:      "johndoe@example.com",
    )
    expect(user.name).to eq "John Doe"
    # == ではなく eq　を使う
  end

end

# 誤判定出ないことの証明には二つ方法がある
# ひとつめは、to を to_not に変えること
# ふたつめはアプリケーション側のコードを変更して、テストの実行結果にどんな変化が起きるか確認すること