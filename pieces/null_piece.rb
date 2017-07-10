require 'singleton'

class NullPiece
  include Singleton
  attr_reader :color

  def initialize
    @color = nil
  end

  def symbol
    "   "
  end
end
