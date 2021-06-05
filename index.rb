module Enumerable
    def my_each
        return unless block_given?
        for i in 0...self.length
            yield self[i]
        end
    end

    def my_each_with_index
        return unless block_given?
        for i in 0...self.length
            yield self[i], i
        end
    end

    def my_select
        return unless block_given?
        new_array = []
        self.my_each {|item| new_array << item if yield item }
        new_array
    end

    def my_all?
        self.my_each {|item| return false if !yield item } if block_given?
        self.my_each {|item| return false if !item} unless block_given?
        true
    end

    def my_any?
        self.my_each {|item| return true if yield item } if block_given?
        self.my_each {|item| return true if item} unless block_given?
        false
    end

    def my_none?
        self.my_each { |item| return false if yield item } if block_given?
        self.my_each { |item| return false if item } unless block_given?
        true
    end

    def my_count(arg1 = nil)
        count = 0
        if arg1 && !block_given?
            self.my_each { |item| count += 1 if item == arg1 }
        elsif !arg1 && !block_given?
            self.my_each { |item| count += 1}
        elsif block_given?
            self.my_each { |item| count += 1 if yield item }
        end
        count
    end

    def my_map(input_proc = nil)
        return unless block_given? || input_proc
        new_arr = []
        # Only execute input_proc if block and proc provided
        if input_proc
            self.my_each {|item| new_arr << input_proc.call(item)}
            return new_arr
        end
        self.my_each { |item| new_arr << (yield item) }
        new_arr
    end

    def my_inject(arg1 = nil)
        acc = arg1 || self[0]
        self.my_each_with_index do |item, index|
            # If no accumulator passed skip first
            next if arg1.nil? && index == 0
            acc = yield(acc, item)
        end
        acc
    end
end

def multiply_els(array)
    array.my_inject(1) {|acc, item| acc * item}
end

# Manual tests 
numbers = [1, 2, 3, 4, 5]

puts "my_each vs. each"
numbers.my_each  { |item| puts item }
numbers.each  { |item| puts item }

puts "\nmy_each_with_index vs. each_with_index"
numbers.my_each_with_index  { |item, index| puts "Index: #{index} Item: #{item}"}
numbers.each_with_index  { |item, index| puts "Index: #{index} Item: #{item}" }

puts "\nmy_select"
pp numbers.my_select {|item| item.even?}

puts "\nmy_all?"
puts numbers.my_all? {|item| item.even?}
puts numbers.my_all? {|item| item.class == Integer}
puts [nil, 1].my_all?

puts "\nmy_any?"
puts numbers.my_any? {|item| item.even?}
puts numbers.my_any? {|item| item == 6}
puts numbers.my_any?
puts [nil, 1].my_any?

puts "\nmy_none?"
puts numbers.my_none? {|item| item.even?}
puts numbers.my_none? {|item| item == 6}
puts [nil, false].my_none?

puts "\nmy_count"
puts numbers.my_count 
puts numbers.my_count(1)
puts numbers.my_count {|x| x.even?}

puts "\nmy_map"
pp numbers.my_map {|x| x * 2 }
pp numbers.my_map {|x| x.even? }

puts "\nmy_inject"
pp numbers.my_inject(1) {|acc, x| acc + x }
pp numbers.inject(1) {|acc, x| acc + x }
pp numbers.my_inject {|acc, x| acc + x }
pp numbers.inject {|acc, x| acc + x }
pp numbers.my_inject {|acc, x| acc * x }
pp numbers.inject {|acc, x| acc * x }

pp multiply_els([2, 4, 5])

puts "\nTestings procs with my map"
new_proc = Proc.new {|x| x.even?}
another_proc = Proc.new {|x| x * 2}

pp numbers.my_map(new_proc)
pp numbers.my_map(another_proc)