index.html: README.rst
	pandoc -t revealjs -s -V theme=beige README.rst -o index.html