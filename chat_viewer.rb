# frozen_string_literal: true

require 'i18n'
require 'sinatra'

require_relative 'lib/page/whatsapp_chat'
require_relative 'lib/page/whatsapp_index'
require_relative 'lib/page/messenger_chat'
require_relative 'lib/page/messenger_index'
require_relative 'lib/page/index'

class ChatViewer < Sinatra::Base
  I18n.load_path << Dir["#{File.expand_path('locales')}/*.yml"]

  set :chats_path, 'chats'

  get '/' do
    @page = Page::Index.new
    erb :index
  end

  get '/whatsapp' do
    @page = Page::WhatsappIndex.new("#{settings.chats_path}/whatsapp")
    erb :chat
  end

  get '/whatsapp/:slug' do |filename|
    @page = Page::WhatsappChat.new(filename, settings.chats_path)
    pass unless @page.exist?
    erb :chat
  end

  get '/whatsapp/:slug' do
    @page = Page::WhatsappIndex.new("#{settings.chats_path}/whatsapp")
    erb :chat
  end

  get '/messenger' do
    @page = Page::MessengerIndex.new("#{settings.chats_path}/messenger")
    erb :chat
  end

  get '/messenger/:slug1/:chatname' do |folder, filename|
    @page = Page::MessengerChat.new("#{folder}/#{filename}", settings.chats_path)
    pass unless @page.exist?
    erb :chat
  end

  get '/messenger/:slug1/:chatname' do
    @page = Page::MessengerIndex.new("#{settings.chats_path}/messenger")
    erb :chat
  end

  NotFound = Struct.new(:title)
  not_found do
    status 404
    @page = NotFound.new(I18n.t('chat.not_found'))
    erb :index
  end
end
