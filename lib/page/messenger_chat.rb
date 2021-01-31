# frozen_string_literal: true

require 'i18n'

require_relative '../chat/messenger_message'
require_relative '../chat/summary'

module Page
  class MessengerChat
    MESSAGE_START_REGEX = /(.+#{::Chat::MessengerMessage::SEPARATOR_REGEX})|(#{::Chat::MessengerMessage::TIMESTAMP_REGEX})/ # rubocop:disable Layout/LineLength
    FILE_EXTENSION = '.txt'

    def initialize(filename, chats_path = 'chats')
      @filename = filename
      @chats_path = "#{chats_path}/messenger"
    end

    def title
      I18n.t('messenger_chat.title')
    end

    def avatar_path
      summary.avatar_path
    end

    def display_name
      summary.display_name
    end

    def all
      chatnames = Dir.glob("#{chats_path}/*/chat*#{FILE_EXTENSION}").map { |file| chatpath(file) }
      chatnames.map { |chatname| ::Chat::Summary.new(chatname, 'messenger') }
    end

    def messages
      return [] unless path

      @messages ||= File.read(path, encoding: "#{encoding}:utf-8")
                        .split(MESSAGE_START_REGEX)
                        .reject(&:empty?)
                        .each_slice(2)
                        .map { |message| ::Chat::MessengerMessage.new(message.join('')) }
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
      path = "#{chats_path}/#{filename}#{FILE_EXTENSION}"
      path if File.exist?(path)
    end

    def chatpath(file)
      file.gsub("#{chats_path}/", '').gsub(FILE_EXTENSION, '')
    end

    def encoding
      `file --mime '#{path}'`.strip.split('charset=').last
    end

    def speakers
      messages.map(&:speaker).uniq.reject(&:empty?)
    end

    def animation_delays
      speakers_without_user_name = speakers - I18n.t('messenger_chat.usernames')
      distance_between_color_stops = 100 / speakers_without_user_name.count
      offset = 1
      @animation_delays ||= speakers_without_user_name.each_with_object({}) do |speaker, delays|
        delays[speaker] = distance_between_color_stops * offset
        offset += 1
      end
    end
  end
end
