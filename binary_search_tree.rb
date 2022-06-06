require 'pry-byebug'

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

  def insert(root = @root, value)
    root = Node.new(value) if root.nil?

    if value < root.data
      root.left = insert(root.left, value)
    elsif value > root.data
      root.right = insert(root.right, value)
    end
    root
  end

  def min_value_node(node)
    current = node
    current = current.left until current.left.nil?
    current.data
  end

  def delete_node(root, value)
    root if root.nil?

    if value < root.data
      root.left = delete_node(root.left, value)
    elsif value > root.data
      root.right = delete_node(root.right, value)
    else
      # node with only one child or no child
      return root.right if root.left.nil?
      return root.left if root.right.nil?

      # node with two children: Get the
      # inorder successor (smallest
      # in the right subtree)
      root.data = min_value_node(root.right)

      # Delete the inorder successor
      root.right = delete_node(root.right, root.data)
    end
    root
  end

  def find(root, value)
    return 'Value not in tree' if root.nil?
    return root if root.data == value

    if value < root.data
      root.left = find(root.left, value)
    elsif value > root.data
      root.right = find(root.right, value)
    end
  end

  def level_order(root = self.root)
    return if root.nil?

    queue = [root]
    result = []
    until queue.empty?
      current = queue.shift
      block_given? ? yield(current) : result << current.data
      queue << current.left unless current.left.nil?
      queue << current.right unless current.right.nil?
    end
    result unless block_given?
  end

  def inorder(root = self.root, result = [], &block)
    return if root.nil?

    inorder(root.left, result, &block)
    block_given? ? yield(root.data) : result.push(root.data)
    inorder(root.right, result, &block)

    result unless block_given?
  end

  def preorder(root = self.root, result = [], &block)
    return if root.nil?

    block_given? ? yield(root.data) : result.push(root.data)
    preorder(root.left, result, &block)
    preorder(root.right, result, &block)

    result unless block_given?
  end

  def postorder(root = self.root, result = [], &block)
    return if root.nil?

    postorder(root.left, result, &block)
    postorder(root.right, result, &block)
    block_given? ? yield(root.data) : result.push(root.data)

    result unless block_given?
  end

  def height(node)
    return -1 if node.nil?

    left = height(node.left)
    right = height(node.right)

    left > right ? left + 1 : right + 1
  end

  def depth(root, node, counter = 0)
    return counter if root.data == node

    counter += 1
    if node > root.data
      depth(root.right, node, counter)
    else
      depth(root.left, node, counter)
    end
  end

  def balanced?(root = self.root)
    return if root.nil?

    l = height(root.left)
    r = height(root.right)

    # if statment to prevent negative numbers
    l > r ? l - r.abs <= 1 : r - l.abs <= 1
  end

  def rebalance
    self.arr = inorder(root)
    self.root = build_tree(arr, 0, arr.length - 1)
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

# Driver script

# Create a binary search tree from an array of random numbers (Array.new(15) { rand(1..100) })
tree = Tree.new(Array.new(15) { rand(1..100) })
# Confirm that the tree is balanced by calling #balanced?
p tree.balanced?
# Print out all elements in level, pre, post, and in order
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
# Unbalance the tree by adding several numbers > 100
tree.insert(110)
tree.insert(120)
tree.insert(130)
tree.insert(140)
tree.insert(150)
# Confirm that the tree is unbalanced by calling #balanced?
p tree.balanced?
# Balance the tree by calling #rebalance
tree.rebalance
# Confirm that the tree is balanced by calling #balanced?
p tree.balanced?
# Print out all elements in level, pre, post, and in order
p tree.level_order
p tree.preorder
p tree.postorder
p tree.inorder
