FactoryGirl.define do
  factory :spina_news_article, class: Spina::News::Article do
    sequence(:title) { |n| "News Article #{n}" }
    content "Some content for my post"

    factory :invalid_spina_news_article do
      title nil
    end
  end
end
