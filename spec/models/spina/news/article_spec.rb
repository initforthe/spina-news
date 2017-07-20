require 'rails_helper'

module Spina::News
  RSpec.describe Article, type: :model do
    let(:article) { FactoryGirl.build :spina_news_article }

    subject { article }

    it { is_expected.to be_valid }
    it { expect{article.save}.to change(Spina::News::Article, :count).by(1) }

    context 'with invalid attributes' do
      let(:article) { FactoryGirl.build :invalid_spina_news_article }

      it { is_expected.to_not be_valid }
      it { expect{article.save}.to_not change(Spina::News::Article, :count) }
    end
  end
end
