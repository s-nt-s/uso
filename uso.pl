#!/usr/bin/perl -w
use Cwd 'abs_path';

my ($hst,$tp,$icm,$filter)=(undef,-1,0,0);
while(@ARGV) {
	$_=shift(@ARGV);
	if ($_ =~ /\d+/) {
		$tp=$_;
	} elsif ($_ eq "-c") {
		$icm=1;
	} elsif (-f $_) {
		$hst=$_;
	} else {
		$filter=$_;
	}
}
if ($tp==-1) {$tp=($filter?5:10);}
if (!$hst) {
    $hst="$ENV{HOME}/.bash_history";
}
my $home= abs_path($hst);
$home =~ s/\/[^\/]+$/\//;

sub report_top {
	my( $top_count, %hash ) = @_;
	my @top_commands  = sort { $hash{$b} <=> $hash{$a} } keys %hash;
	my $max_width = length $hash{$top_commands[0]};
	while( my( $i, $value ) = each @top_commands ) {
		last if $i >= $top_count && $top_count>0;
		#printf '%*d %s' . "\n", $max_width, $hash{$top_commands[$i]}, $top_commands[$i];
		print $top_commands[$i] . "\n";
	}
}
sub gFile {
	my $r=shift;
	if (-f $r) {
		return abs_path($r);
	} 
	my $p=index($r,"/");
	if ($p==0) {
		return $r;
	}
	if (-f ($home . $r)) {
		return abs_path(($home . $r));
	}
	if ($p>0) {
		$r=`sudo test -e $r && sudo readlink -f $r || echo 0`;
		chomp($r);
		return $r;
	}
	return undef;
}

open (HISTORY, "<", $hst)  or die "Cannot open $hst: $!";

my $b;
my $cmd;
my @fls;
my %files;
my %cmds;
while ($cmd=<HISTORY>) {
	chomp($cmd);
	$cmd =~ s/  +/ /g;
	$cmd =~ s/(^ +| +$)//g;
	$cmd =~ s/^sudo +//;
	next if length($cmd)<5 || index($cmd," ")<1 || $cmd =~ /(whereis|kill|cd|ls|su|uso) / || ($filter && index($cmd,$filter)==-1);
	$b=($cmd =~ /^(nano|tail|head|cat) /);
	if (!$icm && $b) {
		@fls=split(/ /,$cmd);
		shift(@fls);
		foreach my $fl (@fls) {
			if (index($fl,"/")==0 && $files{$fl}) {$files{$fl}++}
			elsif (($fl=gFile($fl)) && index($fl,$home)!=0) {$files{$fl}++;}
		}
		next;
	}
	if ($icm && !$b) {
		$cmds{$cmd}++;
	}
}
close(HISTORY);

if (keys(%files)) {report_top($tp,%files);}
if (keys(%cmds)) {report_top($tp,%cmds);}
