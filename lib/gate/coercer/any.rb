require 'coercible'

class Gate::Coercer::Any < Coercible::Coercer::Object

  def to_any(value)
    value
  end
end
