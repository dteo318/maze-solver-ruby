class Maze
  attr_reader :start_position, :target_position

  def initialize(maze_file_path)
    @maze = self.create_maze(maze_file_path)
    @start_position = self.find_point('S')
    @target_position = self.find_point('E')
  end

  def create_maze(maze_file_path)
    maze_str = IO.readlines(maze_file_path).map(&:chomp)
    maze_arr = maze_str.map { |row| row.split('') }
    maze_arr
  end

  def find_point(point)
    @maze.each_with_index do |row, idx|
      return idx, row.index(point) if row.index(point)
    end
  end

  def valid_position?(position)
    row = position[0]
    column = position[1]
    negative_position = position.any? { |pos| pos < 0 }
    blocked_position = @maze[row][column] == '*'
    if blocked_position || negative_position
      false
    else
      row < @maze.size && column < @maze[0].size
    end
  end

  def find_adjacent_positions(current_position)
    current_position_row = current_position[0]
    current_position_col = current_position[1]
    positions = []
    (-1..1).each do |row|
      (-1..1).each do |col|
        adjacent_pos = [current_position_row + row, current_position_col + col]
        positions << adjacent_pos unless adjacent_pos == current_position
      end
    end
    positions.select { |position| self.valid_position?(position) }
  end

  def draw_path(closed_list)
    closed_list.each do |node|
      position = node.position
      next if position == @start_position || position == @target_position
      row = position[0]
      column = position[1]
      @maze[row][column] = 'X'
    end
  end

  def print
    @maze.each { |row| puts row.join('') }
  end
end
