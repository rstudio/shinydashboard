HTML_FILES = $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))

all: html

html: $(HTML_FILES)

%.html: %.Rmd
	R --slave -e "rmarkdown::render('$<')"

.PHONY: clean
clean:
	$(RM) $(HTML_FILES)
