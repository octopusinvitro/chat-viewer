# frozen_string_literal: true

require 'date'
require 'i18n'

require_relative '../chat/whatsapp_message'
require_relative '../chat/summary'

module Page
  class WhatsappChat
    MESSAGE_START_REGEX = /(?=#{::Chat::WhatsappMessage::TIMESTAMP_REGEX} - )/
    FILE_EXTENSION = '.txt'

    def initialize(filename, chats_path = 'chats')
      @filename = filename
      @chats_path = "#{chats_path}/whatsapp"
    end

    def title
      I18n.t('whatsapp_chat.title')
    end

    def avatar_path
      summary.avatar_path
    end

    def display_name
      summary.display_name
    end

    def all
      chatnames = Dir.glob("#{chats_path}/*").map { |file| basename(file) }
      chatnames.map { |chatname| ::Chat::Summary.new(chatname, 'whatsapp') }
    end

    def messages
      return [] unless path

      @messages ||= File.read(path)
                        .split(MESSAGE_START_REGEX)
                        .sort_by { |message| Date.parse(message[::Chat::WhatsappMessage::TIMESTAMP_REGEX]) }
                        .map { |message| ::Chat::WhatsappMessage.new(message) }
    end

    def group_chat?
      speakers.count > 2
    end

    def animation_delay(message_speaker)
      animation_delays.fetch(message_speaker, 0).to_i
    end

    def exist?
      path
    end

    private

    attr_reader :filename, :chats_path

    def summary
      ::Chat::Summary.new(filename, chats_path)
    end

    def path
      return file_path if File.exist?(file_path)

      return folder_path if File.exist?(folder_path)

      folder_path_with_emojis
    end

    def file_path
      "#{chats_path}/#{filename}#{FILE_EXTENSION}"
    end

    def folder_path
      "#{chats_path}/#{filename}/#{filename}#{FILE_EXTENSION}"
    end

    def folder_path_with_emojis
      Dir.glob("#{chats_path}/#{filename}/*#{FILE_EXTENSION}").first
    end

    def basename(file)
      File.basename(file, FILE_EXTENSION)
    end

    def speakers
      messages.map(&:speaker).uniq.reject(&:empty?)
    end

    def animation_delays
      speakers_without_user_name = speakers - I18n.t('whatsapp_chat.usernames')
      distance_between_color_stops = 100 / speakers_without_user_name.count
      offset = 1
      @animation_delays ||= speakers_without_user_name.each_with_object({}) do |speaker, delays|
        delays[speaker] = distance_between_color_stops * offset
        offset += 1
      end
    end
  end
end
