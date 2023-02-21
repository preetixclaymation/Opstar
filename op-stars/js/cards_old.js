$.ajaxSetup({traditional: true});

const cardsWrapper = document.querySelector(
  ".Tabs-content.Tabs-content-homepage"
);

let movieIds = [];
for (i = 0; i < cards.length; i++) {
  cards[i].movieId = getMovieId(cards[i]);
  movieIds[i] = cards[i].movieId;
}
$.ajax({
  url: "api.jsp",
  method: "POST",
  data: {"action": "getcounts", "movieIds": movieIds},
  dataType: "json"
}).done((res) => {
    const countData = res.data;
    for (i = 0; i < cards.length; i++) {
        const card = cards[i];
        let cdDefault = {like: 0, dislike: 0, comment: 0};
        let cd = countData[card.movieId];
        if (cd) {
            Object.assign(cdDefault, cd);
        }
        Object.assign(card, cdDefault);

        let html = `
            <span class="like ${card.liked? 'active': ''}" id="jq-like-${i}" onclick="likeMovie(event, ${i})">
            <img id = "likeUnlike${i}" src="static/img/like-off.svg" height="20px">    <span class="jq-count count">${card.like}</span>
            </span>
            <span class="dislike ${card.disliked? 'active': ''}" hidden="true" id="jq-dislike-${i}" onclick="dislikeMovie(event, ${i})">
            <img src="static/img/like-off.svg" height="20px"><span class="jq-count count">${card.dislike}</span>
            </span>
            <span class="comment ${card.commented? 'active': ''}" id="jq-comment-${i}" onclick="commentMovie(event, ${i})">
            <img src="static/img/comment-on.svg" height="20px"><span class="jq-count count">${card.comment}</span>
            </span>`;

        document.querySelector(`#jq1-feedback-${i}`).innerHTML = html;
    }
}).fail(() => {

});

renderCards();

