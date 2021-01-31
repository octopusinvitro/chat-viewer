# frozen_string_literal: true

require 'chat/messenger_message'

RSpec.describe Chat::MessengerMessage do
  it 'extracts no timestamp' do
    message = "Speaker name dice:\r\nSpeaker message."
    expect(described_class.new(message).timestamp).to be_nil
  end

  describe '#speaker' do
    it 'extracts the speaker name' do
      message = "Speaker name dice:\r\nSpeaker message."
      expect(described_class.new(message).speaker).to eq('Speaker name')
    end

    it 'extracts no speaker name for system messages' do
      expect(described_class.new(system_message).speaker).to be_empty
    end

    it 'works with other separators' do
      message = "Speaker name says:\r\nUno.\r\nDos."
      expect(described_class.new(message).speaker).to eq('Speaker name')
    end
  end

  describe '#contents' do
    it 'extracts the message contents' do
      message = "Speaker name dice:\r\ncomo estás?"
      expect(described_class.new(message).contents).to eq(['como estás?'])
    end

    it 'extracts multiline message contents' do
      message = "Speaker name dice:\r\nUno.\r\nDos."
      expect(described_class.new(message).contents).to eq(['Uno.', 'Dos.'])
    end

    it 'supports system message' do
      expect(described_class.new(system_message).contents).to eq(system_contents)
    end

    it 'supports several newline characters' do
      message = "Speaker name dice:\ncomo \nestás?"
      expect(described_class.new(message).contents).to eq(['como ', 'estás?'])
    end

    it 'supports several newlines in system messages' do
      message = system_message.gsub("\r\n", "\n")
      expect(described_class.new(message).contents).to eq(system_contents)
    end

    it 'converts URLs to links' do
      long_url = 'https://www.airbnb.com/rooms/18213848?location=Amsterdam%2C%20North%20Holland%2C%20Netherlands&adults=5&children=0&check_in=2020-01-17&check_out=2020-01-19&source_impression_id=p3_1569956347_rpCdv2OhKoxmPV5S'
      message = "Speaker name dice:\r\nI found this for 5 people: #{long_url}"

      expect(described_class.new(message).contents).to eq(
        ["I found this for 5 people: <a class=\"chat-link\" href=\"#{long_url}\">www.airbnb.com</a>"]
      )
    end

    it 'converts messenger emojis to normal emojis' do
      message = "Speaker name dice:\r\n#{I18n.t('messenger_chat.emojis').keys.join(' ')}"
      expect(described_class.new(message).contents).to eq([I18n.t('messenger_chat.emojis').values.join(' ')])
    end

    it 'works with other separators' do
      message = "Speaker name says:\r\nUno.\r\nDos."
      expect(described_class.new(message).contents).to eq(['Uno.', 'Dos.'])
    end
  end

  describe '#css_class' do
    it 'extracts a CSS system class for system messages' do
      expect(described_class.new(system_message).css_class).to eq(I18n.t('css.system_message'))
    end

    it 'extracts a custom class for user messages' do
      message = "#{I18n.t('messenger_chat.usernames')[0]} dice:\r\n hi"
      expect(described_class.new(message).css_class).to eq(I18n.t('css.user_message'))
    end

    it 'extracts no CSS class for contact messages' do
      message = "speaker name dice: Uno.\nDos."
      expect(described_class.new(message).css_class).to be_nil
    end
  end

  def system_message
    "30/07/04  13:41\r\n Nunca revele sus contraseñas o números de " \
    "tarjetas de crédito en una conversación de mensajes instantáneos.\r\n\r\n"
  end

  def system_contents
    [I18n.t('messenger_chat.system_message')]
  end
end
