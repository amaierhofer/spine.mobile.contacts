Spine   = require('spine')
{Stage} = require('spine.mobile')

IScroll =
	_manipulateDOM: ->
		@header.addClass('header')
		@footer.addClass('footer')
		@content.addClass('wrapper')
		@content.append('<div class="scroller"/>')
		@content = @content.find('.scroller')

	_addIScroll: ->
		wrapper = @content.parents('.wrapper')[0]
		@scroller = new iScroll(wrapper, checkDOMChanges: true)

	_addGlobalEventListener: ->
		document.addEventListener 'touchmove', ((e) -> e.preventDefault()), false
		Spine.addedEventListener = true

	_setRefreshTimeout: ->
		timeout = 0
		setTimeout (() => @scroller.refresh()), timeout

	_stagesHTML: ->
		Stage::html.apply(this, arguments)

	html: ->
		return @_stagesHTML() unless window.iScroll?
		@_manipulateDOM() unless @scroller?
		content = Stage::html.apply(this, arguments)
		@_addIScroll() unless @scroller?
		@_addGlobalEventListener unless Spine.addedEventListener?
		@_setRefreshTimeout()
		content

module.exports = IScroll