function renderCards() {
    let result = "";

    for (i = 0; i < cards.length; i++) {
      let type = cards[i].type;
      let text = cards[i].text;
      let cover = "cards/cover/" + cards[i].cover;
      //   let content = "cards/content/" + cards[i].content;
      let logo = "cards/logo/" + cards[i].logo;
      let card;

      if (type == "podcast") {
        card = `<div class="Ratio ShowCard" style="display:block" onclick="openPopup(this)" onmouseover="addVideo(this)" onmouseout="closeVideo(this)" >
          <div class="Ratio-ratio " style="height:0;position:relative;width:100%;padding-top:151.5151515151515%">
              <div class="Ratio-content " style="height:100%;left:0;position:absolute;top:0;width:100%"><a
                      class="ShowCard-show"
                      style="background-image:url(${cover})"
                      aria-label="Play  Deep Futures podcast. Category: podcast. Description: Envisioning tomorrow, the next century, and next millennium with Annalee Newitz.."
                     >
                      <div class="ShowCard-default" aria-hidden="true">
                          <div class="ShowCard-wrapperDefault">
                              <div class="ShowCard-logoDefault">
                                  <div class="ImageFilter ShowCard-logo" style="position:relative;width:88%"><svg
                                          class="ImageFilter-svg"
                                          style="display:block;height:100%;width:100%;overflow:hidden">
                                          <filter id="filter-image-1621963902283013483842682006353"
                                              color-interpolation-filters="sRGB">
                                              <feColorMatrix type="matrix"
                                                  values="-1 0 0 0 1 0 -1 0 0 1 0 0 -1 0 1 0 0 0 1 0"></feColorMatrix>
                                          </filter>
                                          <image filter="url(#filter-image-1621963902283013483842682006353)"
                                              preserveAspectRatio="xMidYMid meet"
                                              xlink:href="${logo}"
                                              x="0" y="0" width="100%" height="100%"></image>
                                      </svg></div>
                              </div>
                              <div class="EyebrowComponent " aria-hidden="true"><svg width="20" height="19"
                                      class="EyebrowComponent-headphonesIcon">
                                      <g stroke="#FFF" fill="none" fill-rule="evenodd">
                                          <path
                                              d="M6.949 17.524h-.495c-.831 0-1.505-.63-1.505-1.41v-3.181c0-.778.674-1.41 1.505-1.41h.495v6zm6 0h.495c.83 0 1.505-.63 1.505-1.41v-3.181c0-.778-.674-1.41-1.505-1.41h-.495v6z">
                                          </path>
                                          <path
                                              d="M16.652 15.524A8.96 8.96 0 0018.95 9.52c0-4.968-4.03-8.996-9-8.996s-9 4.028-9 8.996c0 2.307.869 4.411 2.296 6.004">
                                          </path>
                                      </g>
                                  </svg><span class="Eyebrow EyebrowComponent-whiteText">${type}</span></div>
                          </div>
                          <div class="ShowCard-overlay"></div>
                      </div>
                      <div class="ShowCard-hover" aria-hidden="true">
                          <div class="ShowCard-hoverVideoWrapper">
                              <div class="Ratio ShowCard-hoverVideo" style="display:block">
                                  <div class="Ratio-ratio " style="height:0;position:relative;width:100%;padding-top:56.25%">
                                      <div class="Ratio-content "
                                          style="height:100%;left:0;position:absolute;top:0;width:100%"><img class="forContent"
                                              src=""
                                              aria-hidden="true">
                                          <div class="ShowCard-overlayVideo"></div><svg class="PlayIcon ">
                                              <g fill="#FFF" fill-rule="evenodd">
                                                  <path
                                                      d="M50 25c0 13.807-11.193 25-25 25S0 38.807 0 25 11.193 0 25 0s25 11.193 25 25z"
                                                      fill-opacity="0.3"></path>
                                                  <path
                                                      d="M19.75 15.433l16.211 9.36a.5.5 0 010 .866L19.75 35.018a.5.5 0 01-.75-.433V15.866a.5.5 0 01.75-.433z">
                                                  </path>
                                              </g>
                                          </svg>
                                      </div>
                                  </div>
                              </div>
                          </div>
                          <div class="ShowCard-hoverInfo">
                              <div class="ShowCard-logoHoverWrapper">
                                  <div class="ShowCard-logoHover"
                                      style="background-image:url(${logo});width:88%">
                                  </div>
                              </div>
                              <div class="ShowCard-hoverContent">
                                  <div class="ShowCard-hoverDescription">
                                      <p class="Text ShowCard-text">${text}</p>
                                  </div>
                              </div>
                              <div class="EyebrowComponent " aria-hidden="true"><svg width="20" height="19"
                                      class="EyebrowComponent-headphonesIcon EyebrowComponent-headphonesIcon--black">
                                      <g stroke="#FFF" fill="none" fill-rule="evenodd">
                                          <path
                                              d="M6.949 17.524h-.495c-.831 0-1.505-.63-1.505-1.41v-3.181c0-.778.674-1.41 1.505-1.41h.495v6zm6 0h.495c.83 0 1.505-.63 1.505-1.41v-3.181c0-.778-.674-1.41-1.505-1.41h-.495v6z">
                                          </path>
                                          <path
                                              d="M16.652 15.524A8.96 8.96 0 0018.95 9.52c0-4.968-4.03-8.996-9-8.996s-9 4.028-9 8.996c0 2.307.869 4.411 2.296 6.004">
                                          </path>
                                      </g>
                                  </svg><span class="Eyebrow ">${type}</span></div>
                          </div>
                      </div>
                  </a></div>
          </div>
          <div id="jq1-feedback-${i}" class="feedback"></div>
      </div>`;
      } else {
        card = `<div class="Ratio ShowCard" onclick="openPopup(this)" style="display:block" onmouseover="addVideo(this)" onmouseout="closeVideo(this)">
          <div class="Ratio-ratio " style="height:0;position:relative;width:100%;padding-top:151.5151515151515%">
              <div class="Ratio-content " style="height:100%;left:0;position:absolute;top:0;width:100%"><a
                      class="ShowCard-show"
                      style="background-image:url( ${cover})"
                      >
                      <div class="ShowCard-default" aria-hidden="true">
                          <div class="ShowCard-wrapperDefault">
                              <div class="ShowCard-logoDefault">
                                  <div class="ImageFilter ShowCard-logo" style="position:relative;width:76%"><svg
                                          class="ImageFilter-svg"
                                          style="display:block;height:100%;width:100%;overflow:hidden">
                                          <filter id="filter-image-1621261158145035197664326339506"
                                              color-interpolation-filters="sRGB">
                                              <feColorMatrix type="matrix"
                                                  values="-1 0 0 0 1 0 -1 0 0 1 0 0 -1 0 1 0 0 0 1 0">
                                              </feColorMatrix>
                                          </filter>
                                          <image filter="url(#filter-image-1621261158145035197664326339506)"
                                              preserveAspectRatio="xMidYMid meet"
                                              xlink:href="${logo}"
                                              x="0" y="0" width="100%" height="100%"></image>
                                      </svg></div>
                              </div>
                              <div class="EyebrowComponent " aria-hidden="true"><svg width="22" height="16"
                                      class="EyebrowComponent-playIcon">
                                      <g fill="none" fill-rule="evenodd">
                                          <rect stroke="#FFF" stroke-width="1.01" x="0.5" y="0.5" width="21" height="15"
                                              rx="0.5"></rect>
                                          <path fill="#FFF" fill-rule="nonzero" d="M14 8l-5 3V5z"></path>
                                      </g>
                                  </svg><span class="Eyebrow EyebrowComponent-whiteText">${type}</span>
                              </div>
                          </div>
                          <div class="ShowCard-overlay"></div>
                      </div>
                      <div class="ShowCard-hover" aria-hidden="true">
                          <div class="ShowCard-hoverVideoWrapper">
                              <div class="Ratio ShowCard-hoverVideo" style="display:block">
                                  <div class="Ratio-ratio " style="height:0;position:relative;width:100%;padding-top:56.25%">
                                      <div class="Ratio-content "
                                          style="height:100%;left:0;position:absolute;top:0;width:100%">
                                          <video class="forContent" aria-hidden="true" autoplay="" playsinline="" muted="" loop="" src=""
                                              style="display:block;width:100%"></video>
                                          <div class="ShowCard-overlayVideo"></div><svg class="PlayIcon ">
                                              <g fill="#FFF" fill-rule="evenodd">
                                                  <path
                                                      d="M50 25c0 13.807-11.193 25-25 25S0 38.807 0 25 11.193 0 25 0s25 11.193 25 25z"
                                                      fill-opacity="0.3"></path>
                                                  <path
                                                      d="M19.75 15.433l16.211 9.36a.5.5 0 010 .866L19.75 35.018a.5.5 0 01-.75-.433V15.866a.5.5 0 01.75-.433z">
                                                  </path>
                                              </g>
                                          </svg>
                                      </div>
                                  </div>
                              </div>
                          </div>
                          <div class="ShowCard-hoverInfo">
                              <div class="ShowCard-logoHoverWrapper">
                                  <div class="ShowCard-logoHover"
                                      style="background-image:url(${logo});width:76%">
                                  </div>
                              </div>
                              <div class="ShowCard-hoverContent">
                                  <div class="ShowCard-hoverDescription">
                                      <p class="Text ShowCard-text">${text}</p>
                                  </div>
                              </div>
                              <div class="EyebrowComponent " aria-hidden="true"><svg width="22" height="16"
                                      class="EyebrowComponent-playIcon EyebrowComponent-playIcon--black">
                                      <g fill="none" fill-rule="evenodd">
                                          <rect stroke="#FFF" stroke-width="1.01" x="0.5" y="0.5" width="21" height="15"
                                              rx="0.5"></rect>
                                          <path fill="#FFF" fill-rule="nonzero" d="M14 8l-5 3V5z"></path>
                                      </g>
                                  </svg><span class="Eyebrow ">${type}</span></div>
                          </div>
                      </div>
                  </a></div>
          </div>
          <div id="jq1-feedback-${i}" class="feedback"></div>
      </div>
      `;
      }
      result += card;
    }
    cardsWrapper.innerHTML += result;
}

