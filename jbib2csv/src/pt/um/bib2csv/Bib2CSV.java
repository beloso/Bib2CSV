package pt.um.bib2csv;

import java.io.FileReader;
import java.io.IOException;
import java.io.Reader;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

import bibtex.dom.BibtexAbstractEntry;
import bibtex.dom.BibtexAbstractValue;
import bibtex.dom.BibtexEntry;
import bibtex.dom.BibtexFile;
import bibtex.parser.BibtexParser;
import bibtex.parser.ParseException;

public abstract class Bib2CSV {

	private static BibtexFile bibfile;
	private static final BibtexParser parser = new BibtexParser(true);
	private static List<BibtexEntry> entries;
	private static Set<String> keys = new TreeSet<String>();
	private static Set<String> keywords = new TreeSet<String>();
	private static Set<String> fields = new TreeSet<String>();
	private static Map<String, ArrayList<String>> csvMap = new TreeMap<String, ArrayList<String>>();

	public static void parseFile(Reader inputFile) throws ParseException,
			IOException {
		bibfile = new BibtexFile();
		parser.parse(bibfile, inputFile);
	}

	public static List<String> getKeys() {
		entries = bibfile.getEntries();
		List<String> result = new ArrayList<String>();

		for (BibtexEntry entry : entries) {
			result.add(entry.getEntryKey());
		}

		keys.addAll(result);
		return result;
	}

	public static Set<String> getFields() {
		Set<String> result = new TreeSet<String>();

		for (BibtexEntry entry : entries) {
			result.addAll(entry.getFields().keySet());
		}

		fields.addAll(result);
		return result;
	}

	public static Set<String> getFieldValuesByEntry(BibtexEntry entry,
			String field, String sep) {
		Set<String> result = new TreeSet<String>();

		List<BibtexAbstractValue> values = entry.getFieldValuesAsList(field);

		for (BibtexAbstractValue value : values) {

			String fieldValue = value.toString();
			fieldValue = fieldValue.substring(1, fieldValue.length() - 1);

			if (fieldValue.indexOf(sep) >= 0) {
				String[] fieldValues = fieldValue.split(sep);

				for (String singleField : fieldValues) {
					result.add(singleField.trim());
				}
			} else {
				result.add(fieldValue);
			}
		}

		return result;
	}

	public static Set<String> getFieldValues(String field, String sep) {
		Set<String> result = new TreeSet<String>();

		for (BibtexEntry entry : entries) {
			getFieldValuesByEntry(entry, field, sep);
		}

		keywords.addAll(result);
		return result;
	}

	public static void prepreCSV() {
		ArrayList<String> connections = null;
		Set<String> entryKeywords;

		for (BibtexEntry entry : entries) {
			for (String keyword : keywords) {
				connections = new ArrayList<String>();
				entryKeywords = getFieldValuesByEntry(entry, "keywords", ",");

				if (entryKeywords.contains(keyword)) {
					connections.add("1");
				}else{
					connections.add("0");
				}				
			}
			
			csvMap.put(entry.getEntryKey().toString(), connections);
		}
	}

	public static Set<String> getAttributes() {
		Set<String> gbobalAttributes = new TreeSet<String>();
		entries = bibfile.getEntries();
		for (BibtexEntry entry : entries) {
			Map entryFields = entry.getFields();
			Iterator entryField = entryFields.entrySet().iterator();
			while (entryField.hasNext()) {
				Map.Entry field = (Map.Entry) entryField.next();
				gbobalAttributes.add(field.getKey().toString());
			}
		}
		return gbobalAttributes;
	}

}
