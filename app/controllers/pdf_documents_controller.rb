class PdfDocumentsController < ApplicationController
  def new
    @pdf_document = PdfDocument.new
  end

  def create
    uploaded_file = params[:pdf_document][:file]
    original_text = extract_text_from_pdf(uploaded_file)

    api_key = ENV["OPENAI_API_KEY"]
    openai_service = OpenaiService.new(api_key)
    summary_text = openai_service.summarize(original_text)

    @pdf_document = PdfDocument.new(original_text: original_text, summary_text: summary_text)

    if @pdf_document.save
      redirect_to @pdf_document
    else
      render :new
    end
  end

  def show
    @pdf_document = PdfDocument.find(params[:id])
  end

  private

  def extract_text_from_pdf(uploaded_file)
    reader = PDF::Reader.new(uploaded_file.path)
    reader.pages.map(&:text).join(" ")
  end
end
