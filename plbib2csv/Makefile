SOURCE = Bib2CSV.pl
OUTPUT = bib2csv
ARCHIVE = bib2csv.tar.gz
INSTALL_DIR = /usr/local/bin/

all: $(OUTPUT)

archive: $(ARCHIVE)

install: $(OUTPUT)
	sudo cp $(OUTPUT) $(INSTALL_DIR)
	
uninstall: $(INSTALL_DIR)$(OUTPUT)
	sudo rm $(INSTALL_DIR)$(OUTPUT)

$(OUTPUT): $(SOURCE)
	pp -B -o $(OUTPUT) -M Text::BibTeX -M PAR $(SOURCE)
	
$(ARCHIVE): $(OUTPUT) $(SOURCE)
	tar -cvzf $(ARCHIVE) $(SOURCE) $(OUTPUT)
	
clean:
	rm -f $(OUTPUT)
	rm -f $(ARCHIVE)