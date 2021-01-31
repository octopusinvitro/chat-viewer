# frozen_string_literal: true

require 'page/messenger_index'

RSpec.describe Page::MessengerIndex do
  it 'has a title' do
    expect(described_class.new('irrelevant').title).to_not be_nil
  end

  it 'has a default avatar path' do
    expect(described_class.new('irrelevant').avatar_path).to_not be_nil
  end

  it 'has a default display name' do
    expect(described_class.new('irrelevant').display_name).to_not be_nil
  end

  it 'has a list of all chats' do
    all = described_class.new('spec/fixtures/messenger').all
    expect(all.count).to eq(3)
  end

  it 'lists all chats as chat summaries' do
    all = described_class.new('spec/fixtures/messenger').all
    expect(all.map(&:slug)).to eq(
      %w[
        /messenger/another-contact/chat-group
        /messenger/another-contact/chat1
        /messenger/contact/chat-contact
      ]
    )
  end

  it 'has no chat to display' do
    expect(described_class.new('irrelevant').messages).to be_empty
  end

  it 'has no group chat to display' do
    expect(described_class.new('irrelevant').group_chat?).to eq(false)
  end
end
