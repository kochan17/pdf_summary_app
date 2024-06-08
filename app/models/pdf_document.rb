class PdfDocument < ApplicationRecord
  validates :original_text, presence: true
  validates :summary_text, presence: true
end
