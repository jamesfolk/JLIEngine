use strict;
use warnings;

my $filename = $ARGV[0];



my $data = read_file($filename);

my $old = '\n';
my $new = '"
';
$data =~ s/$old/$new/g;


$old = '/Users/jamesfolk/Dropbox/DEV/Libraries/JLIEngine/src/';
$new = '#include "';
$data =~ s/$old/$new/g;


my $header = "#ifndef BaseProject_JLIEngineCommon_h\n#define BaseProject_JLIEngineCommon_h\n";
my $footer = "#endif\n";

$data = $header . $data . $footer;

write_file($filename, $data);
exit;

sub read_file {
    my ($filename) = @_;
    
    open my $in, '<:encoding(UTF-8)', $filename or die "Could not open '$filename' for reading $!";
    local $/ = undef;
    my $all = <$in>;
    close $in;
    
    return $all;
}

sub write_file {
    my ($filename, $content) = @_;
    
    open my $out, '>:encoding(UTF-8)', $filename or die "Could not open '$filename' for writing $!";;
    print $out $content;
    close $out;
    
    return;
}