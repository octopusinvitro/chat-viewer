# frozen_string_literal: true

require 'i18n'
require 'json'
require 'uri'

module Chat
  class MessengerMessage
    SEPARATOR = " dice:\n"
    SEPARATOR_REGEX = / dice:\s?\r?\n?| says:\s?\r?\n?/
    TIMESTAMP_REGEX = %r{^\d\d/\d\d/\d\d  \d\d:\d\d\r?\n}

    def initialize(message)
      @message = message
    end

    def timestamp; end

    def speaker
      @speaker ||= speaker_and_contents.first
    end

    def contents
      contents = speaker_and_contents[1..].join(SEPARATOR).strip

      URI
        .extract(contents, %w[http https])
        .each { |url| to_link(contents, url) }

      contents.gsub!(/#{emojis}/, JSON.parse(I18n.t('messenger_chat.emojis').to_json))
      contents.split(/\r?\n/)
    end

    def css_class
      return I18n.t('css.system_message') if system?

      I18n.t('css.user_message') if user?
    end

    private

    attr_reader :message

    def speaker_and_contents
      message.split(/#{SEPARATOR_REGEX}|#{TIMESTAMP_REGEX}/)
    end

    def to_link(contents, url)
      contents.gsub!(url, I18n.t('chat.link', url: url, domain: URI(url).host))
    end

    def system?
      speaker.empty?
    end

    def user?
      I18n.t('messenger_chat.usernames').include?(speaker)
    end

    def emojis
      I18n.t('messenger_chat.emojis').keys.join('|').gsub(/\[|\(|\)|\]|\*/) { |emoji| "\\#{emoji}" }
    end
  end
end
