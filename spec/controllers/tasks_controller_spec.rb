require 'rails_helper'
RSpec.describe TasksController, type: :controller do
    # support/contexts/project_setupにshared_contextsを作成
    include_context "project setup"

    describe "#show" do
        # JSON 形式でレスポンスを返すこと
        it "responds with JSON formatted output" do
            sign_in user
            #application/json の Content-Type でレスポンスを返してくれる
            #何も指定しないと、text/htmlで返ってくる
            get :show, format: :json,
                params: { project_id: project.id, id: task.id }
            # カスタムマッチャで書き換え spec/support/matchers/content_type
            # expect(response.content_type).to eq "application/json"
            expect(response).to have_content_type :json
        end

        # 新しいタスクをプロジェクトに追加すること
        it "adds a new task to the project" do
            new_task = { name: "New test task" }
            sign_in user
            expect {
                post :create, format: :json,
                params: { project_id: project.id, task: new_task }
            }.to change(project.tasks, :count).by(1)
        end
        # 認証を要求すること
        it "requires authentication" do
            # ここではあえてログインしない
            new_task = { name: "New test task" }
            expect {
                post :create, format: :json,
                params: { project_id: project.id, task: new_task }
            }.to_not change(project.tasks, :count)
            expect(response).to_not be_success
        end
    end
end