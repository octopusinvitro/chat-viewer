# frozen_string_literal: true

require 'i18n'

module Chat
  class Summary
    def initialize(filename, chats_folder)
      @filename = filename
      @chats_folder = chats_folder
    end

    def slug
      "/#{chats_folder.split('/').last}/#{filename}"
    end

    def avatar_path
      avatar_path = "/#{chats_folder}/#{filename}/avatar.jpeg"
      return avatar_path if File.exist?(avatar_path)

      I18n.t('chat.default_avatar')
    end

    def display_name
      filename.split('-').map(&:capitalize).join(' ')
    end

    private

    attr_reader :filename, :chats_folder
  end
end