function addVideo(e) {
  const el = e;
  const index = Array.from(
    document.querySelectorAll(".Ratio.ShowCard")
  ).indexOf(el);

  e.querySelector(".forContent").setAttribute(
    "src",
    `cards/content/${cards[index].content}`
  );
}
function closeVideo(e) {
  const el = e;
  const index = Array.from(
    document.querySelectorAll(".Ratio.ShowCard")
  ).indexOf(el);
  e.querySelector(".forContent").setAttribute("src", ` `);
}

function changeCategory(e) {
  const all = document.querySelector("#tabs-1621963902276-tab-0");
  const watch = document.querySelector("#tabs-1621963902276-tab-1");
  const listen = document.querySelector("#tabs-1621963902276-tab-2");
  const cardDivs = document.querySelectorAll(".Ratio.ShowCard");
  if (e == all) {
    all.className = "Tabs-tab Tabs-tab--dark Tabs-tab--active";
    watch.className = "Tabs-tab Tabs-tab--dark";
    listen.className = "Tabs-tab Tabs-tab--dark";
    showCategory("all");
  } else if (e == watch || e.innerText == "Watch") {
    watch.className = "Tabs-tab Tabs-tab--dark Tabs-tab--active";
    all.className = "Tabs-tab Tabs-tab--dark";
    listen.className = "Tabs-tab Tabs-tab--dark";
    showCategory("watch");
  } else {
    listen.className = "Tabs-tab Tabs-tab--dark Tabs-tab--active";
    watch.className = "Tabs-tab Tabs-tab--dark";
    all.className = "Tabs-tab Tabs-tab--dark";
    showCategory("listen");
  }
  function showCategory(s) {
    cardDivs.forEach((cardDiv) => {
      cardDiv.removeAttribute("style");

      if (
        s == "listen" &&
        cardDiv.querySelector(".Eyebrow").innerText != "PODCAST"
      ) {
        cardDiv.setAttribute("style", "display:none");
      }
      if (
        s == "watch" &&
        cardDiv.querySelector(".Eyebrow").innerText == "PODCAST"
      ) {
        cardDiv.setAttribute("style", "display:none");
      }
    });
  }
}

