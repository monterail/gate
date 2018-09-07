Gate::Rails.configure do
  configure do |config|
    config.messages_file = Rails.root.join("fixtures", "en.yml")

    def foo?(value)
      value == "FOO"
    end
  end
end
