class Move
  attr_accessor :notation, :movement, :removing, :spawn

  def initialize(notation,movement=nil ,removing = nil,spawn = nil)
    @notation = notation
    @movement = movement
    @removing = removing
    @spawn    = spawn
  end

end