function openPopup(e) {
  document.querySelector("html").className = "noScroll";
  document.querySelector("body").className = "noScroll";
  const el = e;
  const index = Array.from(
    document.querySelectorAll(".Ratio.ShowCard")
  ).indexOf(el);

  document.querySelector(".popup-bottom").innerHTML = `
    <img src="cards/logo/${cards[index].logo}" class="popup-logo">
    <p class="popup-text">${cards[index].text}</p>`;
  if (cards[index].type != "podcast") {
    document.querySelector(".popup-top #my-video").style.display = "flex";
    document.querySelector(".green-audio-player").style.display = "none";

    document
      .querySelector(".popup-top video")
      .setAttribute("src", `cards/real/${cards[index].real}`);
  } else {
    document
      .querySelector(".green-audio-player audio")
      .setAttribute("src", `cards/real/${cards[index].real}`);

    document.querySelector(".popup-top picture").innerHTML = `
<source srcset="cards/content/${cards[index].content}"
media="(min-width: 600px)">
<img src="cards/cover/${cards[index].cover}" />

`;
    document.querySelector(".green-audio-player").style.display = "flex";

    document.querySelector(".popup-top  #my-video").style.display = "none";
  }
  document.querySelector(".popup").style.display = "flex";
}

function closePopup() {

  document.querySelectorAll("video").forEach((e) => {
    e.pause();
    playPause.attributes.d.value = "M18 12L0 24V0";
    player.currentTime = 0;
    document.querySelector(".progress").setAttribute("style","width: 0%;");
  });
  document
  .querySelector(".green-audio-player audio")
  .setAttribute("src","");
  document.querySelector(".popup").style.display = "none";
  document.querySelector("html").className =
    " csspositionsticky no-touchevents";
  document.querySelector("body").className = "";
}

function getMovieId(card) {
  return card.type + "__" + card.cover + "__" + card.real;
}

function likeMovie(event, cardIndex) {
    console.log('here1 ');
    event.stopPropagation();

    const card = cards[cardIndex];
    const vote = !card.liked;
    $.ajax({
      url: "api.jsp",
      method: "POST",
      data: {"action": "like", "vote": vote, "movieId": getMovieId(card)},
      dataType: "json"
    }).done((res) => {
        if (res.data == 1) {
            card.like++;
            card.liked = true;
        } else if (res.data == -1) {
            card.like--;
            card.liked = false;
        } else if (res.data == 2) {
            card.like++;
            card.liked = true;
            card.dislike--;
            card.disliked = false;
        }
        let e1 = document.querySelector(`#jq-like-${cardIndex}`);
        if (card.liked === true) {
            e1.className = 'like active';
            document.getElementById("likeUnlike"+cardIndex).src  = 'static/img/like-on.svg';
        } else {
            e1.className = 'like';
            document.getElementById("likeUnlike"+cardIndex).src  = 'static/img/like-off.svg';
        }
        e1.querySelector('.jq-count').innerHTML = card.like;

        e1 = document.querySelector(`#jq-dislike-${cardIndex}`);
        e1.className = 'dislike';
        e1.querySelector('.jq-count').innerHTML = card.dislike;

    }).fail(() => {
        alert('There is some error, please try again later');
    });

}

