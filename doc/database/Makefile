.PHONY: all

all: chens-notation.png chens-notation-twopi.png

chens-notation.png: chens-notation.gvdot
	dot -Tpng $^ -o$@

chens-notation-twopi.png: chens-notation.gvdot
	twopi -Tpng $^ -o$@
