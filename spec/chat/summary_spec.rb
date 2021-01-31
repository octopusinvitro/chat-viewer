# frozen_string_literal: true

require 'chat/summary'

RSpec.describe Chat::Summary do
  let(:item) { described_class.new('one-on-one', 'chats-folder') }

  it 'has a slug' do
    expect(item.slug).to eq('/chats-folder/one-on-one')
  end

  it 'has a slug name with folder' do
    item = described_class.new('contact/chat-contact', 'chats-folder')
    expect(item.slug).to eq('/chats-folder/contact/chat-contact')
  end

  xit 'has an avatar' do
    expect(item.avatar_path).to eq('/chats-folder/one-on-one')
  end

  it 'has a default avatar if missing one' do
    expect(item.avatar_path).to eq(I18n.t('chat.default_avatar'))
  end

  it 'has a display name' do
    expect(item.display_name).to eq('One On One')
  end

  it 'has a display name with folder' do
    item = described_class.new('contact/chat-contact', 'chats-folder')
    expect(item.display_name).to eq('Contact/chat Contact')
  end
end
