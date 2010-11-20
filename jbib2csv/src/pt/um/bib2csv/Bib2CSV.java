package pt.um.bib2csv;

import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;

import bibtex.dom.BibtexAbstractValue;
import bibtex.dom.BibtexEntry;
import bibtex.dom.BibtexFile;
import bibtex.parser.BibtexParser;
import bibtex.parser.ParseException;

public abstract class Bib2CSV {

	private static BibtexFile bibfile;
	private static final BibtexParser parser = new BibtexParser(true);
	private static List<BibtexEntry> entries;
	private static Set<String> keywords;

	public static void parseFile(Reader inputFile) throws ParseException,
			IOException {
		parser.parse(bibfile, inputFile);
	}

	public static List<String> getKeys() {
		entries = bibfile.getEntries();
		List<String> result = new ArrayList<String>();

		for (BibtexEntry entry : entries) {
			result.add(entry.getEntryKey());
		}

		return result;
	}

	public static Set<String> getFieldValues(String field) {
		Set<String> result = new TreeSet<String>();

		for (BibtexEntry entry : entries) {
			List<BibtexAbstractValue> values = entry.getFieldValuesAsList(field);

			for (BibtexAbstractValue value : values) {
				result.add(value.toString());
			}
		}

		keywords.addAll(result);
		return result;
	}
}
