require('lib/setup')

$        = jQuery
Spine    = require('spine')
{Stage}  = require('spine.mobile')
Contacts = require('controllers/contacts')
Contact = require('models/contact')

class App extends Stage.Global
	constructor: ->
		super
		@contact = Contact
		@contacts = new Contacts

		Spine.Route.setup(shim:true)
		@navigate '/contacts'

		$('body').bind 'click', (e) ->
			e.preventDefault()

		@addSomeUsers()

	addSomeUsers: ->
		localStorage.removeItem("Contact")
		if @contact.all().length == 0
			@contact.create(name: "Dummy#{idx}") for idx in [1...10]


module.exports = App
