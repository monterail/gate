class ValidWithClassValidationContract < Dry::Validation::Contract
  params do
    required(:foo).filled
    optional(:bar).maybe(:string)
  end
end
