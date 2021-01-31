# frozen_string_literal: true

require 'page/whatsapp_chat'

RSpec.describe Page::WhatsappChat do
  it 'has a title' do
    expect(described_class.new('irrelevant', 'irrelevant').title).to_not be_nil
  end

  it 'has an avatar path' do
    expect(described_class.new('one-on-one', 'spec/fixtures').avatar_path).to eq(I18n.t('chat.default_avatar'))
  end

  it 'has a display name' do
    expect(described_class.new('one-on-one', 'irrelevant').display_name).to eq('One On One')
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
          /whatsapp/group-chat
          /whatsapp/one-on-one
          /whatsapp/with-emojis
        ]
      )
    end
  end

  describe '#messages' do
    it 'has a chat to display' do
      expect(described_class.new('one-on-one', 'spec/fixtures').messages.count).to eq(5)
    end

    it 'orders chat messages by date' do
      expect(described_class.new('one-on-one', 'spec/fixtures').messages.map(&:timestamp)).to eq(
        [
          '03/07/2016, 20:50',
          '03/07/2016, 23:08',
          '31/10/2016, 23:41',
          '29/10/2018, 19:50',
          '03/07/2020, 20:50'
        ]
      )
    end

    it 'works with filename with emojis' do
      expect(described_class.new('with-emojis', 'spec/fixtures').messages.count).to eq(5)
    end
  end

  describe '#group_chat?' do
    it 'is not a group chat if one on one' do
      expect(described_class.new('one-on-one', 'spec/fixtures').group_chat?).to eq(false)
    end

    it 'is a group chat with more than one speaker' do
      expect(described_class.new('group-chat', 'spec/fixtures').group_chat?).to eq(true)
    end
  end

  describe '#animation_delay' do
    it 'has zero animation delay for system messages' do
      chat = described_class.new('one-on-one', 'spec/fixtures')
      expect(chat.animation_delay('')).to eq(0)
    end

    it 'has zero animation delay for user messages' do
      chat = described_class.new('group-chat', 'spec/fixtures')
      expect(chat.animation_delay(I18n.t('whatsapp_chat.usernames').first)).to eq(0)
    end

    it 'has animation delay between 0 and 100 for contact messages' do
      chat = described_class.new('group-chat', 'spec/fixtures')
      expect(chat.animation_delay('speaker 3')).to eq(75)
    end

    it 'produces same animation delay value for the same contact' do
      chat = described_class.new('group-chat', 'spec/fixtures')
      expect(chat.animation_delay('Speaker 4')).to eq(100)
      expect(chat.animation_delay('Speaker 4')).to eq(100)
    end
  end

  describe '#exist?' do
    it 'has a chat if file exists' do
      expect(described_class.new('one-on-one', 'spec/fixtures').exist?).to be_truthy
    end

    it 'has no chat if file does not exist' do
      expect(described_class.new('inexistent_file', 'spec/fixtures').exist?).to be_falsey
    end
  end
end
