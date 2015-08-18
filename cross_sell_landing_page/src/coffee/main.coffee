$ ->
	$benefitsAndToolsSection = $ '#benefitsAndTools'
	$businessRewardsSection  = $ '#businessRewards'
	$legal                   = $ '#legalContainer'
	$sideNav                 = $ '.sideNav'
	$sideNavItems            = $sideNav.find 'li'
	accordionContractedClass = 'contract'
	accordionExpandedClass   = 'expand'
	easeMethod               = 'easeInOutExpo'
	legalBorderBotomWidth    = parseInt ($legal.prev().css 'border-bottom-width'),10
	sideNavActiveClass       = 'active'
	sideNavFixedClass        = 'fixed'
	sideNavHeight            = $sideNav.outerHeight()
	sideNavLowerBoundClass   = 'lowerBound'
	sideNavLowerBoundOffset  = 68
	sideNavMaxTop            = 0

	$sideNav.find('a').click (e)->
		e.preventDefault()
		_scrollToElement $ $(@).attr 'href'

	_scrollToElement = ($el)->
		if $el and $el instanceof $
			elTop = $el.offset().top
			if($(window).scrollTop() != elTop)
				$('html,body').animate
					scrollTop:elTop
				,1500,easeMethod

	$(window).scroll ->
		st = $(@).scrollTop()

		# make side nav fixed if page is scrolled to top of first section
		if $businessRewardsSection.offset().top - sideNavMaxTop <= st <= $legal.offset().top - legalBorderBotomWidth - sideNavHeight
			$sideNav.removeClass(sideNavLowerBoundClass).addClass sideNavFixedClass
		else
			if $sideNav.hasClass sideNavFixedClass or $sideNav.hasClass sideNavLowerBoundClass
				$sideNav.removeClass sideNavFixedClass + ' ' + sideNavLowerBoundClass

		# remove fixed class if page is scrolled past sections
		if st > $legal.offset().top - legalBorderBotomWidth - sideNavHeight - sideNavLowerBoundOffset
			$sideNav.removeClass(sideNavFixedClass).addClass sideNavLowerBoundClass

		# automatic side nav item highlighting
		if st < $benefitsAndToolsSection.offset().top - sideNavMaxTop
			_highlightNavItem $sideNavItems.eq 0
		else
			_highlightNavItem $sideNavItems.eq 1

	_highlightNavItem = ($el)->
		$sideNavItems.removeClass sideNavActiveClass
		$el?.addClass sideNavActiveClass

	$('.accordionHead').click ->
		$(@).parent().find(".accordionContentContainer[data-section_id='#{$(@).data 'section_id'}']").slideToggle 1000, 'easeOutExpo'
		icon = $(@).find('.accordionIcon')
		if icon.hasClass accordionExpandedClass
			icon.removeClass(accordionExpandedClass).addClass(accordionContractedClass)
		else
			icon.removeClass(accordionContractedClass ).addClass(accordionExpandedClass)
