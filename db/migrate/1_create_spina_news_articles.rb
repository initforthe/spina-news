class CreateSpinaNewsArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :spina_news_articles do |t|
      t.string :title
      t.text :excerpt
      t.text :content
      t.belongs_to :photo
      t.boolean :draft
      t.datetime :published_at
      t.string :slug, unique: true, index: true
      t.belongs_to :user, foreign_key: { to_table: :spina_users }

      t.timestamps
    end
  end
end
