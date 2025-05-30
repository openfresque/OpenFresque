module Decorable
  def decorate
    "#{self.class}Decorator".constantize.new(self)
  end
end
