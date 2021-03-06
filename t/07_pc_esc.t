#
# このファイルのエンコーディングはUTF-8
#

# copied over from JSON::PC and modified to use Cpanel::JSON::XS

use Test::More tests => 17;
use strict;
use utf8;
#BEGIN { plan tests => 17 };
use Cpanel::JSON::XS;

#########################
my ($js,$obj,$str);

my $pc = new Cpanel::JSON::XS;

$obj = {test => qq|abc"def|};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\"def"}|);

$obj = {qq|te"st| => qq|abc"def|};
$str = $pc->encode($obj);
is($str,q|{"te\"st":"abc\"def"}|);

$obj = {test => qq|abc/def|};   # / => \/
$str = $pc->encode($obj);         # but since version 0.99
is($str,q|{"test":"abc/def"}|); # this handling is deleted.
$obj = $pc->decode($str);
is($obj->{test},q|abc/def|);

$obj = {test => q|abc\def|};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\\\\def"}|);

$obj = {test => "abc\bdef"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\bdef"}|);

$obj = {test => "abc\fdef"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\fdef"}|);

$obj = {test => "abc\ndef"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\ndef"}|);

$obj = {test => "abc\rdef"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\rdef"}|);

$obj = {test => "abc-def"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc-def"}|);

$obj = {test => "abc(def"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc(def"}|);

$obj = {test => "abc\\def"};
$str = $pc->encode($obj);
is($str,q|{"test":"abc\\\\def"}|);

SKIP: {
skip "5.6", 2 if $] < 5.008;

$obj = {test => "あいうえお"};
$str = $pc->encode($obj);
is($str,q|{"test":"あいうえお"}|);

$obj = {"あいうえお" => "かきくけこ"};
$str = $pc->encode($obj);
is($str,q|{"あいうえお":"かきくけこ"}|);
}

$obj = $pc->decode(q|{"id":"abc\ndef"}|);
is($obj->{id},"abc\ndef",q|{"id":"abc\ndef"}|);

$obj = $pc->decode(q|{"id":"abc\\\ndef"}|);
is($obj->{id},"abc\\ndef",q|{"id":"abc\\\ndef"}|);

$obj = $pc->decode(q|{"id":"abc\\\\\ndef"}|);
is($obj->{id},"abc\\\ndef",q|{"id":"abc\\\\\ndef"}|);

