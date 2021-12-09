class Block
  def initialize
    @row = ''
  end

  def concat(arg)
    @row.concat(arg)
  end

  def row_data
    @row
  end

  def offense_count
    @row.match(/^# Offense count: (\d+)/)[1].to_i
  end

  def auto_collect?
    !!(@row =~ /Cop supports --auto-correct/)
  end

  def name
    @row.match(/^([A-Z].+):$/)[1]
  end

  def <=>(other)
    self.offense_count <=> other.offense_count
  end
end

class Blocks
  include Enumerable

  def initialize(path)
    @blocks = [Block.new]
    File.open(path, 'r') do |f|
      f.each_line do |row|
        add(row)
        next_block if row == "\n"
      end
    end
    @blocks.shift
  end

  def add(row)
    @blocks.last.concat(row)
  end

  def next_block
    @blocks.push(Block.new)
  end

  def each
    @blocks.each do |block|
      yield block
    end
  end

  def auto_correctives
    self.filter{|v| v.auto_collect?}
  end
end

path = ARGV[0]
blocks = Blocks.new(path)

puts "TOP10"
blocks.auto_correctives.sort.reverse[0..9].each do |block|
  puts "#{block.name}:#{block.offense_count}:#{block.auto_collect?}"
end
