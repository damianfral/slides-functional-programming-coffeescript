index.html: README.rst
	pandoc -t revealjs -T "Intro to Functional Programming with CoffeeScript" -s -V  theme=beige README.rst -o index.html