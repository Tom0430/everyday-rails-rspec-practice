require 'rails_helper'
RSpec.describe TasksController, type: :controller do
    before do
        @user = FactoryBot.create(:user)
        @project = FactoryBot.create(:project, owner: @user)
        @task = @project.tasks.create!(name: "Test task")
    end
    describe "#show" do
        # JSON 形式でレスポンスを返すこと
        it "responds with JSON formatted output" do
            sign_in @user
            #application/json の Content-Type でレスポンスを返してくれる
            #何も指定しないと、text/htmlで返ってくる
            get :show, format: :json,
                params: { project_id: @project.id, id: @task.id }
            expect(response.content_type).to eq "application/json"
        end

        # 新しいタスクをプロジェクトに追加すること
        it "adds a new task to the project" do
            new_task = { name: "New test task" }
            sign_in @user
            expect {
                post :create, format: :json,
                params: { project_id: @project.id, task: new_task }
            }.to change(@project.tasks, :count).by(1)
        end
        # 認証を要求すること
        it "requires authentication" do
            # ここではあえてログインしない
            new_task = { name: "New test task" }
            expect {
                post :create, format: :json,
                params: { project_id: @project.id, task: new_task }
            }.to_not change(@project.tasks, :count)
            expect(response).to_not be_success
        end
    end
end