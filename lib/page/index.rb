# frozen_string_literal: true

require 'i18n'

module Page
  class Index
    def title
      I18n.t('index.title')
    end
  end
end
