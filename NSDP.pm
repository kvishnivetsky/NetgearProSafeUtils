package NSDP;

use IO::Socket;

use constant TLV_MODEL => 0x0001;
use constant TLV_NAME => 0x0003;
use constant TLV_MAC => 0x0004;
use constant TLV_IP => 0x0006;
use constant TLV_MASK => 0x0007;
use constant TLV_GW => 0x0008;
use constant TLV_FWVER => 0x000d;

my $DEBUG = 0;

sub setDebug {
    my $debug = shift;
    $DEBUG = ($debug ne 0);
};

sub NSDP_send {
    my $sock = shift;
    my $DST_ADDR = shift;
    my $selfmac = shift;
    my $swmac = shift;
    my $seq = shift;
    my $msg = shift;

    my $header = "\x01\x01\x00\x00\x00\x00\x00\x00".$selfmac.$swmac."\x00\x00".pack("N", $seq)."NSDP\x00\x00\x00\x00".$msg."\xff\xff\xff\xff";
    my $dst = sockaddr_in(63322, $DST_ADDR);
    $sock->send($msg, 0, $dst) or die "send: $!";
    my @hexdata = unpack("C*", $msg);
    printf ">> %s\n", join(' ', map(sprintf("0x%.2x", $_), @hexdata));
};

1;