function dislikeMovie(event, cardIndex) {
    event.stopPropagation();

    const card = cards[cardIndex];
    const vote = !card.disliked;
    $.ajax({
      url: "api.jsp",
      method: "POST",
      data: {"action": "dislike", "vote": vote, "movieId": getMovieId(card)},
      dataType: "json"
    }).done((res) => {
        if (res.data == 1) {
            card.dislike++;
            card.disliked = true;
        } else if (res.data == -1) {
            card.dislike--;
            card.disliked = false;
        } else if (res.data == 2) {
            card.dislike++;
            card.disliked = true;
            card.like--;
            card.liked = false;
        }
        let e1 = document.querySelector(`#jq-dislike-${cardIndex}`);
        if (card.disliked) {
            e1.className = 'dislike active';
        } else {
            e1.className = 'dislike';
        }
        e1.querySelector('.jq-count').innerHTML = card.dislike;

        e1 = document.querySelector(`#jq-like-${cardIndex}`);
        e1.className = 'like';
        e1.querySelector('.jq-count').innerHTML = card.like;

    }).fail(() => {
        alert('There is some error, please try again later');
    });
}

function commentMovie(event, cardIndex) {
    event.stopPropagation();
    openMvModal();
    const card = cards[cardIndex];
    const movieId = getMovieId(card);
    $.ajax({
      url: "api.jsp",
      method: "POST",
      data: {"action": "getcomments", "movieId": movieId},
      dataType: "json"
    }).done((res) => {
        card.commentList = res.data;
        let html = `<div class="comment-box">
        <div>
            <textarea class="txt-input" rows="4" cols="40" placeholder="Add comment" id="feedback-comment-box"></textarea>
            <input class = "btn" type="button" onclick="addComment(${cardIndex}, '${movieId}')" value="Add">
        <div>
        <ul class="comments">`;
        res.data.forEach(c => {
            html += `
            <li class="comment">
                <span class="uname">${c.username}: </span> <span class="text">${c.comment}</span> <span class="date">${c.created}</span>
                ${c.owner ? `<span class = "delete" onclick="deleteComment(${cardIndex}, ${c.id})">x</span>`: ''}
            </li>
            `;
        });
        html += '</ul></div>';
        addContentMvModal(html);
    }).fail(() => {
        alert('There is some error, please try again later');
    });
}


function addComment(cardIndex, movieId) {
    const card = cards[cardIndex];
    let comment = document.querySelector('#feedback-comment-box').value;
    if(!comment || !(comment = comment.trim())) {
        alert('Please add a valid comment');
        return;
    }
    $.ajax({
      url: "api.jsp",
      method: "POST",
      data: {"action": "addcomment", "comment": comment, "movieId": movieId},
      dataType: "json"
    }).done((res) => {
        alert('Comment added successfully');
        card.comment++;
        card.commented = true;
        const e1 = document.querySelector(`#jq-comment-${cardIndex}`);
        e1.className = 'comment active';
        e1.querySelector('.jq-count').innerHTML = card.comment;

        closeMvModal();
    }).fail(() => {
        alert('There is some error, please try again later');
    });
}

function deleteComment(cardIndex, id) {
    if (!confirm("Are you sure to delete this comment")) {
        return;
    }

    const card = cards[cardIndex];
    $.ajax({
      url: "api.jsp",
      method: "POST",
      data: {"action": "deletecomment", "id": id},
      dataType: "json"
    }).done((res) => {
        alert('Comment deleted successfully');
        closeMvModal();
        card.comment--;
        const e1 = document.querySelector(`#jq-comment-${cardIndex}`);
        e1.querySelector('.jq-count').innerHTML = card.comment;
        const email = document.querySelector('#jqi-user-email').innerText.trim();
        if (card.commentList.filter(c => c.username == email).length <= 1) {
            card.commented = false;
            e1.className = 'comment';
        }

    }).fail(() => {
        alert('There is some error, please try again later');
    });
}