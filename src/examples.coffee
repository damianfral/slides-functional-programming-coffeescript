# ((a, b) -> c) -> a -> b -> c
curry = (f) ->
	(a) ->
		(b) ->
			f(a,b)

_add = (x,y) -> x + y

add = curry _add
add7 = add 7

console.log add7 1


# map :: (a -> b) -> [a] -> [b]
map = (f) ->
	(list) ->
		return (f x for x in list)

console.log map(add7)([2, 3, 5])




filter = (f) ->
	(list) ->
		result = []
		for x in list
			result.push x if f x
		return result

odd = (num) -> num % 2

console.log filter(odd)([1..10])




fold = (f) ->
	(init) ->
		acc = init
		(list) ->
			acc = f(acc)(x) for x in list
			return acc

sum     = fold(add)(0)
console.log sum [1..43]

mult    = (x) -> (y) -> x * y
product = fold(mult)(1)
factorial = (x) -> product [1...x]
console.log factorial 6 # => 120



comp = (f) ->
	(g) ->
		(args...) ->
			return f(g.apply @, args)


compare = (x) ->
	(y) ->
		return  1 if x > y
		return -1 if x < y
		return  0

maxBy = (fn) ->
	(x) ->
		(y) ->
			return y if fn(x)(y) is -1
			return x

head = (list) -> list[0]
tail = (list) -> list[1..]

fold1 = (fn) ->
	(list) ->
		fold(fn)(head list)(tail list)


compose = fold1(comp)

maximumBy = (fn) ->
	(list) ->
		fold1(maxBy(fn))(list)

equal = (x) -> (y) -> x is y

negate = (bool) -> ! bool

reject = (fn) ->
	(list) ->
		return filter(compose [negate, fn]) (list)

split = (fn) ->
	(list) ->
		fullfilled  = filter(fn)(list)
		rejected    = reject(fn)(list)
		return [fullfilled, rejected]

groupBy = (fn) ->
	(list) ->
		return [] unless list.length
		x        = head list
		xs       = tail list
		[ys, zs] = split(fn x)(xs)
		# Recursion
		return [[x].concat(ys)].concat(groupBy(fn)(zs))

group = groupBy equal

console.log group [6,7,8,6,7,8,9,1] # ==> [ [ 6, 6 ], [ 7, 7 ], [ 8, 8 ], [ 9 ], [ 1 ] ]


console.log "maximumBy(compare)( [1,200,6,3,999,1,44] )"
console.log maximumBy(compare)( [1,7,200,6,3,7,7,999,1,44] )

length        = (list)  -> list.length
compareLength = (list1) ->
	(list2) ->
		compare(length list1)(length list2)

mostCommon = compose [head, (maximumBy compareLength), group]

console.log mostCommon [1,7,200,6,3,7,7,999,1,44] # ==>  7
console.log mostCommon 'functional programming'   # ==> 'n'