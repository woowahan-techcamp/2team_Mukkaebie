
import StoreUtil from "./Util.js";



export class Review {

  constructor(id) {
    this.setStarRating();
    this.getReview(id);
    this.postReview(id);
  }

  setStarRating() {
    let starContainer = document.getElementById('stars');
    let stars = Array.prototype.slice.call(starContainer.children);
    let totalStars = stars.length;
    let rated = document.getElementById('rated');

    starContainer.addEventListener('click', function(e) {
      let index = stars.indexOf(e.target);
      let count = totalStars - index;
      stars.forEach(el => el.classList.remove('is-selected'));
      e.target.classList.add('is-selected');
      rated.textContent = count;
    })
  }

  postReview(storeId) {
    let postButton = document.querySelector("#reviewTextInputBtn");
    postButton.addEventListener("click", function () {
      if (session != "비회원") {
        let reviewStars = document.querySelector("#rated");
        let selectedStar = reviewStars.textContent;
        let packet = {
          "storeId" : storeId,
          "review": {
            "content":StoreUtil.preventXss(document.querySelector("#reviewTextInput").value),
            "time":new Date().toLocaleString(),
            "user":session,
            "stars": selectedStar
          }
        };
        let xhr = new XMLHttpRequest();
        xhr.open("POST", SERVER_BASE_URL + "/stores/" + storeId, true);
        xhr.setRequestHeader('Content-Type', 'application/json');

        xhr.send(JSON.stringify(packet));
        xhr.onloadend = function () {
          StoreUtil.makeThxModal();
          this.getReview(storeId);
          document.querySelector("#reviewTextInput").value = "";
        }.bind(this);
      } else {
        StoreUtil.makeLoginRequiredModal();
      }
    }.bind(this));
  }

  getReview(id) {

    StoreUtil.ajaxGet(SERVER_BASE_URL + "/stores/" + id, getReviewCb);

    function getReviewCb() {
      const response = JSON.parse(this.responseText);
      const renderTarget = document.querySelector("#reviewList");
      renderTarget.innerHTML = "";
      if (response[0].review !== []) {
        response[0].review.reverse().forEach(function (review) {
          if (review) {
            const userId = review.user;
            const createdDate = review.time;
            const reviewContent = StoreUtil.preventXss(review.content);
            const orangeStar = "★".repeat(review.stars);
            const greyStar = "★".repeat(5 - review.stars);
          }
          const tempGrab = document.querySelector("#reviewTemplate").text;
          const result = eval('`' + tempGrab + '`');
          renderTarget.innerHTML += result;
        })
      }
    }
  }
}