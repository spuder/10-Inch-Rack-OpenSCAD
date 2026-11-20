OPENSCAD    ?= openscad
SCAD         = 10InchRackGenerator.scad
RENDERS      = tests/renders
IMGSIZE     ?= 2560,1440
COLORSCHEME  = Tomorrow Night

# Optional: make test TEST=missing_air_holes
ifdef TEST
BATS_FILTER = --filter "$(TEST)"
endif

.PHONY: all test test-stl test-all preview clean

all: test

# Fast preview tests — run all, or filter with TEST=<name>.
# When TEST is set, RENDER_STL=1 is passed so render_views also produces an STL.
ifdef TEST
test:
	IMGSIZE=$(IMGSIZE) RENDER_STL=1 bats $(BATS_FILTER) tests/rack.bats
else
test:
	IMGSIZE=$(IMGSIZE) bats tests/rack.bats
endif

# Full CGAL geometry validation — slow (~35s per case)
test-stl:
	IMGSIZE=$(IMGSIZE) bats $(BATS_FILTER) tests/rack_stl.bats

# Everything
test-all:
	IMGSIZE=$(IMGSIZE) bats $(BATS_FILTER) tests/rack.bats tests/rack_stl.bats

# Quick default-param preview PNG
preview: $(RENDERS)/preview.png

$(RENDERS)/preview.png: $(SCAD) | $(RENDERS)
	$(OPENSCAD) -o $@ \
		--imgsize=$(IMGSIZE) \
		--camera=0,0,0,55,0,25,1 \
		--autocenter --viewall \
		--colorscheme="$(COLORSCHEME)" \
		$<

$(RENDERS):
	mkdir -p $(RENDERS)

clean:
	rm -rf $(RENDERS)
	rm -f preview.png
