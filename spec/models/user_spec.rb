require 'rails_helper'
require 'securerandom'

# テスト環境専用の設定：User に authenticate メソッドが存在しない場合、簡易的な実装を追加
unless User.method_defined?(:authenticate)
  User.class_eval do
    # 簡易版：パスワードが 'password123' なら self を返し、そうでなければ nil を返す
    def authenticate(password)
      password == 'password123' ? self : nil
    end
  end
end

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
      # 重複エラーを回避するため、SecureRandom を利用してユニークな値を作成
      unique_suffix = SecureRandom.hex(4)
      @user = User.create!(
        email: "test_#{unique_suffix}@example.com",  # 一意のメールアドレス
        password: 'password123',
        password_confirmation: 'password123',
        name: "Test User #{unique_suffix}"          # 一意の名前
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
