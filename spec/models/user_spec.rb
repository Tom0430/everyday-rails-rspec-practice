require 'rails_helper'
# 誤判定出ないことの証明には二つ方法がある
# ひとつめは、to を to_not に変えること
# ふたつめはアプリケーション側のコードを変更して、テストの実行結果にどんな変化が起きるか確認すること

RSpec.describe User, type: :model do

# shouldaMatchersを使うとここまでコードを短縮できる
# validate_presence_of と validate_unique- ness_of はshouldaMatchersのマッチャ
it { is_expected.to validate_presence_of :first_name }
it { is_expected.to validate_presence_of :last_name }
it { is_expected.to validate_presence_of :email }
# case_insensitive で大文字と小文字を区別しない
it { is_expected.to validate_uniqueness_of(:email).case_insensitive }


  # # 姓、名、メール、パスワードがあれば有効な状態であること
  # it "is valid with a first name, last name, email, and password" do
  #   user = FactoryBot.build(:user)
  #   expect(user).to be_valid
  #   # be_validはマッチャと呼ばれるものの一つ モデルが有効な状態を理解できているかどうかを検証している
  # end

  # # 名がなければ無効な状態であること
  # it "is invalid without a first name" do
  #   user = FactoryBot.build(:user, first_name: nil)
  #   user.valid?
  #   expect(user.errors[:first_name]).to include("can't be blank")
  # end

  # it "is invalid without a last name" do
  #   user = FactoryBot.build(:user, last_name: nil)
  #   user.valid?
  #   expect(user.errors[:last_name]).to include("can't be blank")
  # end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    user = FactoryBot.create(:user, email: "test@example.com")
    other_user = FactoryBot.build(:user, email: "test@example.com")
    other_user.valid?
    expect(other_user.errors[:email]).to include("has already been taken")
  end

  it "returns a user's full name as a string" do
  # インスタンスメソッドのテスト　
  # def name
  #   [firstname, lastname].join(' ')
  # end
    user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
    # == ではなく eq　を使う
  end

  # FactoryBot導入
  it "has a valid factory" do
    expect(FactoryBot.build(:user)).to be_valid
  end

  it "is invalid without a first name" do
    user = FactoryBot.build(:user, first_name: nil)
    user.valid?
    expect(user.errors[:first_name]).to include("can't be blank")
  end

  it "is invalid without a last name" do
    user = FactoryBot.build(:user, last_name: nil)
    user.valid?
    expect(user.errors[:last_name]).to include("can't be blank")
  end

  it "is invalid without an email address" do
    user = FactoryBot.build(:user, email: nil)
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  # ユーザーのフルネームを文字列として返すこと　モデルに以下が定義されている
  # def name
  #   [first_name, last_name].join(" ")
  # end
  it "returns a user's full name as a string" do
  user = FactoryBot.build(:user, first_name: "John", last_name: "Doe")
    expect(user.name).to eq "John Doe"
  end

  # 重複したメールアドレスなら無効な状態であること
  it "is invalid with a duplicate email address" do
    FactoryBot.create(:user, email: "aaron@example.com")
    user = FactoryBot.build(:user, email: "aaron@example.com")
    user.valid?
    expect(user.errors[:email]).to include("has already been taken")
  end
  # アカウントが作成されたときにウェルカムメールを送信すること
  it "sends a welcome email on account creation" do
    allow(UserMailer).to \
    receive_message_chain(:welcome_email, :deliver_later)
    user = FactoryBot.create(:user)
    expect(UserMailer).to have_received(:welcome_email).with(user)
  end
end
