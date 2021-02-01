require './solver.rb'

maze_file_path = './maze1.txt'
solver = Solver.new(maze_file_path)

solver.search
