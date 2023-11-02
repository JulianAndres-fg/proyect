class Product < ApplicationRecord
    include PgSearch::Model
    pg_search_scope :search_full_text, against: {
      name: 'A',
      description: 'B',
    }
    has_one_attached :photo
    belongs_to :category, optional: true
end
