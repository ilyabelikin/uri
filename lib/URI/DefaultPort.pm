use v6;

# This logic seems to belong somewhere related to URI but not in the URI
# module itself.

package URI::DefaultPort {

	my %default_port = (
		ftp		=>		21,
		ssh		=>		22,
		telnet	=>		23,
		tn3270	=>		23,
		gopher 	=> 		70,
		http	=>		80,
		pop		=>		110,
		news	=>		119,
		ldap	=>		389,
		https	=>		443,
		rlogin	=>		513,
		rtsp	=>		554,
		rtspu	=>		554,
		snews	=>		563,
		ldaps	=>		636,
		rsync	=>		873,
		mms		=>		1755,
		sip		=>		5060,
		sips	=>		5061
	);
	
	our sub scheme_port(Str $scheme) {
		# guessing the // Int should be unnecessary some day ...
		return  %default_port{$scheme}.Int // Int;
	}

}

# vim:ft=perl6
