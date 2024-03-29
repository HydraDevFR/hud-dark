let isShowed = false
let ammoDisabled = false
notifID = 0

$(function () {
	window.addEventListener('message', function (event) {
		switch (event.data.action) {
			case 'setJob':
				$('.job-text').text(event.data.data)
				break
			case 'setJob2':
				$('.orga-text').text(event.data.data)
				break
			case 'setMoney':
				$('#cash').text(event.data.cash.toLocaleString() + ' $')
				$('#bank').text(event.data.bank.toLocaleString() + ' $')
				if (typeof event.data.black_money !== 'undefined') {
					$('#black_money_item').show()
					$('#black_money').text(event.data.black_money.toLocaleString() + ' $')
				} else {
					$('#black_money_item').fadeOut()
				}
				if (typeof event.data.society !== 'undefined') {
					$('#society_item').fadeIn()
					$('#society').text(event.data.society.toLocaleString() + ' $')
				} else {
					$('#society_item').hide()
				}
				break
			case 'setAmmo':
				$('#ammoBox').show()
				$('#ammoBox-text').text(event.data.data)
				break
			case 'hideAmmobox':
				$('#ammoBox').fadeOut()
				break
			case 'initGUI':
				if (!event.data.data.enableAmmo)
					$('#ammoBox').fadeOut()
				if (event.data.data.whiteMode)
					$('#main').removeClass('dark')
				if (event.data.data.colorInvert)
					$('img').css('filter', 'unset')
				break
			case 'showAlert':
				showAlert(event.data.message, event.data.time, event.data.color)
				break
			case 'disableHud':
				event.data.data ? $('#main').fadeOut(300) : $('#main').fadeIn(1000)
				break
			case 'cinema':
				event.data.data ? $('#cinema').fadeOut(300) : $('#cinema').fadeIn(1000)
				break
		}

		if (event.data.akcija == "tweet") {

			notifID ++ 
			var tweetData = event.data.tweet
			divT = ``


			if (event.data.tweet.image == "") {

				divT = `
					<div class = "tweet" id = "tweet-`+notifID+`" style = "display:none;">
						<div id = "tweetinfo">
							<div id = "author">@`+tweetData.author+`</div>
						</div>

						<div id = "message">
							`+tweetData.message+`
						</div>
					</div>
				`

			} else {

				divT = `
					<div class = "tweet" id = "tweet-`+notifID+`" style = "display:none;">
						<div id = "tweetinfo">
							<div id = "author">@`+tweetData.author+`</div>
						</div>

						<div id = "message">
							<img src = "`+tweetData.image+`" align="left"> `+tweetData.message+`
						</div>
					</div>
				`

			}

			$("#phonenotif").prepend(divT)
			$(`#tweet-`+notifID).fadeIn("slow").delay(4000).fadeOut("slow");

			
		} else if (event.data.akcija == "oglas") {

			notifID ++ 
			var oglasData = event.data.oglas
			divT = ``


			if (event.data.oglas.image == "") {

				divT = `
					<div class = "oglas" id = "tweet-`+notifID+`" style = "display:none;">
						<div id = "tweetinfoOglas">
							<div id = "author">Oglas: `+oglasData.author+`</div>
						</div>

						<div id = "message">
							`+oglasData.message+`
						</div>
					</div>
				`

			} else {

				divT = `
					<div class = "oglas" id = "tweet-`+notifID+`" style = "display:none;">
						<div id = "tweetinfoOglas">
							<div id = "author">Oglas: `+oglasData.author+`</div>
						</div>

						<div id = "message">
							<img src = "`+oglasData.image+`" align="left"> `+oglasData.message+`
						</div>
					</div>
				`

			}

			$("#phonenotif").prepend(divT)
			$(`#tweet-`+notifID).fadeIn("slow").delay(4000).fadeOut("slow");
			
		}

	})
})

$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.action == 'setVitesse') {
			$('.spedometer').css('display', 'block')
			if (event.data.data == 0) {
				$('.speed').text('Vous êtes à l\'arret')
				$('.speed').css('color', 'red')
			} else {
				$('.speed').text(event.data.data + ' km/h')
				$('.speed').css('color', 'green')
			}
		} else if (event.data.action == 'setVitessedisplay') {
			$('.spedometer').css('display', 'none')
		}
	})
})

// fuel
$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.action == 'setFuel') {
			$('.essence').css('display', 'block')
			$('.fuel').text(event.data.data + ' litres')
			if (event.data.data < 20) {
				$('.fuel').css('color', 'orange')
			} else if (event.data.data < 10) {
				$('.fuel').css('color', 'red')
			} else {
				$('.fuel').css('color', 'green')
			}		
		} else if (event.data.action == 'setFueldisplay') {
			$('.essence').css('display', 'none')
		}
	})
})

$(function () {
	window.addEventListener('message', function (event) {
		if (event.data.action == 'setEngine') {
			$('.healt-vehicle').css('display', 'block')
			if (event.data.data == 100 || event.data.data > 60) {
				$('.engine').text('Bon état')
				$('.engine').css('color', 'green')
			} else if (event.data.data < 60 && event.data.data > 30) {
				$('.engine').text('Réparation recommandée')
				$('.engine').css('color', 'orange')
			}
			else if (event.data.data < 30 && event.data.data > 10) {
				$('.engine').text('Réparation nécessaire')
				$('.engine').css('color', 'red')
			} else if (event.data.data < 10 && event.data.data > 0) {
				$('.engine').text('Moteur cassé')
				$('.engine').css('color', 'red')
			} else {
				$('.engine').text('Moteur cassé')
				$('.engine').css('color', 'red')
			}
		} else if (event.data.action == 'setEnginedisplay') {
			$('.healt-vehicle').css('display', 'none')
		}
	}
)})

		