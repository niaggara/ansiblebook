#!/usr/bin/perl
use strict;
use English qw( -no_match_vars );    # PBP 79
use Carp;                            # PBP 283
use warnings;                        # PBP 431

use Socket;
our $VERSION = 1;

my $host = $ARGV[0], my $port = $ARGV[1];

# create the socket, connect to the port
socket SOCKET, PF_INET, SOCK_STREAM, ( getprotobyname 'tcp' )[2]
    or croak "Can't create a socket $OS_ERROR\n";
connect SOCKET, pack_sockaddr_in( $port, inet_aton($host) )
    or croak "Can't connect to port $port! \n";

# eclectic reporting
print "Connected to $host:$port\n" or croak "IO Error $OS_ERROR";

# close the socket
close SOCKET or croak "close: $OS_ERROR";

__END__
