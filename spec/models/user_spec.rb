require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.create(:user)
  end

  it "is valid with a name, email, and password" do
    expect(@user).to be_valid
  end

  context "invalid a name" do
    it "is invalid without a name" do
      user = FactoryBot.build(:user, name: nil)
      user.valid?
      expect(user.errors[:name]).to include("が入力されていません。")
    end

     it "too long name" do
       user = FactoryBot.build(:user, name: "a"*21)
       user.valid?
       expect(user.errors[:name]).to include("が長すぎます")
     end
  end
  
  context "invalid a email" do
    it "is invalid without an email" do
      user = FactoryBot.build(:user, email: nil)
      user.valid?
      expect(user.errors[:email]).to include("が入力されていません。")
    end

    it "is invalid with a duplicate email" do
      FactoryBot.create(:user, email:"test@test.com")
      user = User.new(
        name: "Test",
        email: "test@test.com",
        password: "password",
      )
      user.valid?
      expect(user.errors[:email]).to include("はすでに存在します")
    end
  end

  context "invalid a password" do
    it "is invalid without a password" do
      user = FactoryBot.build(:user, password: nil)
      user.valid?
      expect(user.errors[:password]).to include("が入力されていません。")
    end
  end

  context "invalid a introduction" do
    it "is invalid an introduction too long" do
      user = User.new(name: "Test User", email: "test@test.com", password: "password", introduction: "a"*141)
      user.valid?
      expect(user.errors[:introduction]).to include("は140文字以内で入力してください")
    end
  end

  context "didn't like" do
    it "return true" do
      post1 = @user.posts.create(body: "hello, world!")
      @user.likes.create(post_id: post1.id)
      liked_post = @user.already_liked?(post1)
      expect(liked_post).to eq true
    end

    it "return false" do
      post1 = @user.posts.create(body: "hello, world!")
      liked_post = @user.already_liked?(post1)
      expect(liked_post).to eq false
    end
  end

  describe "#search" do
    before do
      @other_user = User.create(
        name: "Mike Brawn",
        email: "mike@brawn.com",
        password: "password"
      )
    end  

    context "search by Test" do
      it "return @user" do
        expect(User.search("Test")).to include(@user)
      end

      it "doesn't return @other_user" do
        expect(User.search("Test")).to_not include(@other_user)
      end
    end

    context "search by John" do
      it "return empty" do
        expect(User.search("John")).to be_empty
      end
    end
  end
end
