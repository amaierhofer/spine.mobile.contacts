Spine = require('spine')
$     = require('jqueryify')

class Contact extends Spine.Model
	@configure 'Contact', 'email', 'name', 'twitter', 'headline', 'location', 'organization', 'avatar'
	@endpoint: 'http://rap-proxy.herokuapp.com/contacts/email'

	@extend Spine.Model.Local

	@nameSort: (a, b) ->
		if (a.name or a.email) > (b.name or b.email) then 1 else -1


module.exports = Contact
