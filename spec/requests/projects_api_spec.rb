require 'rails_helper'

RSpec.describe "Projects API", type: :request do

  describe "GET /projects_apis" do
    # 1件のプロジェクトを読み出すこと
    it 'loads a project' do
      user = FactoryBot.create(:user)
      FactoryBot.create(:project,
        name: "Sample Project")
      FactoryBot.create(:project,
        name: "Second Sample Project",
        owner: user)

      # ユーザーのメールアドレスとサインインするためのトークンが毎回必要
      get api_projects_path, params: {
        user_email: user.email,
        user_token: user.authentication_token
      }
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json.length).to eq 1

      # プロジェクトのidを取得
      project_id = json[0]["id"]
      # もう一度認証
      get api_project_path(project_id), params: {
        user_email: user.email,
        user_token: user.authentication_token
      }
      expect(response).to have_http_status(:success)

      json = JSON.parse(response.body)
      expect(json["name"]).to eq "Second Sample Project"
    end

    # プロジェクトを作成できること
    it 'creates a project' do
      user = FactoryBot.create(:user)
      project_attributes = FactoryBot.attributes_for(:project)
      expect {
        post api_projects_path, params: {
          user_email: user.email,
          user_token: user.authentication_token,
          project: project_attributes
        }
      }.to change(user.projects, :count).by(1)
      expect(response).to have_http_status(:success)
    end
  end
end
