HTML_FILES = $(patsubst %.Rmd, %.html ,$(wildcard *.Rmd))
HTML_INCLUDES = include/after_body.html include/before_body.html

all: html

html: $(HTML_FILES)

%.html: %.Rmd  $(HTML_INCLUDES)
	R --slave -e "rmarkdown::render('$<')"

.PHONY: clean
clean:
	$(RM) $(HTML_FILES)
	$(RM) -rf libs/
