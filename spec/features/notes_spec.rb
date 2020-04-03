require 'rails_helper'

RSpec.feature "Notes", type: :feature do
    let(:user) { FactoryBot.create(:user)}
    let(:project){
        FactoryBot.create(:project,
            name: "RSpec tutorial",
            owner: user)
    }

    # ユーザーが添付ファイルをアップロードする
    scenario "user uploads an attachment" do
        sign_in user
        visit project_path(project)
        click_link "Add Note"
        fill_in "Message", with: "My book cover"
        # attach_fileはCapybaraのメソッド
        # 引数に 入力候補のラベル、テストファイルのパス
        # アップロードされるとデフォで/public/systemにいく
        attach_file "Attachment", "#{Rails.root}/spec/files/attachment.png"
        click_button "Create Note"
        expect(page).to have_content "Note was successfully created"
        expect(page).to have_content "My book cover"
        expect(page).to have_content "attachment.png (image/png"
    end
end