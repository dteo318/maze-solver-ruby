class Node
  attr_accessor :g_score, :h_score, :f_score, :parent_node
  attr_reader :position

  def initialize(position, parent_node = nil)
    @position = position
    @parent_node = parent_node
    @g_score = 0
    @h_score = 0
    @f_score = 0
  end

  def ==(other_node)
    self.position == other_node.position
  end
end
