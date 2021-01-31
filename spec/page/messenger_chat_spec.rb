# frozen_string_literal: true

require 'page/messenger_chat'

RSpec.describe Page::MessengerChat do
  it 'has a title' do
    expect(described_class.new('irrelevant', 'irrelevant').title).to_not be_nil
  end

  it 'has an avatar path' do
    chat = described_class.new('contact/chat-contact', 'spec/fixtures')
    expect(chat.avatar_path).to eq(I18n.t('chat.default_avatar'))
  end

  it 'has a display name' do
    expect(described_class.new('contact/chat-contact', 'irrelevant').display_name).to eq('Contact/chat Contact')
  end

  describe '#all' do
    it 'has a list of all chats' do
      all = described_class.new('irrelevant', 'spec/fixtures').all
      expect(all.count).to eq(3)
    end

    it 'lists all chats as chat summaries' do
      all = described_class.new('irrelevant', 'spec/fixtures').all
      expect(all.map(&:slug)).to eq(
        %w[
          /messenger/another-contact/chat-group
          /messenger/another-contact/chat1
          /messenger/contact/chat-contact
        ]
      )
    end
  end

  describe '#messages' do
    it 'has a chat to display' do
      expect(described_class.new('contact/chat-contact', 'spec/fixtures').messages.count).to eq(6)
    end

    it 'identifies system messages' do
      chat = described_class.new('another-contact/chat1', 'spec/fixtures')
      expect(chat.messages.first.contents).to eq(
        ['Nunca revele sus contraseñas o números de tarjetas de crédito en una conversación de mensajes instantáneos.']
      )
    end
  end

  describe '#group_chat?' do
    it 'is not a group chat if one on one' do
      expect(described_class.new('another-contact/chat1', 'spec/fixtures').group_chat?).to eq(false)
    end

    it 'is a group chat with more than one speaker' do
      expect(described_class.new('another-contact/chat-group', 'spec/fixtures').group_chat?).to eq(true)
    end

    xit 'works with empty lines' do
      expect(described_class.new('contact/chat-contact', 'spec/fixtures').group_chat?).to eq(false)

      expect(described_class.new('contact/unix', 'spec/fixtures').group_chat?).to eq(false)
    end
  end

  describe '#animation_delay' do
    it 'has zero animation delay for system messages' do
      chat = described_class.new('another-contact/chat1', 'spec/fixtures')
      expect(chat.animation_delay('')).to eq(0)
    end

    it 'has zero animation delay for user messages' do
      chat = described_class.new('another-contact/chat-group', 'spec/fixtures')
      expect(chat.animation_delay(I18n.t('messenger_chat.usernames').first)).to eq(0)
    end

    it 'has animation delay between 0 and 100 for contact messages' do
      chat = described_class.new('another-contact/chat-group', 'spec/fixtures')
      expect(chat.animation_delay('Contact')).to eq(40)
    end

    it 'produces same animation delay value for the same contact' do
      chat = described_class.new('another-contact/chat-group', 'spec/fixtures')
      expect(chat.animation_delay('Contact2')).to eq(60)
      expect(chat.animation_delay('Contact2')).to eq(60)
    end
  end

  describe '#exist?' do
    it 'has a chat if file exists' do
      expect(described_class.new('another-contact/chat-group', 'spec/fixtures').exist?).to be_truthy
    end

    it 'has no chat if file does not exist' do
      expect(described_class.new('contact/inexistent_file', 'spec/fixtures').exist?).to be_falsey
    end
  end
end
