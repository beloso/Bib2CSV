#!/usr/bin/perl -s

use Text::BibTeX;

our ($o);

# Prepare output file
my $csvfile;
if($o){
	$csvfile= shift or die("Missing output file.\n");
}else{
	$csvfile = "output.csv";	
}
# Read input BibTeX file
my $bibfile = shift or die("Missing input file.\n");

# Load file into Text::BibTeX structure
my $bibfile = new Text::BibTeX::File "$bibfile";

# Keyword array
my @keywords;

# CSV Map
my %map;

# Read all entries from file
while ($entry = new Text::BibTeX::Entry $bibfile)
{
	# Safe guarding
  warn "Syntax error in input file." unless $entry->parse_ok;

	# Read the citation key
	$key = $entry->key;
	
	# Read the file keywords and store them in an array
	$wordsWithRep = $entry->get('keywords');
	@words = split /\s*,\s*/, $wordsWithRep;
	
	# Store keywords information in HashMap
	$map{$key} = [@words];
	
	# Join entry keywords with global structure keywords
	push @keywords, @words;
}

# Create a new keywords with no repeated keywords
my @keywordsNoRep = keys %{{map {$_=>0} @keywords}};

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
	foreach $global_keyword (@keywordsNoRep) {
		
		# Start with no connection
		my $hasConnection = 0;
		
		# For each entry keyword
		foreach $entry_keyword ( @{$map{$key}} ){
			
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

Bib2CSV - 

=head1 SYNOPSIS

 Bib2CSV bibfile.bib  -
 Bib2CSV -o  name.csv bibfile.bib      -


=head1 DESCRIPTION

=head2 OPTIONS

=head1 AUTHOR


=head1 SEE ALSO

perl(1).

=cut