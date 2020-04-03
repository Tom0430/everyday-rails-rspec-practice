require 'rails_helper'

RSpec.describe Note, type: :model do

  # before do~endの代わりにletで必要な時に遅延読み込み
  let(:user) { FactoryBot.create(:user) }
  let(:project) { FactoryBot.create(:project, owner: user) }

  # クラスメソッドのテスト
  # scope :search, ->(term) {where("LOWER(message) LIKE ?", "%#{term.downcase}%")}

  # ユーザー、プロジェクト、メッセージがあれば有効な状態であること
  it "is valid with a user, project, and message" do
    note = FactoryBot.create(:note)
    expect(note).to be_valid
  end

  it "is invalid without a message" do
    note = FactoryBot.build(:note, message: nil)
    note.valid?
    expect(note.errors[:message]).to include("can't be blank")
  end

  # 名前の取得をメモを作成したユーザーに委譲すること
  it "delegates name to the user who created it" do
    # doubleはnameにしか反応しない偽物 NoteクラスではなくあくまでDoubleクラスのオブジェクト
    # しかしただのdoubleだと元のメソッドが変わってもテストが通る
    # user = double("user", name: "Fake User")

    # そこで検証機能付きのテストダブルを使う
    user = instance_double("User", name: "Fake User")
    note = Note.new
    allow(note).to receive(:user).and_return(user)
    expect(note.user_name).to eq "Fake User"
    # Noteクラスのfirst_nameに反応できない 以下はエラーが出る
    # expect(note.user.first_name).to eq "Fake"
  end


  describe "search message for a term" do
      let(:note1) { FactoryBot.create(:note,
        project: project,
        message: "This is the first note."
      )}
      let(:note2) { FactoryBot.create(:note,
        project: project,
        message: "This is the second note."
      )}
      let(:note3){ FactoryBot.create(:note,
        project: project,
        message: "First, preheat the oven."
      )}
    # 一致するデータが見つかるとき
    context "when a match is found" do
      # 検索文字列に一致するメモを返すこと
      it "returns notes that match the search term" do
          expect(Note.search("first")).to include(note1, note3)
      end
    end

    # 一致するデータが1件も見つからないとき
    context "when no match is found" do
      # 空のコレクションを返すこと
      it "returns an empty collection" do
        expect(Note.search("message")).to be_empty
        expect(Note.count).to eq 0
      end
    end
    # paperclipのshouldamatcher使ったらワンライナーでかける
    it { is_expected.to have_attached_file(:attachment) }
  end
end
