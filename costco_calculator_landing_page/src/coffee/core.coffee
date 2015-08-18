$ ->
	scrollDurationInMilliseconds = 1500
	scrollEaseMethod             = 'easeInOutExpo'
	stickyDurationInMilliseconds = 750
	stickyEaseMethod             = 'easeOutExpo'
	$scrollToTop                 = $ '.scrollToTop'
	$scrollToCalculator          = $ 'a.scrollToCalculator','#section1'
	$percentages                 = $ '#percentageShell'
	$sticky                      = $ '#stickyShell','#aux'

	$scrollToTop.click (e)->
		e.preventDefault()
		scrollToElement $ 'html'

	$scrollToCalculator.click (e)->
		e.preventDefault()
		scrollToElement $ $(@).attr 'href'

	scrollToElement = ($el) ->
		if $el and $el instanceof $
			elTop = $el.offset().top

			if $(window).scrollTop() != elTop
				$('html,body').animate
					scrollTop:elTop
				,scrollDurationInMilliseconds,scrollEaseMethod

	showSticky = ->
		$sticky.stop().animate
			'bottom':'0px'
		,stickyDurationInMilliseconds,stickyEaseMethod,->
			checkSticky()

	hideSticky = ->
		$sticky.stop().animate
			'bottom':'-75px'
		,stickyDurationInMilliseconds,stickyEaseMethod,->
			checkSticky()

	checkSticky = ->
		scrollTop = $(@).scrollTop()
		stickyY   = parseInt $sticky.css('bottom'),10

		if scrollTop >= $percentages.offset().top and stickyY < 0
			showSticky()
    
		if scrollTop < $percentages.offset().top and stickyY >= 0
			hideSticky()

	$(window).on 'scroll resize',->
		checkSticky()

	checkSticky()