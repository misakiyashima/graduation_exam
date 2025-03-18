require 'rails_helper'

RSpec.describe Task do
  it "インスタンスを作成できる" do
    expect(Task.new).to be_a(Task)
  end
end

