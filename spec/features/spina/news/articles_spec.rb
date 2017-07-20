require 'rails_helper'

RSpec.feature "Articles", type: :feature do
  let!(:account) { ::Spina::Account.create name: 'MySite', theme: 'default' }

  describe 'listing articles' do
    let!(:articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today - 1 }

    it 'shows all the articles' do
      visit '/news'
      expect(page).to have_css 'li.article', count: 3
    end
  end

  describe 'listing archived articles' do
    let!(:last_year_articles) { FactoryGirl.create_list :spina_news_article, 3, draft: false, published_at: Date.today.beginning_of_year - 1 }

    context 'with a year' do
      it 'shows all the articles' do
        visit "/news/archive/#{Date.today.year - 1}"
        expect(page).to have_content(Date.today.year - 1)
        expect(page).to have_css 'li.article', count: 3
      end
    end

    context 'with a year and month' do
      it 'shows all the articles' do
        visit "/news/archive/#{Date.today.year - 1}/12"
        expect(page).to have_content "December #{Date.today.year - 1}"
        expect(page).to have_css 'li.article', count: 3
      end
    end
  end

  describe 'showing a article' do
    let!(:article) { FactoryGirl.create :spina_news_article }

    it 'shows the article' do
      visit "/news/articles/#{article.slug}"
      expect(page).to have_css 'h1', text: article.title
      expect(page).to have_content article.content
    end
  end
end
