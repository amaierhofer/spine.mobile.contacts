Spine   = require('spine')
{Panel} = require('spine.mobile')
$       = Spine.$
Contact = require('models/contact')

class ScrollingPanel extends Panel
	constructor: ->
		super
		@header.addClass('header')
		@footer.addClass('footer')
		@content.addClass('wrapper')
		@content.append('<div class="scroller"/>')
		@content = @content.find('.scroller')

	html: (view) =>
		console.log "hasScroller: #{@scroller?}"
		super view
		unless @scroller?
			wrapper = @content.parents('.wrapper')[0]
			@scroller = new iScroll(wrapper, checkDOMChanges: true)
			document.addEventListener 'touchmove', ((e) -> e.preventDefault()), false
		else
		setTimeout (() => @scroller.refresh()), 0
		@content

class ContactsShow extends Panel
	className: 'contacts showView'

	constructor: ->
		super

		Contact.bind('change', @render)

		@active (params) ->
			@change(params.id)

		@addButton('Back', @back)

	render: =>
		return unless @item
		@html require('views/contacts/show')(@item)


	change: (id) ->
		@item = Contact.find(id)
		@render()

	back: ->
		@navigate('/contacts', trans: 'left')

class ContactsCreate extends Panel
	elements:
		'input': 'input'

	events:
		'submit form': 'submit'

	className: 'contacts createView'

	constructor: ->
		super

		@addButton('Cancel', @back)
		@addButton('Create', @submit).addClass('right')

		@render()

	render: ->
		@html require('views/contacts/form')()

	submit: (e) ->
		e.preventDefault()
		contact = Contact.create(email: @input.val())
		if contact
			@input.val('')
			@navigate('/contacts', contact.id, trans: 'left')

	back: ->
		@navigate('/contacts', trans: 'left')

	deactivate: ->
		super
		@input.blur()

class ContactsList extends ScrollingPanel
	events:
		'tap .item': 'click'

	title: 'Contacts'

	className: 'contacts list listView'

	constructor: ->
		super
		Contact.bind('refresh change', @render)
		@addButton('Add', @add).addClass('right')

	render: =>
		items = Contact.all()
		@html require('views/contacts/item')(items)

	click: (e) ->
		item = $(e.target).item()
		@navigate('/contacts', item.id, trans: 'right')

	add: ->
		@navigate('/contacts/create', trans: 'right')


class Contacts extends Spine.Controller
	constructor: ->
		super

		@list    = new ContactsList
		@show    = new ContactsShow
		@create  = new ContactsCreate

		@routes
			'/contacts':        (params) -> @list.active(params)
			'/contacts/:id':    (params) -> @show.active(params)
			'/contacts/create': (params) -> @create.active(params)

		Contact.fetch()

module.exports = Contacts
