require 'rails_helper'

RSpec.feature "Tasks", type: :feature do
  let(:user) { FactoryBot.create(:user) }
  let(:project){ FactoryBot.create(:project,
    name: "RSpec tutorial",
    owner: user)}
  !let(:task){ project.tasks.create!(name: "Finish RSpec tutorial")}

  # ユーザーがタスクの状態を切り替える
  scenario "user toggles a task", js: true do
    # sign_in_as user  自作したテストヘルパー spec/support/login_support
    sign_in user #deviseのテストヘルパー

    go_to_project "RSpec tutorial"
    complete_task "Finish RSpec tutorial"
    expect_complete_task "Finish RSpec tutorial"
    undo_complete_task "Finish RSpec tutorial"
    expect_incomplete_task "Finish RSpec tutorial"
  end

  def go_to_project(name)
    visit root_path
    click_link name
  end

  def complete_task(name)
    check name
  end

  def undo_complete_task(name)
    uncheck name
  end

  def expect_complete_task(name)
    aggregate_failures do
      expect(page).to have_css "label.completed", text: name
      expect(task.reload).to be_completed
    end
  end

  def expect_incomplete_task(name)
    aggregate_failures do
      expect(page).to_not have_css "label.completed", text: name
      expect(task.reload).to_not be_completed
    end
  end
end




# これをリファクタリング
# # ユーザーがタスクの状態を切り替える
# scenario "user toggles a task", js: true do
#   # sign_in_as user  自作したテストヘルパー spec/support/login_support
#   sign_in user #deviseのテストヘルパー

#   # 自作したlogin_supportではloginしたあとルートに飛ぶようになってたが、
#   # deviseのヘルパーではセッションの作成だけでページ遷移がない そこでvisit root_pathを追加
#   visit root_path
#   click_link "RSpec tutorial"
#   check "Finish RSpec tutorial"

#   expect(page).to have_css "label#task_#{task.id}.completed"
#   # expect(task.reload).to be_complete  エラーが出る

#   uncheck "Finish RSpec tutorial"

#   expect(page).to_not have_css "label#task_#{task.id}.completed"
#   expect(task.reload).to_not be_completed
# end





# ここが重複してるので切り出してモジュール化している
# visit root_path
# # click_link "Sign in"
# fill_in "Email", with: user.email
# fill_in "Password", with: user.password
# click_button "Log in"

# save_and_open_page
# Railsがブラウザに返したHTMLを見るためにエラーがでるとこの直前に挟む