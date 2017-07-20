require 'rails_helper'

RSpec.feature "Admin Articles", type: :feature do

  describe 'listing articles' do
    let!(:articles) { FactoryGirl.create_list :spina_news_article, 3, published_at: Date.today + 1 }
    before { sign_in }

    it 'shows all the articles' do
      visit '/admin/news/articles'
      expect(page).to have_css 'tbody tr', count: 3
    end
  end
end
