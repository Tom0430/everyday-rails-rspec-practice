require 'rails_helper'

RSpec.feature "Projects", type: :feature do
  # include LoginSupport テストごとにモジュールを読み込むこともできる

  # ユーザーは新しいプロジェクトを作成する
  scenario "user creates a new project" do
    user = FactoryBot.create(:user)
    sign_in user

    #visit root_path
    # click_link "Sign in"
    #fill_in "Email", with: user.email
    #ill_in "Password", with: user.password
    #click_button "Log in"
    # click_button を使うと、起動されたアクションが完了する前に次の処理へ移ってしまうことがある。
    # click_button を実行した expect{} の内部で最低でも1個以上のエクスペクテーションを実行し、処理の完了を待つようにしている

    expect {
      # 自作したlogin_supportではloginしたあとルートに飛ぶようになってたが、
      # deviseのヘルパーではセッションを作成するだけでページ遷移がない そこでvisit root_pathを追加
      visit root_path
      click_link "New Project"
      fill_in "Name", with: "Test Project"
      fill_in "Description", with: "Trying out Capybara"
      click_button "Create Project"
    }.to change(user.projects, :count).by(1)
    aggregate_failures do
      expect(page).to have_content "Project was successfully created"
      expect(page).to have_content "Test Project"
      expect(page).to have_content "Owner: #{user.name}"
    end
  end
end
