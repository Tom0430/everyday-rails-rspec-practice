require 'rails_helper'

# データベースにアクセスしないでテストをかく
RSpec.describe NotesController, type: :controller do
    # 通常のdouble
    let(:user) { double("user") }
    # 検証機能付きのdouble
    let(:project) { instance_double("Project", owner: user, id: "123") }

    before do
        # Deviseの authenticate! と current_user メソッドをスタブ化
        allow(request.env["warden"]).to receive(:authenticate!).and_return(user)
        allow(controller).to receive(:current_user).and_return(user)

        # Active Recordの Project.find メソッドもスタブ化
        # テストダブルの project が代わりに返される
        allow(Project).to receive(:find).with("123").and_return(project)
    end
    describe "#index" do
    # 入力されたキーワードでメモを検索すること
        it "searches notes by the provided keyword" do
            expect(project).to receive_message_chain(:notes, :search).
                with("rotate tires")
            get :index,
                params: { project_id: project.id, term: "rotate tires" }
        end
    end
end