class CreateDocuments < ActiveRecord::Migration[7.1]
  def change
    create_table :documents do |t|
      t.text :original_text
      t.text :summary_text
      t.integer :file_type

      t.timestamps
    end
  end
end
