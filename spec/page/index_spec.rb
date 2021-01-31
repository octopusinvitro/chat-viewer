# frozen_string_literal: true

require 'page/index'

RSpec.describe Page::Index do
  it 'has a title' do
    expect(described_class.new.title).to_not be_nil
  end
end
