
Intro to Functional Programming with CoffeeScript
+++++++++++++++++++++++++++++++++++++++++++++++++

`Damián Franco Álvarez <http://damianfral.github.io/blog/>`_

Programming Paradigms
+++++++++++++++++++++

* What is a paradigm? Style, concepts, models, patterns...

* Imperative programming
	- Structured programming (*C*)
		+ Problem: goto -> Solution: subroutines and loops

	- Object oriented programming (*Java*)
		+ Problem: global state -> Solution: encapsulation (classes, objects)

* Declarative
	- Functional programming (*Haskell*)
		+ Problem: state -> Solution: **functions** (morphism)


Some notes
++++++++++

- Open your mind

- Forget imperative programming

- The *click moment*


Pure functions
++++++++++++++

- The output of a pure function **only depends** on its inputs

- Pure funcions does not have side effects

- Easier to design

- Easier to read/understand

- **Easy to test**

- FP emphasize on writing pure, generic functions which could work in any environment, and choosing actual program behaviour at the top of the call hierarchy


Currying
++++++++

- Transforming a function that receives multiple arguments into a function that receives only one argument::

	# ((a, b) -> c) -> a -> b -> c
	curry = (f) ->
		(a) ->
			(b) ->
				f(a,b)

	_add = (x,y) -> x + y
	add  = curry _add
	add(2)(3) # ==> 5
	add7 = add 7
	add7 10  # ==> 17


Higher order functions
++++++++++++++++++++++

- Functions that operate on other functions
	+ Takes one or more functions as input
	+ Outputs a function

- Well known examples: map, filter, reduce...

- HOFs facilitates composability and code reusability


Higher order functions
++++++++++++++++++++++

- Writting pure higher order curried functions in CoffeeScript is easy and powefull::

	map = (f) ->
		(list) ->
			return (f x for x in list)

	map(add7)([1, 2, 3]) # ==> [ 9, 10, 12 ]


Higher order functions
++++++++++++++++++++++

::

	filter = (f) ->
		(list) ->
			result = []
			for x in list
				result.push x if f x
			return result

	odd = (num) -> num % 2

	filter(odd)([1..10]) # ==> [ 1, 3, 5, 7, 9 ]


Higher order functions
++++++++++++++++++++++

::

	fold = (f) ->
		(init) ->
			acc = init
			(list) ->
				acc = f(acc)(x) for x in list
				return acc

	sum = fold(add)(0)

	sum [1..43] # ==> 946

	mult    = (x) -> (y) -> x * y
	product = fold(mult)(1)

	factorial = (x) -> product [1...x]
	factorial 6 # => 120


Function composition
++++++++++++++++++++

::

	f :  B --> C
	g :  A --> B

	f . g :  A --> C


::

	negate = (bool) -> ! bool

	odd = (num) -> num % 2

	even = compose(negate)(odd)


Function composition
++++++++++++++++++++

::

	comp = (f) ->
		(g) ->
			(args...) ->
				return f(g.apply @, args)

	head = (list) -> list[0]
	tail = (list) -> list[1..]

	fold1 = (fn) ->
		(list) ->
			fold(fn)(head list)(tail list)

	compose = fold1(comp)

	# Naive example
	bestStudent = compose [head, (sortBy meanQualification), (filter hasPassedAllExames)]


Example
+++++++

- Get the most common element in a list

::

	mostCommon [1,7,200,6,3,7,7,999,1,44] # ==> 7
	mostCommon 'functional programming!'  # ==> 'n'


Example
+++++++

::

	compare = (x) ->
		(y) ->
			return  1 if x > y
			return -1 if x < y
			return  0

	equal  = (x) -> (y) -> x is y

	negate = (bool) -> ! bool

	maxBy = (fn) ->
		(x) ->
			(y) ->
				return y if fn(x)(y) is -1
				return x

	maximumBy = (fn) ->
			fold1(maxBy(fn))

Example
+++++++

::

	reject = (fn) ->
		return filter(compose [negate, fn])

	split = (fn) ->
		(list) ->
			fullfilled  = filter(fn)(list)
			rejected    = reject(fn)(list)
			return [fullfilled, rejected]

Example
+++++++

::

	groupBy = (fn) ->
		(list) ->
			return [] unless list.length
			x        = head list
			xs       = tail list
			[ys, zs] = split(fn x)(xs)
			# Recursion
			return [[x].concat(ys)].concat(groupBy(fn)(zs))

	group = groupBy equal

	group [6,7,8,6,7,8,9,1] # [ [ 6, 6 ], [ 7, 7 ], [ 8, 8 ], [ 9 ], [ 1 ] ]


Example
+++++++

::

	length        = (list)  -> list.length
	compareLength = (list1) ->
		(list2) ->
			compare(length list1)(length list2)

	mostCommon = compose [head, (maximumBy compareLength), group]

	mostCommon [1,7,200,6,3,7,7,999,1,44] # ==>  7
	mostCommon 'functional programming'   # ==> 'n'


Why functional programming?
+++++++++++++++++++++++++++

- Higher abstraction level
- Reusability
- Concision
- Readability


Deeping into FP
+++++++++++++++

- **Algebraic data structures**

- Cathegory theory

- Typeclasses

- Laziness

- Recursion

.. raw:: html

	<img src='https://ga-beacon.appspot.com/UA-42041306-2/your-repo/page-name' style='display: none'