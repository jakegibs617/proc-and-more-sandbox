# a_proc[9, 1, 2, 3]        #=> [9, 18, 27]
# a_proc.(9, 1, 2, 3)       #=> [9, 18, 27]

a_proc = Proc.new { |scalar, *values| values.collect { |value| value*scalar } }

# p a_proc.call(9, 2)   #=> [9, 18, 27]


ab_proc = Proc.new {|*a| a.map { |x| x + "!" }    }
 ab_proc[ "a", "b", "c", "d" ] #=> ["a!", "b!", "c!", "d!"]

ab_proc = Proc.new {|*a| a.collect { |x| x + "!" }    }
 ab_proc[ "a", "b", "c", "d" ] #=> ["a!", "b!", "c!", "d!"]

(1..4).map { |i| i*i }      #=> [1, 4, 9, 16]
(1..4).collect { |i| i*i }      #=> [1, 4, 9, 16]
(1..4).map { "cat"  }   #=> ["cat", "cat", "cat", "cat"]
(1..4).collect { "cat"  }   #=> ["cat", "cat", "cat", "cat"]

[1, 2, 3, 4].flat_map { |e| [e, -e] } #=> [1, -1, 2, -2, 3, -3, 4, -4]

[[1, 2], [3, 4]].flat_map { |e| e + [100] } #=> [1, 2, 100, 3, 4, 100]



# [[1, 2], [3, 4]].flat_map { |e| e + [100] } #=> [1, 2, 100, 3, 4, 100]

[[1, 2, 3, 4],[3]].flat_map { |e| [e] + (e + [100]) } #=> [[1, 2, 3, 4], 1, 2, 3, 4, 100, [3], 3, 100]

[[1, 2, 3, 4],[3]].flat_map { |e| e + (e + [100]) } #=> [1, 2, 3, 4, 1, 2, 3, 4, 100, 3, 3, 100]
