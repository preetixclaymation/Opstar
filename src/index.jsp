<%
	if(session.getAttribute("email") == null) {
	  response.sendRedirect("login.jsp");
	  return;
	}
%>
<!DOCTYPE html>
<html lang="en" style="scroll-behavior: smooth;">

<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OpStars Home</title>
    <script src="js/main.js"></script>
    <link rel="stylesheet" href="css/style.css">
    <link rel="stylesheet" href="css/custom.css">
    <link rel="stylesheet" href="https://code.ionicframework.com/ionicons/2.0.1/css/ionicons.min.css">
    <script type="text/javascript">
      const isAdmin = <%= session.getAttribute("isAdmin")%>;
    </script>
</head>

<body>
    <div class="popup" style="display: none;">
        <div class="goBack" onclick="closePopup(this)">
            <img src="static/img/arrow-back-outline.svg">
        </div>  
        <div class="popup-top">
            <picture>

            </picture>

            <div class="spectrum3" style="opacity: 0;">
            </div>



            <div class="audio green-audio-player">
                <div class="loading">
                    <div class="spinner"></div>
                </div>
                <div class="play-pause-btn">
                    <svg xmlns="http://www.w3.org/2000/svg" width="18" height="24" viewBox="0 0 18 24">
                        <path fill="#566574" fill-rule="evenodd" d="M18 12L0 24V0" class="play-pause-icon"
                            id="playPause" />
                    </svg>
                </div>

                <div class="controls">
                    <span class="current-time">0:00</span>
                    <div class="slider" data-direction="horizontal">
                        <div class="progress">
                            <div class="pin" id="progress-pin" data-method="rewind"></div>
                        </div>
                    </div>
                    <span class="total-time">0:00</span>
                </div>

                <div class="volume">
                    <div class="volume-btn">
                        <svg xmlns="http://www.w3.org/2000/svg" width="24" height="24" viewBox="0 0 24 24">
                            <path fill="#566574" fill-rule="evenodd"
                                d="M14.667 0v2.747c3.853 1.146 6.666 4.72 6.666 8.946 0 4.227-2.813 7.787-6.666 8.934v2.76C20 22.173 24 17.4 24 11.693 24 5.987 20 1.213 14.667 0zM18 11.693c0-2.36-1.333-4.386-3.333-5.373v10.707c2-.947 3.333-2.987 3.333-5.334zm-18-4v8h5.333L12 22.36V1.027L5.333 7.693H0z"
                                id="speaker" />
                        </svg>
                    </div>
                    <div class="volume-controls hidden">
                        <div class="slider" data-direction="vertical">
                            <div class="progress">
                                <div class="pin" id="volume-pin" data-method="changeVolume"></div>
                            </div>
                        </div>
                    </div>
                </div>


                <audio>
                    <source src="" type="audio/mp3">
                </audio>
            </div>




            <video id="my-video" class="video-js" controls preload="auto" data-setup='' loop>
                <source src="cards/content/1.mp4" type='video/mp4'>
            </video>
        </div>
        <div class="popup-bottom">
            <img src="cards/logo/10.png" class="popup-logo">
            <p class="popup-text">A film about a man, his suitcase, and a dream.</p>
        </div>
    </div>

    <div id="___gatsby">

        <div class="NavBar NavBar-Menu--white NavBar--white">
            <a aria-current="page" class="Logo show" aria-label="Presents Homepage" href="index.jsp">
                <img src="static/img/logo.svg" height="100%">
            </a>
            <div class="NavBar-Menu">
                <ul>
                    <li><a href="#tabs-1621261158142-tab-0-panel" style="color: white;"
                            onclick="changeCategory(this)">Watch</a></li>
                    <li><a href="#tabs-1621261158142-tab-0-panel" style="color: white;"
                           onclick="changeCategory(this)">Listen</a></li>
                <%
                  if (Boolean.TRUE.equals(session.getAttribute("isAdmin"))) {   
                %> 
                    <li><a style="color: white; cursor: pointer;"
                           onclick="manageShows(event)">Manage Shows</a></li>
                <%   
                   }
                %>
                    <li>
                    	<div id="jqi-user-email" style="color: white; font-size: 1rem; display: none;">${email}</div>
                    	<div style="color: white; font-size: 1rem; display: none;">${name}</div>
                        <div style="color: white; font-size: 1rem;">${lastName} ${firstName}</div>
                    	<div><a style="color: white; font-size: 1rem;" href="logout.jsp">Logout</a></div>
                    </li>        
                </ul>
            </div>

        </div>
        <div style="outline:none" tabindex="-1" id="gatsby-focus-wrapper"><a class="JumpToContent" href="#/"><span>Jump
                    to content</span></a>

            <div class="HomepageGrid">
                <h2 class="Header2 HomepageGrid-header" id="homepage-grid-title" tabindex="-1"><span>All Shows</span>
                </h2>
                <div class="HomepageGrid-innerWrapper">
                    <div class="Tabs-homepage">


                        <div class="Tabs-tabWrapper HomepageGrid-filterBar HomepageGrid-filterBar--sticky">
                            <div role="tablist">
                                <div class="Tabs-tablist Tabs-tablist--dark">
                                    <div onclick="changeCategory(this)" id="tabs-1621963902276-tab-0" tabindex="0"
                                        role="tab" aria-selected="true" aria-controls="tabs-1621963902276-tab-0-panel"
                                        class="Tabs-tab Tabs-tab--dark Tabs-tab--active"><span
                                            class="Eyebrow "><span>All</span></span></div>
                                    <div onclick="changeCategory(this)" id="tabs-1621963902276-tab-1" tabindex="-1"
                                        role="tab" aria-selected="false" aria-controls="tabs-1621963902276-tab-1-panel"
                                        class="Tabs-tab Tabs-tab--dark">
                                        <span class="Eyebrow "><span>Watch</span></span>
                                    </div>
                                    <div onclick="changeCategory(this)" id="tabs-1621963902276-tab-2" tabindex="-1"
                                        role="tab" aria-selected="false" aria-controls="tabs-1621963902276-tab-2-panel"
                                        class="Tabs-tab Tabs-tab--dark">
                                        <span class="Eyebrow "><span>Listen</span></span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div id="tabs-1621261158142-tab-0-panel" role="tabpanel" aria-hidden="false"
                            aria-describedby="tabs-1621261158142-tab-0">
                            <div class="Tabs-content Tabs-content-homepage"> </div>
                        </div>
                    </div>
                </div>
            </div>
            
            <div class="Footer" border="10p">
                <div class="Footer-left"><a aria-current="page" class="Footer-logo" aria-label=" presents homepage"
                        href="">
                        <img src="static/img/logo.svg" width="50">
                    </a>
                    <p class="Footer-mcpDescription">A collection of original content that celebrates the
                        entrepreneurial spirit.</p>
                </div>
             
              <div class="Footer-bottom">
                    <div class="FooterNav FooterNav--homepage">
                        <div class="FooterNav-links">
                            <a href="mailto:OpStars@wolterskluwer.com" class="OutboundLink FooterNav-link">
                                <span class="Eyebrow ">EMAIL OPSTArS</span></a>
                            <a href="https://www.wolterskluwer.com/en/privacy-cookies" class="OutboundLink FooterNav-link">
                                <span class="Eyebrow ">Privacy &amp; Terms</span></a>
                            <a href="https://forms.office.com/r/xJEPbiyViZ" class="OutboundLink FooterNav-link">
                                <span class="Eyebrow ">SHARE FEEDBACK</span></a>
                            <a href="https://forms.office.com/r/nJQvd76Cuw" class="OutboundLink FooterNav-link">
                                <span class="Eyebrow ">VOLUNTEER AS SPEAKER&nbsp;</span></a>
                        </div>
                    </div>
                </div><span class="Legal FooterLegal">
                <span>All Rights Reserved.</span><br><span>Developed by Xclaymation for FCOE, CT Corp&nbsp;&nbsp;</span>
                </span>
            </div>
        </div>
        <div id="gatsby-announcer"
            style="position:absolute;top:0;width:1px;height:1px;padding:0;overflow:hidden;clip:rect(0, 0, 0, 0);white-space:nowrap;border:0"
            aria-live="assertive" aria-atomic="true"></div>
    </div>
    
    <div id="mv-modal-id" class="mv-modal">
	  <div class="modal-content">
	    <span class="close" onclick="closeMvModal()">&times;</span>
	    <p class="modal-content-body"></p>
	  </div>
	</div>
    
    <script src="https://code.jquery.com/jquery-3.6.0.js"></script>
    <!--script src="js/config.js"></script -->
    <script src="js/cards.js"></script>
    <script src="js/script.js"></script>
    <script src="https://vjs.zencdn.net/5.4.6/video.js"></script>
    <script>
        var audioPlayer = document.querySelector('.green-audio-player');
        var playPause = audioPlayer.querySelector('#playPause');
        var playpauseBtn = audioPlayer.querySelector('.play-pause-btn');
        var loading = audioPlayer.querySelector('.loading');
        var progress = audioPlayer.querySelector('.progress');
        var sliders = audioPlayer.querySelectorAll('.slider');
        var volumeBtn = audioPlayer.querySelector('.volume-btn');
        var volumeControls = audioPlayer.querySelector('.volume-controls');
        var volumeProgress = volumeControls.querySelector('.slider .progress');
        var player = audioPlayer.querySelector('audio');
        var currentTime = audioPlayer.querySelector('.current-time');
        var totalTime = audioPlayer.querySelector('.total-time');
        var speaker = audioPlayer.querySelector('#speaker');

        var draggableClasses = ['pin'];
        var currentlyDragged = null;

        window.addEventListener('mousedown', function (event) {

            if (!isDraggable(event.target)) return false;

            currentlyDragged = event.target;
            let handleMethod = currentlyDragged.dataset.method;

            this.addEventListener('mousemove', window[handleMethod], false);

            window.addEventListener('mouseup', () => {
                currentlyDragged = false;
                window.removeEventListener('mousemove', window[handleMethod], false);
            }, false);
        });

        playpauseBtn.addEventListener('click', togglePlay);
        player.addEventListener('timeupdate', updateProgress);
        player.addEventListener('volumechange', updateVolume);
        player.addEventListener('loadedmetadata', () => {
            totalTime.textContent = formatTime(player.duration);
        });
        player.addEventListener('canplay', makePlay);
        player.addEventListener('ended', function () {
            playPause.attributes.d.value = "M18 12L0 24V0";
            player.currentTime = 0;
        });

        volumeBtn.addEventListener('click', () => {
            volumeBtn.classList.toggle('open');
            volumeControls.classList.toggle('hidden');
        });

        window.addEventListener('resize', directionAware);

        sliders.forEach(slider => {
            let pin = slider.querySelector('.pin');
            slider.addEventListener('click', window[pin.dataset.method]);
        });

        directionAware();

        function isDraggable(el) {
            let canDrag = false;
            let classes = Array.from(el.classList);
            draggableClasses.forEach(draggable => {
                if (classes.indexOf(draggable) !== -1)
                    canDrag = true;
            });
            return canDrag;
        }

        function inRange(event) {
            let rangeBox = getRangeBox(event);
            let rect = rangeBox.getBoundingClientRect();
            let direction = rangeBox.dataset.direction;
            if (direction == 'horizontal') {
                var min = rangeBox.offsetLeft;
                var max = min + rangeBox.offsetWidth;
                if (event.clientX < min || event.clientX > max) return false;
            } else {
                var min = rect.top;
                var max = min + rangeBox.offsetHeight;
                if (event.clientY < min || event.clientY > max) return false;
            }
            return true;
        }

        function updateProgress() {
            var current = player.currentTime;
            var percent = current / player.duration * 100;
            progress.style.width = percent + '%';

            currentTime.textContent = formatTime(current);
        }

        function updateVolume() {
            volumeProgress.style.height = player.volume * 100 + '%';
            if (player.volume >= 0.5) {
                speaker.attributes.d.value = 'M14.667 0v2.747c3.853 1.146 6.666 4.72 6.666 8.946 0 4.227-2.813 7.787-6.666 8.934v2.76C20 22.173 24 17.4 24 11.693 24 5.987 20 1.213 14.667 0zM18 11.693c0-2.36-1.333-4.386-3.333-5.373v10.707c2-.947 3.333-2.987 3.333-5.334zm-18-4v8h5.333L12 22.36V1.027L5.333 7.693H0z';
            } else if (player.volume < 0.5 && player.volume > 0.05) {
                speaker.attributes.d.value = 'M0 7.667v8h5.333L12 22.333V1L5.333 7.667M17.333 11.373C17.333 9.013 16 6.987 14 6v10.707c2-.947 3.333-2.987 3.333-5.334z';
            } else if (player.volume <= 0.05) {
                speaker.attributes.d.value = 'M0 7.667v8h5.333L12 22.333V1L5.333 7.667';
            }
        }

        function getRangeBox(event) {
            let rangeBox = event.target;
            let el = currentlyDragged;
            if (event.type == 'click' && isDraggable(event.target)) {
                rangeBox = event.target.parentElement.parentElement;
            }
            if (event.type == 'mousemove') {
                rangeBox = el.parentElement.parentElement;
            }
            return rangeBox;
        }

        function getCoefficient(event) {
            let slider = getRangeBox(event);
            let rect = slider.getBoundingClientRect();
            let K = 0;
            if (slider.dataset.direction == 'horizontal') {

                let offsetX = event.clientX - slider.offsetLeft;
                let width = slider.clientWidth;
                K = offsetX / width;

            } else if (slider.dataset.direction == 'vertical') {

                let height = slider.clientHeight;
                var offsetY = event.clientY - rect.top;
                K = 1 - offsetY / height;

            }
            return K;
        }

        function rewind(event) {
            if (inRange(event)) {
                player.currentTime = player.duration * getCoefficient(event);
            }
        }

        function changeVolume(event) {
            if (inRange(event)) {
                player.volume = getCoefficient(event);
            }
        }

        function formatTime(time) {
            var min = Math.floor(time / 60);
            var sec = Math.floor(time % 60);
            return min + ':' + (sec < 10 ? '0' + sec : sec);
        }

        function togglePlay() {
            if (player.paused) {
                playPause.attributes.d.value = "M0 0h6v24H0zM12 0h6v24h-6z";
                player.play();
                document.querySelector(".spectrum3").style.opacity = 1;
            } else {
                playPause.attributes.d.value = "M18 12L0 24V0";
                player.pause();
                document.querySelector(".spectrum3").style.opacity = 0;
            }
        }

        function makePlay() {
            playpauseBtn.style.display = 'block';
            loading.style.display = 'none';
        }

        function directionAware() {
            if (window.innerHeight < 250) {
                volumeControls.style.bottom = '-54px';
                volumeControls.style.left = '54px';
            } else if (audioPlayer.offsetTop < 154) {
                volumeControls.style.bottom = '-164px';
                volumeControls.style.left = '-3px';
            } else {
                volumeControls.style.bottom = '52px';
                volumeControls.style.left = '-3px';
            }
        }
        
        function openMvModal() {
            document.querySelector("#mv-modal-id").style.display = "block";
            addContentMvModal('<p>Loading...</p>');
        }
        
        function addContentMvModal(html) {
            document.querySelector("#mv-modal-id").querySelector('.modal-content-body').innerHTML = html;
        }
        
        function closeMvModal() {
        	document.querySelector("#mv-modal-id").style.display = "none";
        }
    </script>
</body>

</html>