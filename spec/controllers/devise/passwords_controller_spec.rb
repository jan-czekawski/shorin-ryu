require "rails_helper"

RSpec.describe Devise::PasswordsController, type: :controller do
  before(:each) do
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "#new" do
    context "when user logged in" do
      it "redirects to root url" do
        sign_in create(:user)
        get :new
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      it "renders new template and assigns new user to @user" do
        get :new
        expect(response).to render_template :new
        expect(assigns(:user)).to be_a_new(User)
      end
    end
  end

  describe "#create" do
    context "when user logged in" do
      it "redirects to root url" do
        user = create(:user)
        sign_in user
        post :create, params: { user: { email: user.email } }
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      it "redirects to login url after password reset" do
        user = create(:user)
        post :create, params: { user: { email: user.email } }
        expect(response).to require_login
      end

      it "assigns new password token to user" do
        user = create(:user)
        post :create, params: { user: { email: user.email } }
        expect(user.reload.reset_password_token).not_to be_nil
      end

      it "assigns unique password token to user" do
        user = create(:user)
        post :create, params: { user: { email: user.email } }
        original_user_token = user.reload.reset_password_token
        post :create, params: { user: { email: user.email } }
        user.reload
        expect(user).not_to have_reset_token_equal_to(original_user_token)
      end

      it "assigns current time to password reset sent at of user" do
        user = create(:user)
        post :create, params: { user: { email: user.email } }
        sent_at = user.reload.reset_password_sent_at
        expect(sent_at).to be_within(1.second).of Time.now
      end
    end
  end

  describe "#edit" do
    context "when user logged in" do
      it "redirects to root url" do
        user = create(:user)
        sign_in user
        user.reset_password_token = "random_token"
        get :edit, params: { reset_password_token: user.reset_password_token }
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in" do
      it "renders edit template and assigns new instance of User to @user" do
        user = create(:user)
        user.reset_password_token = "random_token"
        get :edit, params: { reset_password_token: user.reset_password_token }
        expect(assigns(:user)).to be_a_new(User)
        expect(response).to render_template :edit
      end
    end
  end

  describe "#update" do
    context "when user logged in" do
      it "redirects to root url" do
        user = create(:user)
        sign_in user
        token = user.send_reset_password_instructions
        put :update, params: { reset_password_token: token,
                               user: { password: "new_password",
                                       password_confirmation: "new_password" } }
        expect(response).to redirect_to root_url
      end
    end

    context "when user not logged in", :new do
      describe "with valid information" do
        it "updates users password" do
          user = create(:user)
          token = user.send_reset_password_instructions
          put :update, params: { user: { reset_password_token: token,
                                         password: "new_password",
                                         password_confirmation: "new_password" } }
          expect(user.reload).to have_password_set_as "new_password"
        end

        it "redirects to root and signs user in" do
          user = create(:user)
          token = user.send_reset_password_instructions
          put :update, params: { user: { reset_password_token: token,
                                         password: "new_password",
                                         password_confirmation: "new_password" } }
          expect(response).to redirect_to root_url
          expect(session).to be_logged_in
        end
      end

      describe "with invalid information" do
        describe "when password token is invalid" do
          it "doesn't update user's password" do
            user = create(:user)
            user.send_reset_password_instructions
            put :update,
                params: { user: { reset_password_token: nil,
                                  password: "new_password",
                                  password_confirmation: "new_password" } }
            expect(user.reload).not_to have_password_set_as "new_password"
          end

          it "renders edit template" do
            user = create(:user)
            user.send_reset_password_instructions
            put :update,
                params: { user: { reset_password_token: nil,
                                  password: "new_password",
                                  password_confirmation: "new_password" } }
            expect(response).to render_template :edit
          end
        end

        describe "when password token is outdated" do
          it "doesn't update user's password" do
            user = create(:user)
            token = user.send_reset_password_instructions
            user.update_attribute(:reset_password_sent_at, 7.hours.ago)
            put :update,
                params: { user: { reset_password_token: token,
                                  password: "new_password",
                                  password_confirmation: "new_password" } }
            expect(user.reload).not_to have_password_set_as "new_password"
          end

          it "renders edit template" do
            user = create(:user)
            token = user.send_reset_password_instructions
            user.update_attribute(:reset_password_sent_at, 7.hours.ago)
            put :update,
                params: { user: { reset_password_token: token,
                                  password: "new_password",
                                  password_confirmation: "new_password" } }
            expect(response).to render_template :edit
          end
        end
      end
    end
  end
end
