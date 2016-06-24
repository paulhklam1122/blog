require 'rails_helper'

RSpec.describe PostsController, type: :controller do
  let(:create_post) {FactoryGirl.create(:post)}
  let(:user)     { create(:user) }

  describe "#new" do
    context "with user not signed in" do
      it "redirects to new user page" do
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }
      it "renders the new template" do
        get :new
        expect(response).to render_template(:new)
      end
      it "instantiates a new post instance variable" do
        get :new
        expect(assigns(:post)).to be_a_new(Post)
      end
    end
  end

  describe "#create" do
    context "with user not signed in" do
      it "redirects to new user page" do
        post :create, post_id: post.id, create_post: {title: "My Post", body: "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua."}
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }
      context "with valid attributes" do
        def valid_request
          post :create, post: FactoryGirl.attributes_for(:post)
        end
        it "saves a record to the database" do
          count_before = Post.count
          valid_request
          count_after = Post.count
          expect(count_after).to eq(count_before + 1)
        end
        it "redirects to the show page of the blog" do
          valid_request
          expect(response).to redirect_to(posts_path(Post.last))
        end
        it "associates the post with the signed in user" do
          valid_request
          expect(Post.last.user).to eq(user)
        end
        it "sets a flash notice message" do
          valid_request
          expect(flash[:notice]).to be
        end
      end

      context "with invalid attributes" do
        def invalid_request
          post :create, post:{title: ""}
        end

        it "doesn't save a record on the database" do
          count_before = Post.count
          invalid_request
          count_after = Post.count
          expect(count_after).to eq(count_before)
        end
        it "renders the new template" do
          invalid_request
          expect(response).to render_template(:new)
        end
        it "sets a flash alert message" do
          invalid_request
          expect(flash[:alert]).to be
        end
      end
    end
  end

  describe "#show" do
    before do
      @post = FactoryGirl.create(:post)
      get :show, id: @post.id
    end

    it "renders the show template" do
      expect(response).to render_template(:show)
    end

    it "sets an instance variable to the blog with the passed id" do
      expect(assigns(:post)).to eq(@post)
    end
  end

  describe "#index" do
    it "renders the index template" do
      get :index
      expect(response).to render_template(:index)
    end
    it "sets 'posts' instance variable to all posts in the DB" do
      post_1 = FactoryGirl.create(:post)
      post_2 = FactoryGirl.create(:post)
      get :index
      expect(assigns(:posts)).to eq([post_1, post_2])
    end
  end

  describe "#edit" do
    before do
      @post = FactoryGirl.create(:post)
      get :edit, id: create_post.id
    end
    it "renders the edit template" do
      expect(response).to render_template(:edit)
    end
    it "sets an instance variable to the post with the id passed" do
      expect(assigns(:post)).to eq(create_post)
    end
  end

  describe "#update" do
    context "With valid attributes" do
      def valid_request
        patch :update, id: create_post.id, post: {title: "new valid title"}
      end
      it "updates the record in the database" do
        valid_request
        expect(create_post.reload.title).to eq("new valid title")
      end
      it "redirects to the show page" do
        valid_request
        expect(response).to redirect_to(post_path(create_post))
      end
      it "sets a flash message" do
        valid_request
        expect(flash[:notice]).to be
      end
    end

    context "with invalid attributes" do
      def invalid_request
        patch :update, id: create_post.id, post: {title: ""}
      end

      it "doesn't save the updated value in the database" do
        invalid_request
        expect(create_post.reload.title).to_not eq("")
      end
      it "renders the edit template" do
        invalid_request
        expect(response).to render_template(:edit)
      end
      it "sets a flash alert message" do
        invalid_request
        expect(flash[:alert]).to be
      end
    end
  end

  describe "#destroy" do
    let!(:create_post) {FactoryGirl.create(:post)}
    context "with user not signed in" do
      it "redirects to the sign in page" do
        expect(response).to redirect_to(new_sessions_path)
      end
    end
    context "with user signed in" do
      before { request.session[:user_id] = user.id }
      it "removed a record from the database" do
        count_before = Post.count
        delete :destroy, id: create_post.id
        count_after = Post.count
        expect(count_before).to eq(count_after + 1)
      end
      it "redirects to the posts_path (listings page)" do
        delete :destroy, id: create_post.id
        expect(response).to redirect_to(posts_path)
      end
    end
  end
end
