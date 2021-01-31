# frozen_string_literal: true

require 'chat/whatsapp_message'

RSpec.describe Chat::WhatsappMessage do
  it 'extracts the timestamp' do
    message = '23/01/2019, 21:26 - Whatever.'
    expect(described_class.new(message).timestamp).to eq('23/01/2019, 21:26')
  end

  describe '#speaker' do
    it 'extracts the speaker name' do
      message = '23/01/2019, 21:26 - speaker name: Speaker message.'
      expect(described_class.new(message).speaker).to eq('speaker name')
    end

    it 'extracts no speaker name for system messages' do
      expect(described_class.new(system_message).speaker).to be_empty
    end
  end

  describe '#contents' do
    it 'extracts the message contents' do
      message = '23/01/2019, 21:26 - speaker name: Speaker message.'
      expect(described_class.new(message).contents).to eq(['Speaker message.'])
    end

    it 'extracts multiline message contents' do
      message = "23/01/2019, 21:26 - speaker name: Uno.\nDos."
      expect(described_class.new(message).contents).to eq(['Uno.', 'Dos.'])
    end

    it 'converts <Media omitted> to message' do
      message = '23/01/2019, 21:26 - speaker name: <Media omitted>'
      expect(described_class.new(message).contents).to eq(['<span class="media-omitted">Media Omitted</span>'])
    end

    it 'converts URLs to links' do
      long_url = 'https://www.airbnb.com/rooms/18213848?location=Amsterdam%2C%20North%20Holland%2C%20Netherlands&adults=5&children=0&check_in=2020-01-17&check_out=2020-01-19&source_impression_id=p3_1569956347_rpCdv2OhKoxmPV5S'
      message = "23/01/2019, 21:26 - speaker name: I found this for 5 people: #{long_url}"

      expect(described_class.new(message).contents).to eq(
        ["I found this for 5 people: <a class=\"chat-link\" href=\"#{long_url}\">www.airbnb.com</a>"]
      )
    end

    it 'converts ~ to strikethrough' do
      message = '23/01/2019, 21:26 - speaker name: this is some ~strikethrough~ text. ' \
      'This won\'t be strikethrough. But ~this will be~.'
      expect(described_class.new(message).contents).to eq(
        [
          'this is some <span style="text-decoration:line-through;">strikethrough</span>' \
          ' text. This won\'t be strikethrough. But <span style="text-decoration:line-through;">this will be</span>.'
        ]
      )
    end
  end

  describe '#css_class' do
    it 'extracts a CSS system class for system messages' do
      expect(described_class.new(system_message).css_class).to eq(I18n.t('css.system_message'))
    end

    it 'extracts a custom class for user messages' do
      message = "13/10/2018, 10:31 - #{I18n.t('whatsapp_chat.usernames').first}: hi"
      expect(described_class.new(message).css_class).to eq(I18n.t('css.user_message'))
    end

    it 'extracts no CSS class for contact messages' do
      message = "23/01/2019, 21:26 - speaker name: Uno.\nDos."
      expect(described_class.new(message).css_class).to be_nil
    end
  end

  def system_message
    '13/10/2018, 10:31 - Messages and calls are end-to-end encrypted. ' \
    'No one outside of this chat, not even WhatsApp, can read or listen ' \
    'to them. Tap to learn more.'
  end
end
