require 'spec_helper'

RSpec.describe ActiveRecord::Base, type: :model do
  it 'ActiveRecord::Baseが認識されることを確認' do
    expect(ActiveRecord::Base).not_to be_nil
  end
end
