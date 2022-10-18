class Spawner

  attr_reader :startPos, :up_dir, :right_dir

  def initialize(startPos, up_dir, right_dir)
    @startPos = startPos
    @up_dir = up_dir
    @right_dir = right_dir
  end
end
