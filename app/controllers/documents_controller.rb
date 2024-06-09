class DocumentsController < ApplicationController
  def new
    @document = Document.new
  end

  def create
    uploaded_file = params[:document][:file]
    original_text = extract_text_from_file(uploaded_file)

    api_key = ENV["OPENAI_API_KEY"]
    openai_service = OpenaiService.new(api_key)
    summary_text = openai_service.summarize(original_text)

    file_type = file_type_to_enum(uploaded_file.content_type)
    @document = Document.new(original_text: original_text, summary_text: summary_text, file_type: file_type)

    if @document.save
      redirect_to @document
    else
      render :new
    end
  end

  def show
    @document = Document.find(params[:id])
  end

  private

  def extract_text_from_file(file)
    case file.content_type
    when 'application/pdf'
      extract_text_from_pdf(file)
    when 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'
      extract_text_from_word(file)
    else
      raise "Unsupported file type"
    end
  end

  def extract_text_from_pdf(file)
    reader = PDF::Reader.new(file.path)
    reader.pages.map(&:text).join(" ")
  end

  def extract_text_from_word(file)
    doc = Docx::Document.open(file.path)
    doc.paragraphs.map(&:text).join("\n")
  end

  def file_type_to_enum(content_type)
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
