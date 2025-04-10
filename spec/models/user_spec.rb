require 'rails_helper'

RSpec.describe User, type: :model do
  # ユーザーの有効性を確認
  it 'ユーザーが有効であることを確認' do
    user = User.new(
      email: 'test@example.com',
      password: 'password123',
      password_confirmation: 'password123',
      name: 'Test User'
    )
    expect(user).to be_valid
  end

  describe 'ログイン認証の確認' do
    before do
      @user = User.create!(
        email: "test#{Time.now.to_i}@example.com", # 一意のメールアドレス
        password: 'password123',
        password_confirmation: 'password123',
        name: "Test User #{Time.now.to_i}" # 一意の名前
      )
    end

    it '正しいメールアドレスとパスワードで認証が成功すること' do
      authenticated_user = User.login(@user.email, 'password123')
      expect(authenticated_user).to eq(@user)
    end

    it '間違ったパスワードで認証が失敗すること' do
      authenticated_user = User.login(@user.email, 'wrongpassword')
      expect(authenticated_user).to be_nil
    end
  end
end
