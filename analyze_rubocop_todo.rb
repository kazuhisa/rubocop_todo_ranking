path = ARGV[0]
blocks = ['']
File.open(path, 'r') do |f|
  f.each_line do |row|
    blocks.last.concat(row)
    if row == "\n"
      blocks.push('')
    end
  end
end

