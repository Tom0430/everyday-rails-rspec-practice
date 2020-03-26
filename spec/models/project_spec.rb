require 'rails_helper'

RSpec.describe Project, type: :model do
  describe "late status" do
    # モデルに以下が定義されている
    # def late?
    #   due_on.in_time_zone < Date.current.in_time_zone
    # end

    # 締切日が過ぎていれば遅延していること
    it "is late when the due date is past today" do
      # project = FactoryBot.build(:project_due_yesterday)　traitを使うことになって書き方変更
      project = FactoryBot.build(:project, :due_yesterday)
      expect(project).to be_late
      # be_late は RSpecに定義されているマッチャではない
      # late または late? という名前の属性やメソッドがあって
      # それが真偽値を返すようになっていれば
      # be_late はメソッドや属性の戻り値が true になっていることを検証してくれる
    end
    # 締切日が今日ならスケジュールどおりであること
    it "is on time when the due date is today" do
      project = FactoryBot.build(:project, :due_today)
      expect(project).to_not be_late
    end
    # 締切日が未来ならスケジュールどおりであること
    it "is on time when the due date is in the future" do
      project = FactoryBot.build(:project, :due_tomorrow)
      expect(project).to_not be_late
    end

    # たくさんのノートが付いていること
    it "can have many notes" do
      # 出来るだけcreateよりbuildにした方がいいとのことで変更
      # ただしspec/projects.rbのafter(:create)もafter(:build)に変更しなければならない
      project = FactoryBot.build(:project, :with_notes)
      expect(project.notes.length).to eq 5
    end

    #一人のユーザーが同じ名前のプロジェクトを作れないこと
    it "does not allow duplicate project names per user" do
      # ここでuserを指定しておかないと別々のユーザーでプロジェクトを作ってしまう
      user = FactoryBot.create(:user)
      old_project = FactoryBot.create(:project, name: "test", user_id: user.id )
      new_project = FactoryBot.build(:project, name: "test", user_id: user.id)
      new_project.valid?
      expect(new_project.errors[:name]).to include("has already been taken")
    end
    #  二人のユーザーが同じ名前を使うことは許可すること
    it "allows two users to share a project name" do
      user = FactoryBot.create(:user)
      other_user = FactoryBot.create(:user)
      project = FactoryBot.create(:project, name: "Test Project", user_id: user.id)
      other_project = other_user.projects.build(name: "Test Project")
      expect(other_project).to be_valid
    end
  end
end
