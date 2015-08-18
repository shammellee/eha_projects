$ ->
	calculator.init()

	$('form').submit ->
		false

calculator =
	'config':
		calculatorSliders: 'form#sliders'
		prefix: '$'
		postfix: ''

	'init': (config)->
		if config and typeof config is 'object'
			$.extend calculator.config,config

		calculator.$wrapper      = $ calculator.config.calculatorSliders
		calculator.$sliders      = calculator.$wrapper.find 'div.slider'
		calculator.$sliderOutput = calculator.$wrapper.find '.wrapper_slider .sliderValue'
		calculator.$total        = $ '#total','#totalOuterShell'

		calculator._sliderInitialize()
		calculator._sliderLoadData()

	'_sliderLoadData': ->
		calculator.$sliderOutput.each (index)->
			min            = 1
			max            = $(@).data 'max'
			inc            = $(@).data 'inc'
			initialValue   = calculator._cleanSliderOutput $(@).text()
			percentage     = $(@).data 'percentage'
			sliderPos      = (min / max) * 100
			sliderNumber   = ++index
			sliderToUpdate = $('div#slider' + sliderNumber)

			sliderToUpdate.slider
				value: (initialValue / max) * 100
				step: parseInt inc,10
				max: max

			sliderToUpdate.parent().find('.sliderValue').val(calculator.config.prefix + initialValue + calculator.config.postfix).attr 'rel',initialValue
			sliderToUpdate.data 'max',max

		calculator._updateSliderPoints()

	'_updateOnSlide': (sliderOutput,uiValue)->
		sliderOutput.attr 'rel',uiValue
		sliderOutput.text(calculator.config.prefix + commaFormatted(uiValue) + calculator.config.postfix)

	'_updateOnType': (sliderOutput)->
		sliderOutputValue = calculator._cleanSliderOutput sliderOutput.text()
		max               = sliderOutput.data 'max'

		if sliderOutputValue > max then sliderOutputValue = max
		if isNaN sliderOutputValue then sliderOutputValue = 0

		sliderPos = (sliderOutputValue / max) * 100

		# set slider handle position & slider range position
		sliderOutput.closest('.sliderWrapper').find('.ui-slider-handle').css('left',sliderPos + '%')

		# set input values & clone
		sliderOutput.attr 'rel',sliderOutputValue
		sliderOutput.text(calculator.config.prefix + commaFormatted(sliderOutputValue) + calculator.config.postfix)

		calculator._updateSliderPoints()

	'_sliderInitialize': ->
		# config jquery ui sliders and set callback when moved to update point values
		calculator.$sliders.slider
			animate: false
			min: 0
			slide: (event,ui)->
				calculator._updateOnSlide $(@).parent().find('.sliderValue'),ui.value
				calculator._updateSliderPoints()
			start: (event,ui)->
				if not $(ui.handle).hasClass 'ui-slider-hover' then false

		#calculator.$sliderOutput.on 'click',->
		#	$(@).select()

		calculator.$sliderOutput.change ->
			calculator._updateOnType $(@)

		calculator.$sliders.find('.ui-slider-handle').hover ->
			$(@).addClass 'ui-slider-hover'
		,->
			$(@).removeClass 'ui-slider-hover'

	# calculate slider point values
	'_updateSliderPoints': ->
		total = 0
		calculator.$sliderOutput.each (index)->
			period             = if $(@).data('monthly') is 'true' then 12 else 1
			percentage         = parseInt $(@).data('percentage'),10
			dollarAmount       = parseInt $(@).attr('rel').replace(calculator.config.postfix,'').replace('$','').replace(',',''),10
			amount             = (parseInt($(@).attr('rel').replace(calculator.config.postfix,'').replace('$','').replace(',',''),10) / 100) * percentage

			# u.s. gas station logic
			if index is 0
				maxMonthlySpending = (parseInt $(@).data('max-annual-spending'),10) / 12
				amountOverMax = dollarAmount - maxMonthlySpending
				if dollarAmount <= maxMonthlySpending
					amount = (parseInt($(@).text().replace(calculator.config.postfix,'').replace('$','').replace(',','')) / 100) * percentage
				else
					amount = ((percentage / 100) * maxMonthlySpending) + (parseInt(amountOverMax,10) / 100) * 1

			total += amount

		total = Math.round(total * 12)
		calculator.$total.text(calculator.config.prefix + commaFormatted total)

	'_cleanSliderOutput': (dollarValue)->
		parseInt dollarValue.replace(calculator.config.postfix,'').replace(calculator.config.prefix,'').replace(',','')

# helpers
commaFormatted = (nStr)->
	nStr += '';
	x = nStr.split '.'
	x1 = x[0]
	x2 = if x.length > 1 then '.' + x[1] else ''
	rgx = /(\d+)(\d{3})/
	x1 = x1.replace(rgx,'$1' + ',' + '$2') while rgx.test x1
	x1 + x2