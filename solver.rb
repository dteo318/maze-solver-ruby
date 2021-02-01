require './node.rb'
require './maze.rb'
require 'byebug'

class Solver
  D = 1
  D2 = 1

  def initialize(maze_file_path)
    @maze = Maze.new(maze_file_path)
    @current_node = Node.new(@maze.start_position)
    @open_list = [@current_node]
    @closed_list = []
  end

  def calculate_g_score(node)
    diagonal_distance = 2
    horizontal_vertical_distance = 1

    parent = node.parent_node
    parent_position = parent.position
    parent_g_score = parent.g_score

    node_position = node.position

    vertical_units = (parent_position[0] - node_position[0]).abs
    horizontal_units = (parent_position[1] - node_position[1]).abs

    D * (horizontal_units + vertical_units) +
      (D2 - 2 * D) * [horizontal_units, vertical_units].min
  end

  def calculate_h_score(node)
    node_position = node.position
    target_position = @maze.target_position

    vertical_units = (target_position[0] - node_position[0]).abs
    horizontal_units = (target_position[1] - node_position[1]).abs

    D * (horizontal_units + vertical_units) +
      (D2 - 2 * D) * [horizontal_units, vertical_units].min
  end

  def find_next_node
    open_list_f_score = @open_list.map { |node| node.f_score }
    min_f_score = open_list_f_score.min
    nodes_with_min_f_score =
      @open_list.select { |node| node.f_score = min_f_score }
    @current_node = nodes_with_min_f_score.last
    @open_list.delete(@current_node)
    @closed_list << @current_node
  end

  def search
    target_node = Node.new(@maze.target_position)
    until @open_list.empty?
      self.find_next_node
      break if @current_node == target_node
      current_position = @current_node.position
      adjacent_positions = @maze.find_adjacent_positions(current_position)

      adjacent_positions.each do |adjacent_position|
        adjacent_node = Node.new(adjacent_position, @current_node)

        g_score = self.calculate_g_score(adjacent_node)
        h_score = self.calculate_h_score(adjacent_node)

        adjacent_node.g_score = g_score
        adjacent_node.h_score = h_score
        adjacent_node.f_score = g_score + h_score

        if @closed_list.any? { |node| node == adjacent_node }
          next
        elsif @open_list.any? { |node| node == adjacent_node }
          duplicate_node_index =
            @open_list.index do |open_list_node|
              open_list_node == adjacent_node
            end
          duplicate_node_g_score = @open_list[duplicate_node_index].g_score

          if duplicate_node_g_score > g_score
            @open_list[duplicate_node_index].parent_node = @current_node
            @open_list[duplicate_node_index].g_score = g_score
            @open_list[duplicate_node_index].f_score = f_score
          end
        else
          @open_list << adjacent_node
        end
      end
    end

    @maze.draw_path(@closed_list)
    @maze.print
  end
end
