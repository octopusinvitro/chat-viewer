# frozen_string_literal: true

require 'i18n'

require_relative '../chat/summary'

module Page
  class MessengerIndex
    FILE_EXTENSION = '.txt'

    def initialize(chats_path)
      @chats_path = chats_path
    end

    def title
      I18n.t('chat.title')
    end

    def avatar_path
      I18n.t('chat.default_avatar')
    end

    def display_name
      I18n.t('chat.default_display_name')
    end

    def all
      chatnames = Dir.glob("#{chats_path}/*/chat*#{FILE_EXTENSION}").map { |file| chatpath(file) }
      chatnames.map { |chatname| ::Chat::Summary.new(chatname, 'messenger') }
    end

    def messages
      []
    end

    def group_chat?
      false
    end

    private

    attr_reader :chats_path

    def chatpath(file)
      file.gsub("#{chats_path}/", '').gsub(FILE_EXTENSION, '')
    end
  end
end
