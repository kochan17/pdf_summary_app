class CreatePdfDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :pdf_documents do |t|
      t.text :original_text
      t.text :summary_text

      t.timestamps
    end
  end
end
