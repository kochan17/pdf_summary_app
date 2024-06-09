class Document < ApplicationRecord
  validates :original_text, presence: true
  validates :summary_text, presence: true

  enum file_type: { pdf: 0, word: 1 }

  def self.create_from_file(file, summary_text)
    original_text = case file.content_type
                    when 'application/pdf'
                      extract_text_from_pdf(file)
                    when 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
                      extract_text_from_word(file)
                    else
                      raise "Unsupported file type"
                    end

    Document.create(original_text: original_text, summary_text: summary_text, file_type: file.content_type_to_enum(file.content_type))
  end

  private

  def self.extract_text_from_pdf(file)
    reader = PDF::Reader.new(file.path)
    reader.pages.map(&:text).join(" ")
  end

  def self.extract_text_from_word(file)
    doc = Docx::Document.open(file.path)
    doc.paragraphs.map(&:text).join("\n")
  end

  def self.file_type_to_enum(content_type)
    case content_type
    when 'application/pdf'
      :pdf
    when 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      :word
    else
      raise "Unsupported file type"
    end
  end
end
