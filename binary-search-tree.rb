class Node
  include Comparable
  attr_accessor :data, :left, :right

  def <=>(other)
    data <=> other.data
  end

  def initialize(data)
    @data = data
    @left = nil
    @right = nil
  end
end

class Tree
  attr_accessor :arr, :root

  def initialize(array)
    @arr = array.sort.uniq
    @root = build_tree(@arr, 0, @arr.length - 1)
  end

  def build_tree(arr, start_i, end_i)
    return if start_i > end_i

    mid = (start_i + end_i) / 2
    root = Node.new(arr[mid])

    root.left = build_tree(arr, start_i, mid - 1)
    root.right = build_tree(arr, mid + 1, end_i)

    root
  end

  def insert(value)
    @arr.push(value).sort!.uniq!
    @root = build_tree(@arr, 0, @arr.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

my_array = [2, 1, 3, 4, 5, 6, 12]

tree = Tree.new(my_array)
tree.pretty_print
tree.insert(7)
tree.pretty_print
