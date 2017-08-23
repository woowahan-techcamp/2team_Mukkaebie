




export class Review {

  constructor(id) {
    this.getReview(id);
    this.postReview(id);

  }

  postReview(id) {
    let theButton = document.querySelector("#reviewTextInputBtn");

    theButton.addEventListener("click", function () {
      let reviewStars = document.querySelector(".reviewStarSelect");
      let selectedStar = reviewStars.options[reviewStars.selectedIndex].value;
      let packet = {"review": {}};
      packet["storeId"] = id;
      packet.review["content"] = document.querySelector("#reviewTextInput").value;
      packet.review["time"] = new Date().toLocaleString();
      packet.review["user"] = "ygtech";
      packet.review["stars"] = selectedStar;


      let xhr1 = new XMLHttpRequest();
      xhr1.open("POST", SERVER_BASE_URL + "/stores/" + id, true);
      xhr1.setRequestHeader('Content-Type', 'application/json');

      xhr1.send(JSON.stringify(packet));
      xhr1.onloadend = function () {
        alert("소중한 리뷰 감사합니다.");
        this.getReview(id);
        document.querySelector("#reviewTextInput").value = "";
      }.bind(this);
    }.bind(this));
  }

  getReview(id) {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
      if (this.readyState == 4 && this.status == 200) {
        const response = JSON.parse(this.responseText);
        const renderTarget = document.querySelector("#reviewList");

        renderTarget.innerHTML = "";

        if (response[0].review !== []) {
          response[0].review.reverse().forEach(function (oneReview) {
            const review = oneReview;
            if (review) {
              const userId = review.user;
              const createdDate = review.time;
              const reviewContent = review.content;
              const orangeStar = "★".repeat(review.stars);
              const greyStar = "★".repeat(5 - review.stars);
            }
            const tempGrab = document.querySelector("#reviewTemplate").text;
            const result = eval('`' + tempGrab + '`');
            renderTarget.innerHTML += result;

          })
        }
      }
    };
    xhttp.open("GET", SERVER_BASE_URL + "/stores/" + id, true);
    xhttp.send();
  }
}