package API::Instagram::Search;

# ABSTRACT: Instagram Search Object

use Moo;

my $search = {
	user     => 'users/search',
	media    => 'media/search',
	tag      => 'tags/search',
	location => 'locations/search',
};

has type => ( is => 'ro', required => 1, isa => sub { die "Type not supported." unless $search->{$_[0]} } );

=method find

	my $users = $instagram->search('user')->find( q => 'larry' );

	for my $user ( @$users ) {
		say $user->username;
	}

Returns a list of B<type> objects searched with the given parameters.

Where B<type> can be: C<user>, C<media>, C<tag> or C<location>.

B<user> parameters:

	my $search = $instagram->search('user');
	$search->find(
		q     => 'larry', # A query string
		count => 5,       # Number of users to return
	);

See L<http://instagram.com/developer/endpoints/users/#get_users_search>.

B<media> parameters:

	my $search = $instagram->search('media');
	$search->find(
		lat => 48.858844, # Latitude of the center search coordinate. If used, lng is required.
		lng => 2.294351, # Longitude of the center search coordinate. If used, lat is required.
		min_timestamp => 1408720000, # A unix timestamp. All media returned will be taken later than this timestamp.
		max_timestamp => 1408723333, # A unix timestamp. All media returned will be taken earlier than this timestamp.
		distance => 500, # Default is 1km (distance=1000), max distance is 5km.
	);

See L<http://instagram.com/developer/endpoints/media/#get_media_search>.

B<tag> parameters:

	my $search = $instagram->search('tag');
	$search->find(
		q => 'perl', # A valid tag name without a leading #.
	);

See L<http://instagram.com/developer/endpoints/tags/#get_tags_search>.

B<location> parameters:

	my $search = $instagram->search('location');
	$search->find(
		distance => 2000, # Default is 1000m (distance=1000), max distance is 5000.
		lat => 48.858844, # Latitude of the center search coordinate. If used, lng is required.
		lng => 2.294351, # Longitude of the center search coordinate. If used, lat is required.
		facebook_places_id => 123, # Returns a location mapped off of a Facebook places id. If used, a Foursquare id and lat, lng are not required.
		foursquare_id => 456, # Returns a location mapped off of a foursquare v1 api location id. If used, you are not required to use lat and lng. Note that this method is deprecated; you should use the new foursquare IDs with V2 of their API.
		foursquare_v2_id => 789, # Returns a location mapped off of a foursquare v2 api location id. If used, you are not required to use lat and lng.
	);

See L<http://instagram.com/developer/endpoints/locations/#get_locations_search>.

=cut

sub find {
	my $self = shift;
	my %opts = @_;
	my $type = $self->type;
	my $url  = $search->{$type};
	my $api  = API::Instagram->instance;
	[ map { $api->$type($_) } $api->_get_list( { %opts, url => $url } ) ]
}

=for Pod::Coverage type
=cut

1;