RSpec::Matchers.define :have_content_type do |expected|
    match do |actual|
        begin
            actual.content_type == content_type(expected)
        rescue ArgumentError
            false
        end
    end

    # 失敗メッセージ
    failure_message do |actual|
        "Expected \"#{content_type(actual.content_type)} " +
        "(#{actual.content_type})\" to be Content Type " +
        "\"#{content_type(expected)}\" (#{expected})"
    end

    # 否定の失敗メッセージ
    failure_message_when_negated do |actual|
        "Expected \"#{content_type(actual.content_type)} " +
        "(#{actual.content_type})\" to not be Content Type " +
        "\"#{content_type(expected)}\" (#{expected})"
    end

    def content_type(type)
        types = {
            html: "text/html",
            json: "application/json",
        }
        types[type.to_sym] || "unknown content type"
    end
end
# have_content_typeでもbe_content_typeでも使えるように設定
RSpec::Matchers.alias_matcher :be_content_type , :have_content_type

# カスタムマッチャを使うだけならこれで十分、だけどエラー文が読みにくい
# match do |actual|
#     content_types = {
#         html: "text/html",
#         json: "application/json",
#     }
#     actual.content_type == content_types[expected.to_sym]
# end