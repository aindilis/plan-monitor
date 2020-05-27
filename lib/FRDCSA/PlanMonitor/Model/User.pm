package FRDCSA::PlanMonitor::Model::User;

use strict;
use warnings;

use Mojo::Util qw(secure_compare);

use FRDCSA::BehaviorTree;

sub new { bless {}, shift }

sub get_root {
  my ($self, $username) = @_;
  return unless $username eq 'aindilis';
  return FRDCSA::BehaviorTree->new
    (Nodes =>
     [
      'MAKE_SHOPPING_LIST',
      'PRINT_OUT_SHOPPING_AND_INSTRUCTION_LISTS',
      'CLEAR_OFF_DINING_ROOM_TABLE',
      'EAT_BEFOREHAND',
      'MAKE_ALL_PREPARATIONS',
      'WAIT_UNTIL_11_30_PM_TO_LEAVE',
      'PUT_GLOVES_ON_BEFORE_LEAVING_HOUSE',
      'BRING_WATER_BOTTLES_TO_REFILL',
      'WEAR_MASKS',
      'LEAVE_HOUSE',
      'GET_IN_CAR',
      'CHECK_GAS_LEVEL',
      'DRIVE_TO_WALMART',
      'ARE_LOTS_OF_PEOPLE_THERE',
      'ARE_THEY_OUT_OF_INVENTORY',
      'WALK_INTO_WALMART',
      'START_SHOPPING',
      'GET_EXTRA_5_GAL_JUGS',
      'USE_SELF_CHECKOUT',
      'FINISH_SHOPPING',
      'DRIVE_HOME',
      'PUT_FOOD_IN_STAGING_AREA',
      'DECONTAMINATE_FOOD_WITH_BLEACH_SOLUTION',
      'REMOVE_GLOVES_AND_MASKS',
      'DISPOSE_PROPERLY_OF_GLOVES_AND_MASKS',
     ]);
}

1;
