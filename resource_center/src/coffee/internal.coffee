$ =>
	originProtocol    = location.protocol
	ytScript          = document.createElement 'script'
	ytScript.src      = "http://youtube.com/iframe_api"
	firstScript       = document.getElementsByTagName('script')[0]
	$overlay          = $ '.overlay'
	$agreement        = $ '#agreementShell'
	$agreementConfirm = $agreement.find '.agreementConfirm'
	$videoPlayer      = $ '#youtubeVideoPlayerShell'
	$youtube          = $ '#youtubeVideoPlayer'
	$sortFavorite     = $('#resourceListShell').find '.icon_sort_favorite'
	$sortDate         = $('#resourceListShell').find '.icon_sort_date'
	$favoriteList     = $ '#sortByFavorite'
	$dateList         = $ '#sortByDate'
	mediaId           = ''
	modals            = [$agreement,$videoPlayer]
	@player           = null
	videoID           = 'foo'
	MEDIA_URL_PREFIX  = '/mediahandler/?mediaid='
	KEY               = {ESCAPE:27}
	msInDay           = 86400002
	agreementCookie   = 'agreementConfirmed'
	ua                = navigator.userAgent
	isBadBrowser      = (/msie/gi.test(ua)) or (/safari/gi.test(ua) and !/chrome/gi.test(ua)) or (/firefox/gi.test(ua))

	if isBadBrowser
		$('li.video').find('a').click (e)->
			e.preventDefault()
			setVideoSource $(@).attr 'href'
			showVideoPlayer()
	else
		$youtube.attr 'src',"http://www.youtube.com/embed/?enablejsapi=1&origin=#{location.origin}&rel=0"
		firstScript.parentNode.insertBefore ytScript,firstScript

		@onYouTubeIframeAPIReady = =>
			@player = new YT.Player 'youtubeVideoPlayer',
				events:
					'onReady':onPlayerReady

		@onPlayerReady = ->
			player = @player
			$('li.video').find('a').click (e)->
				e.preventDefault()

				if videoID is vID = $(@).attr 'href'
					if player.getPlayerState() is YT.PlayerState.ENDED
						player.seekTo 0
					else
						player.playVideo()
				else
					player.loadVideoById vID
					videoID = vID
				showVideoPlayer()

	$('.module').find('a.downloadLink').click (e)->
		e.preventDefault()
		mediaId = $(@).attr 'id'
		if cookieEq agreementCookie,'true'
			gotoDownload()
		else
			showAgreement()

	$agreementConfirm.click (e)->
		e.preventDefault()
		document.cookie = "#{agreementCookie}=true;expires=#{(new Date(yearsFromNow 1)).toUTCString()}"
		omnitureTrack 'rmaction','Accept_T&C'
		hideModals()
		hideOverlay()
		gotoDownload()

	$('.overlay,.closeVideo').click =>
		if isBadBrowser
			unsetVideoSource()
		else
			player.pauseVideo?()
		hideModals()
		hideOverlay()

	$sortFavorite.click ->
		$sortFavorite.removeClass('icon_sort_favorite_inactive').addClass('icon_sort_favorite_active')
		$sortDate.removeClass('icon_sort_date_active').addClass('icon_sort_date_inactive')
		$favoriteList.show()
		$dateList.hide()

	$sortDate.click ->
		$sortFavorite.removeClass('icon_sort_favorite_active').addClass('icon_sort_favorite_inactive')
		$sortDate.removeClass('icon_sort_date_inactive').addClass('icon_sort_date_active')
		$favoriteList.hide()
		$dateList.show()

	$('body').keyup (e)->
		if e.which is KEY.ESCAPE and ($agreement.is ':visible' or $videoPlayer.is ':visible')
			hideModals()
			hideOverlay()

	$('.icon_modal_close').click ->
		hideModals()
		hideOverlay()

	setVideoSource = (id)->
		$youtube.attr 'src',"http://www.youtube.com/embed/#{id}?origin=#{location.origin}&rel=0"

	unsetVideoSource = ->
		setVideoSource ''

	showVideoPlayer = ->
		hideModals()
		showOverlay()
		omnitureTrack 'layertrack','VideoLayer'
		$videoPlayer.show()

	showAgreement = ->
		hideModals()
		omnitureTrack 'layertrack','Show_T&C'
		showOverlay()
		$agreement.show().find('.agreementBody').scrollTop(0)

	showOverlay = ->
		$overlay.show()

	hideOverlay = ->
		$overlay.hide()

	hideModals = ->
		el.hide() for el in modals

	yearsFromNow = (years)->
		years = parseInt years,10
		(Date.now?() or new Date().getTime()) + msInDay * 365 * years

	getCookie = (key)->
		decodeURIComponent(document.cookie.replace(new RegExp("(?:(?:^|.*;)\\s*" + encodeURIComponent(key).replace(/[\-\.\+\*]/g, "\\$&") + "\\s*\\=\\s*([^;]*).*$)|^.*$"), "$1"))

	cookieEq = (key,value)->
		(getCookie key) is value

	gotoDownload = ->
		omnitureTrack 'rmaction','Download_PlayBook'
		location.href = "mediaHandler/?mediaId=#{mediaId}"

	omnitureTrack = (param1,param2)->
		if typeof window.$iTagTracker is 'function' then window.$iTagTracker param1,param2 else null