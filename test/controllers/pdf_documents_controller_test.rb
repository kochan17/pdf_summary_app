require "test_helper"

class PdfDocumentsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get pdf_documents_new_url
    assert_response :success
  end

  test "should get create" do
    get pdf_documents_create_url
    assert_response :success
  end

  test "should get show" do
    get pdf_documents_show_url
    assert_response :success
  end
end
