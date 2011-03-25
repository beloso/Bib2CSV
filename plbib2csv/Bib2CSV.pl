#!/usr/bin/perl -s
use strict;
use warnings;
use Text::BibTeX;

our ($o,$y,$a);

# Prepare output file
my $csvfile="output.csv";
if($o){
	$csvfile= shift or die("Missing output file.\n");
}

# Read input BibTeX file
my $file = shift or die("Missing input file.\n");

# Load file into Text::BibTeX structure
my $bibfile = new Text::BibTeX::File "$file";

# Keyword array
my @keywords;

# CSV Map
my %map;

# Read all entries from file
while (my $entry = new Text::BibTeX::Entry $bibfile)
{
	# Safe guarding
  warn "Syntax error in input file." unless $entry->parse_ok;

	# Read the citation key
	my $key = $entry->key;
	
	# Read the file keywords and store them in an array
	my $wordsWithRep = $entry->get('keywords');
	
	# convert all elements to lowercase
	my $wordsWithRepLc = lc($wordsWithRep) if defined ($wordsWithRep);
	my @words;
	@words = split /\s*,\s*/, $wordsWithRepLc if defined ($wordsWithRepLc);
		
	if($y){
		my $yearEntry = $entry->get('year');
		push @words,$yearEntry;
	}
	if($a){
		my @authorEntry = $entry->split ('author');
		push @words,@authorEntry;
	}
	
	# Store keywords information in HashMap
	$map{$key} = [@words];
	
	# Join entry keywords with global structure keywords
	push @keywords, @words;
}

# Create a new keywords with no repeated keywords
my @keywordsNoRep = keys %{{map {$_=>0} @keywords}};
@keywordsNoRep = sort @keywordsNoRep;

# Write the header line
my $out = ",\"";
$out.=join "\",\"",@keywordsNoRep;
$out.="\",\n";

# Iterate over the HashMap and write one line per entry
foreach my $key ( keys %map) {
	
	# Start an empty line
	my $line="";
	
	# Add the entry key
	$line.="\"$key\",";
	
	# For each global keyword
	foreach my $global_keyword (@keywordsNoRep) {
		
		# Start with no connection
		my $hasConnection = 0;
		
		# For each entry keyword
		foreach my $entry_keyword ( @{$map{$key}} ){
			
			# Assert connection and change connection status
			if ( $entry_keyword eq $global_keyword ){
				$hasConnection = 1;
			}
		}
		
		# Add connection information to the line
		$line.="$hasConnection,";
	}
	
	$line.="\n";
	$out.=$line;
}

# Write out the csv file
open (FOUT,">$csvfile");
print FOUT $out;
close FOUT;

__END__

=head1 NAME

Bib2CSV - create CSV file for concept analysys from BibTeX keyword and year attributes.

=head1 SYNOPSIS

 Bib2CSV [-y] [-o FILEOUT] bibfile.bib

=head1 DESCRIPTION

=head2 OPTIONS
	
	-o FILE	outputs to the specified file
	
	-y 	also uses year information for the attributes

=head1 AUTHOR

	Marcio Coelho and Tiago Veloso.

perl(1).

=cut