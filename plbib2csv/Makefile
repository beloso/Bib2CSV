SOURCE = Bib2CSV.pl
OUTPUT = bib2csv
MANPAGE = bib2csv.1
ARCHIVE = bib2csv.tar.gz
INSTALL_DIR = /usr/local/bin/
MANPAGE_DIR = /usr/local/share/man/man1/

all: $(OUTPUT)

archive: $(ARCHIVE)

install: $(OUTPUT) $(MANPAGE) $(INSTALL_DIR) $(MANPAGE_DIR)
	cp $(OUTPUT) $(INSTALL_DIR)
	cp $(MANPAGE) $(MANPAGE_DIR)
	
uninstall: $(INSTALL_DIR) $(MANPAGE_DIR)
	rm $(INSTALL_DIR)/$(OUTPUT)
	rm $(MANPAGE_DIR)/$(MANPAGE)

$(OUTPUT): $(SOURCE)
	pp -B -o $(OUTPUT) -M Text::BibTeX -M PAR $(SOURCE)
	
$(ARCHIVE): $(OUTPUT) $(SOURCE)
	tar -cvzf $(ARCHIVE) $(SOURCE) $(OUTPUT) Makefile

$(MANPAGE): $(SOURCE)
	pod2man $(SOURCE) > $(MANPAGE)
	
clean:
	rm -f $(OUTPUT) $(MANPAGE) $(ARCHIVE)