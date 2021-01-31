# frozen_string_literal: true

require_relative '../chat_viewer'

RSpec.describe 'ChatViewer' do
  def app
    ChatViewer.set :chats_path, 'spec/fixtures'
    ChatViewer
  end

  describe '/' do
    before { get '/' }

    it 'is successful' do
      expect(last_response).to be_ok
    end
  end

  describe '/messenger' do
    before { get '/messenger' }

    it 'lists all chats' do
      expect(last_response.body.scan('<div class="sidebar-item">').count.zero?).to eq(false)
    end

    it 'displays default display name' do
      expect(last_response.body).to include("<h2>#{I18n.t('chat.default_display_name')}</h2>")
    end

    it 'shows no messages' do
      expect(last_response.body).to_not include('<article class="message')
    end
  end

  describe '/whatsapp/:slug (exists)' do
    before { get '/whatsapp/one-on-one' }

    it 'lists all chats' do
      expect(last_response.body.scan('<div class="sidebar-item">').count.zero?).to eq(false)
    end

    it 'displays chat display name' do
      expect(last_response.body).to include('<h2>One On One</h2>')
    end

    it 'shows messages' do
      expect(last_response.body).to include('<article class="message')
    end
  end

  describe '/whatsapp/:slug (does not exist)' do
    before { get '/whatsapp/inexistent' }

    it 'lists all chats' do
      expect(last_response.body.scan('<div class="sidebar-item">').count.zero?).to eq(false)
    end

    it 'displays default display name' do
      expect(last_response.body).to include("<h2>#{I18n.t('chat.default_display_name')}</h2>")
    end

    it 'shows no messages' do
      expect(last_response.body).to_not include('<article class="message')
    end
  end

  describe '/messenger' do
    before { get '/messenger' }

    it 'lists all chats' do
      expect(last_response.body.scan('<div class="sidebar-item">').count.zero?).to eq(false)
    end

    it 'displays default display name' do
      expect(last_response.body).to include("<h2>#{I18n.t('chat.default_display_name')}</h2>")
    end

    it 'shows no messages' do
      expect(last_response.body).to_not include('<article class="message')
    end
  end

  describe '/messenger/:slug (exists)' do
    before { get '/messenger/contact/chat-contact' }

    it 'lists all chats' do
      expect(last_response.body.scan('<div class="sidebar-item">').count.zero?).to eq(false)
    end

    it 'displays chat display name' do
      expect(last_response.body).to include('<h2>Contact/chat Contact</h2>')
    end

    it 'shows messages' do
      expect(last_response.body).to include('<article class="message')
    end
  end

  describe '/messenger/:slug (does not exist)' do
    before { get '/messenger/inexistent/inexsistent' }

    it 'lists all chats' do
      expect(last_response.body.scan('<div class="sidebar-item">').count.zero?).to eq(false)
    end

    it 'displays default display name' do
      expect(last_response.body).to include("<h2>#{I18n.t('chat.default_display_name')}</h2>")
    end

    it 'shows no messages' do
      expect(last_response.body).to_not include('<article class="message')
    end
  end

  describe 'not found' do
    before { get '/not-found' }

    it 'is not successful' do
      expect(last_response).to_not be_ok
    end

    it 'returns 404' do
      expect(last_response.status).to eq(404)
    end

    it 'informs user' do
      expect(last_response.body).to include("<h1>#{I18n.t('chat.not_found')}</h1>")
    end
  end
end
