#!/usr/bin/perl
use strict;
use warnings;
use Data::Dumper;

my $ARGC = scalar(@ARGV);
my $file_name = shift @ARGV;
die("Please provide an input file") unless $file_name;
my $word_count = shift @ARGV;
$word_count = 100 unless $word_count;
open(INPUT, "<$file_name") || die "Couldn't open file $?";

my $input_string = "";
while(<INPUT>){
    $input_string .= $_
}
close(INPUT);

$input_string =~ tr{\n}{ };
$input_string = lc($input_string);
$input_string =~ s/([,.!?\-;:"])/ $1 /g;


my @input_list = split(' ', $input_string);
my $len_input_list = scalar(@input_list);

our %hash;
my $index = 0;
for my $l (@input_list){
    if($index == ($len_input_list-1)){
	last;
    }
    
    $hash{$l}{$input_list[$index+1]} += 1;
    
    $index++;
}

# Text generator

my $random_index = int(rand($len_input_list));
our $cur_word = $input_list[$random_index];
sub get_word {
    my $next_wordlist;
    $next_wordlist = $hash{$cur_word};
    unless($next_wordlist){
	my $randword = $input_list[int(rand($len_input_list))];
	$cur_word = $randword;
	return $cur_word;
    }    
    my %next_wordlist_hash = %{$next_wordlist};
    my @selection_list = ();
    foreach my $key ( keys %next_wordlist_hash) {
	my $times = $next_wordlist_hash{$key};
	foreach my $n (0..($times-1)){
	    push(@selection_list, $key);
	}
    }
    my $selected = $selection_list[int(rand(scalar(@selection_list)))];
    $cur_word = $selected;
    return $cur_word;
    
}
my $result = "";
for my $i (0..$word_count-1){
    $result .= get_word() . " ";
}

$result =~ s/ ([,.!?:;] )/$1/g;

print "$result\n";
