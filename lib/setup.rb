class Setup
  attr_reader :placement, :name

  def initialize(name, placement)
    @name = name
    @placement = placement
  end
end
