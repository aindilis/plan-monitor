package PMParser;

use Data::Dumper;

use base qw( Parser::MGC );

sub parse
{
   my $self = shift;
   print "parse\n";

   my $rootnode = $self->parse_rule_list;
   print Dumper($rootnode);
}

sub parse_rule_list
{
   my $self = shift;
   print "parse_rule_list\n";

   print Dumper($self->sequence_of
		(
		 sub { $self->parse_rule; }
		));
   # print Dumper($self->any_of( 'parse_rule_list', 'parse_nothing' ));
}

sub parse_rule
{
   my $self = shift;
   print "parse_rule\n";

   print Dumper($self->parse_head);
   print Dumper($self->parse_operator);
   print Dumper($self->parse_body);
}

sub parse_head
{
   my $self = shift;
   print "parse_head\n";

   print Dumper($self->parse_predicate());
}

sub parse_predicate
{
   my $self = shift;
   print "parse_predicate\n";

   print Dumper($self->expect( qr/[a-z][a-zA-Z0-9_]*/ ));
}

sub parse_operator
{
   my $self = shift;
   print "parse_operator\n";

   print Dumper($self->any_of( 'parse_sequence_operator', 'parse_selector_operator' ));
}

sub parse_sequence_operator
{
   my $self = shift;
   print "parse_sequence_operator\n";

   print Dumper($self->expect( qr/->/ ));
}

sub parse_selector_operator
{
   my $self = shift;
   print "parse_selector_operator\n";

   print Dumper($self->expect( qr/>>/ ));
}

sub parse_body
{
   my $self = shift;
   print "parse_body\n";

   print Dumper($self->parse_conjunct_list);
   print Dumper($self->parse_period);
}

sub parse_conjunct_list
  {
    my $self = shift;
    print "parse_conjunct_list\n";

    my $conjuncts = $self->list_of
       (
	",",
	sub {
	  $self->parse_predicate;
	}
      );
    @$conjuncts > 0 or $self->fail( "Expected at least one conjunct" );
}

sub parse_period
{
   my $self = shift;
   print "parse_period\n";

   print Dumper($self->expect( qr/\./ ));
}


1;
