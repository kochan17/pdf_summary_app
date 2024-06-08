class OpenaiService
  def initialize(api_key)
    @client = OpenAI::Client.new(access_token: api_key)
  end

  def summarize(text)
    response = @client.completions(
      parameters: {
        model: "gpt-3.5turbo",
        prompt: "抽出したテキストを要約してください。\n\n#{text}",
        max_tokens: 500,
      }
    )
    response["choices"][0]["text"].strip
  rescue => e
    Rails.logger.error("OpenAI APIリクエストが失敗しました: #{e.message}")
    "要約に失敗しました。"
  end
end
