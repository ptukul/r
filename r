package Page;

require Exporter;

use warnings;

use strict;

use utf8;

use List::Util;

use Vandalism;

use Logging;

use ConfigFile;

use Format;

use Loc;

use Tables;

our @ISA     = qw (Exporter);

our @EXPORT  = qw(init_page is_test_page is_ignored_page is_defended_page handle_summary run_text_analysis adjust_on_length);

our $VERSION = 1.00;

# TODO: move is_xxx on-wiki

# TODO: init_page and retrieve_page should be in the same file

sub init_page

{

    my ($rc) = @_;

    # $log->debug ("adding page row for $rc->{page_name}");

    my %hash = (

        page          => $rc->{page_name},

        creator       => $rc->{user},

        creation_time => $rc->{time}

    );

    my $page_ref = Table::Page->retrieve( $rc->{page_name} );

    # Workaround to make retrieve case-sensitive    

    if (defined $page_ref)

    {

    	my $retrieved_page_name = $page_ref->page;

	utf8::decode($retrieved_page_name);

	if ($retrieved_page_name ne $rc->{page_name})

	{

	    undef $page_ref;

	}

    }

    if ( !defined $page_ref )

    {

        $page_ref = Table::Page->insert( \%hash );

        warn("insert failed for $rc->{page_name}") unless $page_ref;

    }

}

sub is_test_page

{

    my ($rc) = @_;

    my $is_test = 0;

    return unless (defined $rc->{page_name}); # Probably a move

    $is_test = 1 if ( $rc->{page_name} eq $config->{wiki_test_page} );

    $is_test = 1 if ( index( $rc->{page_name}, "$USER_NAMESPACE:Gribeco" ) == 0 );

    return $is_test;

}

sub is_ignored_page

{

    my ($rc) = @_;

    my $ignore = 0;

    my @ignore_list = split (',', $config->{wiki_ignore_pages});

。
