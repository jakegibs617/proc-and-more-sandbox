# proc, how it works
a_proc = Proc.new { |scalar, *values| values.collect { |value| value*scalar } }

# a_proc[9, 1, 2, 3]        #=> [9, 18, 27]
# a_proc.(9, 1, 2, 3)       #=> [9, 18, 27]

# p a_proc.call(9, 2)   #=> [9, 18, 27]

ab_proc = Proc.new {|*a| a.map { |x| x + "!" }    }
 ab_proc[ "a", "b", "c", "d" ] #=> ["a!", "b!", "c!", "d!"]

ab_proc = Proc.new {|*a| a.collect { |x| x + "!" }    }
 ab_proc[ "a", "b", "c", "d" ] #=> ["a!", "b!", "c!", "d!"]

# proc.new
a_proc = Proc.new {|a,b| (a > b) ? "a" : "b - #{b}" }
a_proc.call(1, 2) #=> "b - 2"

# lambda
a_proc = lambda {|a,b| (a > b) ? "a" : "b - #{b}" }
a_proc.call(1, 2) #=> "b - 2"

# when to use proc.new vs lambda ?

# If you want a block object that behaves like the one that Ruby generates when you pass a 
# couple of braces into a method, use Proc.new. 

# If you want something that will behave more like 
# a regular object with a single method, use lambda


# whats the difference between map and collect?
(1..4).map { |i| i*i }      #=> [1, 4, 9, 16]
(1..4).collect { |i| i*i }      #=> [1, 4, 9, 16]
(1..4).map { "cat"  }   #=> ["cat", "cat", "cat", "cat"]
(1..4).collect { "cat"  }   #=> ["cat", "cat", "cat", "cat"]

[1, 2, 3, 4].flat_map { |e| [e, -e] } #=> [1, -1, 2, -2, 3, -3, 4, -4]

[[1, 2], [3, 4]].flat_map { |e| e + [100] } #=> [1, 2, 100, 3, 4, 100]

# [[1, 2], [3, 4]].flat_map { |e| e + [100] } #=> [1, 2, 100, 3, 4, 100]

[[1, 2, 3, 4],[3]].flat_map { |e| [e] + (e + [100]) } #=> [[1, 2, 3, 4], 1, 2, 3, 4, 100, [3], 3, 100]

[[1, 2, 3, 4],[3]].flat_map { |e| e + (e + [100]) } #=> [1, 2, 3, 4, 1, 2, 3, 4, 100, 3, 3, 100]

# http://stackoverflow.com/questions/5254732/difference-between-map-and-collect-in-ruby

# There's no difference, in fact map is implemented in C as rb_ary_collect and enum_collect 
# (eg. there is a difference between map on an array and on any other enum, but no difference 
# between map and collect).

# understanding cycle
def my_method(input)
	a = ["a", "b", "c"]
	i = input.length

	a.cycle(i) { |x| puts x  }  # print, a, b, c, a, b, c.
end
# my_method("hi")


# understanding each_cons 
# each_cons is each consecutive
array = ["a", "b", "c", "d", "e", "g"]
# array.each_cons(3) { |a| a.include?("a") ? (p a) : (puts "#{a} does not include 'a'") }

# outputs below
# ["a", "b", "c"]
# ["b", "c", "d"] does not include 'a'
# ["c", "d", "e"] does not include 'a'
# ["d", "e", "g"] does not include 'a'

# array.each_cons(3) { |a| a.include?("b") ? (p a) : (puts "#{a} does not include 'b'") }
# ["a", "b", "c"]
# ["b", "c", "d"]
# ["c", "d", "e"] does not include 'b'
# ["d", "e", "g"] does not include 'b'

# understanding method
m = 12.method("+")
m.call(3)    #=> 15
m.call(20)   #=> 32


# understanding yield with procs

# not using yield
def print_list(array, first = 1)
  counter = first
  array.each do |item|
    puts "#{counter}. #{item}"
    # puts "#{yield counter} #{item}"
    counter = counter.next
  end
end
# print_list(["Ruby", "Python", "C"]) 
# 1. Ruby
# 2. Python
# 3. C
# print_list(["a","b","c"], 99)
# 99. a
# 100. b
# 101. c

# using yield
def print_list(array, first = 1)
  counter = first
  array.each do |item|
    # puts "#{counter}. #{item}"
    puts "#{yield counter} #{item}"
    counter = counter.next
  end
end
# print_list( [1,2,3], 23 ) { |n| "<#{n}>"}
# <23> 1
# <24> 2
# <25> 3

def palindrome?(input)
  # if the input is a string, and letters in the alphabet... no numbers
  if input =~ /[A-Za-z]/
    # the input should be more than 1 character
    if input.length >= 2

      # break into characters
      array = input.chars
      
      # remove spaces
      # if array.include?(" ")
      #   array.delete(" ")
      # end

      # refactored to lambda // remove spaces
      # lam = lambda { array.delete(" ") if array.include?(" ") }
      # lam.call

      # refactored to one line terniary // remove spaces
      array.delete(" ") if array.include?(" ") 

      # save the first and last
      first = array[0]
      last = array[-1]

      # compare the first and last
      if first == last 
 
        array.delete(first)
        array.delete(last)

        # this will be recursive, so if we get down to the last char, then it was successful
        if array.length == 0 || array.length == 1
          return true
        else
        #   # at this point we need to re-run the function recursively
          palindrome?(array.join)
        end

      else
        # else, the book ending chars are not equal thus not a palindrome
        return false
      end
    else
      # else the input was only one character, does not count
      return false
    end
  else
    # else the input was not a string
    return false
  end
end

p "cat: #{palindrome?("cat")}"
p "nocaton: #{palindrome?("nocaton")}"
p "noon: #{palindrome?("noon")}"
p "race car: #{palindrome?("race car")}"
p "' ': #{palindrome?(" ")}"
p "asfh ded hfsa : #{palindrome?("asfh ded hfsa ")}"
p "121 : #{palindrome?("121")}"
# "cat: false"
# "nocaton: false"
# "noon: true"
# "race car: true"
# "' ': false"
# "asfh ded hfsa : true"
# "121 : false"