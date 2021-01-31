# frozen_string_literal: true

require 'digest'
require 'i18n'
require 'uri'

module Chat
  class WhatsappMessage
    TIMESTAMP_REGEX = %r{^\d\d/\d\d/\d{4}, \d\d:\d\d}
    STRIKEDTEXT_REGEX = /(~.*?~)/
    SEPARATOR = ': '

    def initialize(message)
      @message = message
    end

    def timestamp
      message[TIMESTAMP_REGEX]
    end

    def speaker
      @speaker ||= speaker_and_contents.first
    end

    def contents
      contents = speaker_and_contents[1..].join(SEPARATOR)

      URI
        .extract(contents, %w[http https])
        .each { |url| to_link(contents, url) }

      contents.gsub!(I18n.t('whatsapp_chat.media_omitted'), I18n.t('whatsapp_chat.media_omitted_span'))
      contents.scan(STRIKEDTEXT_REGEX).each { |strikedtext| to_striked(contents, strikedtext.first) }
      contents.split("\n")
    end

    def css_class
      return I18n.t('css.system_message') if system?

      I18n.t('css.user_message') if user?
    end

    private

    attr_reader :message

    def speaker_and_contents
      speaker_and_contents = message.split(/#{TIMESTAMP_REGEX} - /).last
      return ['', speaker_and_contents] unless speaker_and_contents.include?(SEPARATOR)

      speaker_and_contents.split(SEPARATOR)
    end

    def to_link(contents, url)
      contents.gsub!(url, I18n.t('chat.link', url: url, domain: URI(url).host))
    end

    def to_striked(contents, strikedtext)
      contents.gsub!(strikedtext, I18n.t('chat.strikedtext', text: strikedtext[1..-2]))
    end

    def system?
      speaker.empty?
    end

    def user?
      I18n.t('whatsapp_chat.usernames').include?(speaker)
    end
  end
end
