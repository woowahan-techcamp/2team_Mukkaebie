import StoreUtil from "./Util.js";


export class MKBComment {

  constructor(storeId, topThreeList) {

    this.storeId = storeId;
    this.topThreeList = topThreeList;
    this.addMkbModalEventListener(storeId, topThreeList);


    this.sendImage(storeId, topThreeList)
        .then(this.setProfilePics)
        .then(this.postComment)
        .then(this.applyChange)
  }

  initialRendering() {
    this.resetProfile();
    this.getComment(this.storeId, this.topThreeList)
        .then(this.renderMkbPage);
  }

  getStoreInfoForModal(storeId) {
    return new Promise(function (resolve) {
      StoreUtil.ajaxGet(SERVER_BASE_URL + "/stores/" + storeId, getStoreInfoForModalCb);

      function getStoreInfoForModalCb() {
        const response = JSON.parse(this.responseText);
        resolve(response)
      }
    })
  }

  setModalTextarea(clickedMkb) {
    const modalTextarea = document.getElementById("commentTextInput");
    if (clickedMkb) {
      modalTextarea["value"] = clickedMkb["mkbComment"];
    }
    else {
      modalTextarea["value"] = "";
    }
  }

  setModalIdAndMsg(clickedMkb, clickedUser, clickedScope) {
    const mkbComment = document.querySelector("#mkbComment");
    const mkbCommentUserId = document.querySelector("#mkbCommentUserId");
    const commentUser = document.querySelector(".commentWriteBox p");

    commentUser.innerText = clickedUser;
    commentUser.setAttribute("value", clickedScope.attributes["value"]["value"]);
    if (clickedUser === "") {
      mkbComment.innerText = "먹깨비 없음";
    }
    else if (clickedMkb["mkbComment"] == undefined) {
      mkbComment.innerText = "우하하 나는 먹깨비다!";
    } else {
      mkbComment.innerText = clickedMkb["mkbComment"];
    }
    mkbCommentUserId.innerText = clickedUser;
  }

  controllEditButton(clickedScope) {
    if (clickedScope.attributes["data-user"]["value"] != session) {
      StoreUtil.changeDisplay(".mkbEdit", "none");

    }
    else {
      StoreUtil.changeDisplay(".mkbEdit", "block");
      document.querySelector(".mkbEdit").innerText = "수정";
    }
  }

  setModalImg(event) {
    const previewTarget = document.querySelector(".mkbImgPreview");
    previewTarget.style.backgroundImage = event.target.style.backgroundImage;
  }

  processMkbResponse(clickedScope, mkbResponse) {
    let clickedUser = (clickedScope.attributes["data-user"]["value"]) ? clickedScope.attributes["data-user"]["value"] : "";
    let clickedMkbData = mkbResponse.filter(function (mkb) {
      return mkb["userId"] == clickedUser;
    });
    let recentMkbData = (clickedMkbData.length > 0) ? clickedMkbData[clickedMkbData.length - 1] : [];
    return {"clickedUser": clickedUser, "recentMkbData": recentMkbData}
  }

  addMkbModalEventListener(id) {
    let modal = document.querySelector('#mkbModal');
    let modalButtons = Array.from(document.querySelectorAll(".mkbProfileImgs"));
    const that = this;
    this.modalCloseButton(modal);

    modalButtons.forEach(function (circle) {
      circle.addEventListener("click", function (event) {
        const renderModal = (res) => {
          const clickedScope = this;
          const mkbResponse = res[0]["mkb"] ? res[0]["mkb"] : [];
          StoreUtil.showModal('#mkbModal');
          that.controllEditButton(clickedScope);
          that.setModalImg(event);

          if (this.attributes["data-user"] != undefined || this.attributes["data-user"] != null) {
            let clickedUser = that.processMkbResponse(clickedScope, mkbResponse)["clickedUser"];
            let recentMkbData = that.processMkbResponse(clickedScope, mkbResponse)["recentMkbData"];
            that.setModalTextarea(recentMkbData);
            that.setModalIdAndMsg(recentMkbData, clickedUser, clickedScope)
          }
        };
        that.getStoreInfoForModal(id).then(renderModal)
      });
    });
  }

  modalCloseButton(modal) {
    const closeBtn = document.querySelector(".mkbModalClose");
    closeBtn.addEventListener("click", function () {
      const editBox = document.querySelector(".logInRequired");
      const editBtn = document.querySelector(".mkbEdit");
      modal.style.opacity = "0";

      setTimeout(function () {
        modal.style.display = "none";
        editBox.classList.remove("mkbShow");
        editBtn.classList.remove("mkbHide");
      }, 200)
    });
  }

  getComment(storeId, top3List) {
    const that = this;
    return new Promise(function (resolve) {
      function getCommentCb() {
        const response = JSON.parse(this.responseText);
        let targetArr = (response[0].mkb) ? response[0].mkb : [];
        let finalMkbList = [];
        top3List.forEach(function (topBuyer) {
          let oneBuyer = targetArr.filter(function (mkbRow) {
            return mkbRow.userId == topBuyer;
          });
          if (oneBuyer.length > 0) {
            finalMkbList.push(oneBuyer[oneBuyer.length - 1]);
          } else {
            finalMkbList.push(topBuyer);
          }
        });
        resolve({"finalMkbList": finalMkbList, "storeId": storeId, "that": that});
      }

      StoreUtil.ajaxGet(SERVER_BASE_URL + "/stores/" + storeId, getCommentCb)

    });
  }

  renderGoldMkb (comment, mkbOutsideCommentId, mkbOutsideCommentMsg){
    if (typeof(comment) === "string") {
      mkbOutsideCommentId.innerHTML = comment;
      mkbOutsideCommentMsg.innerHTML = "우하하! 나는 먹깨비다";
      if (comment === "") {
        mkbOutsideCommentId.innerHTML = "大 먹깨비 공석";
      }
    }
    else {
      mkbOutsideCommentMsg.innerHTML = comment["mkbComment"];
      mkbOutsideCommentId.innerHTML = comment["userId"];
    }
  }

  renderThreeMkbImgs(comment, profilePicSmall){
    if (typeof(comment) === "string") {
      profilePicSmall.setAttribute("data-user", comment);
      profilePicSmall.style.backgroundImage = "url('" + DEFAULT_PROFILE_IMG + "')";
    } else {
      profilePicSmall.setAttribute("data-user", comment["userId"]);
      profilePicSmall.style.backgroundImage = "url('" + comment['imgUrl'] + "')";
    }
  }

  renderMkbPage(inputObj) {
    const mkbLevelList = ["gold", "silver", "bronze"];
    const mkbOutsideCommentId = document.querySelector("#mkbCommentOutsideId");
    const mkbOutsideCommentMsg = document.querySelector("#mkbCommentOutsideMsg");
    const that = inputObj["that"];

    inputObj["finalMkbList"].forEach(function (comment, idx) {
      const mkbLevel = mkbLevelList[idx];
      const profilePicSmall = document.querySelector("." + mkbLevel + "Img");
      that.renderThreeMkbImgs(comment, profilePicSmall);

      if (mkbLevel === "gold") {
        that.renderGoldMkb(comment, mkbOutsideCommentId, mkbOutsideCommentMsg);
      }
      StoreUtil.setAttributes(profilePicSmall, {"value": mkbLevel, "data-store": inputObj["storeId"]})
    });
  }


  sendImage(storeId, topThreeList) {
    return new Promise(function (resolve) {
      const form = document.getElementById('file-form');
      const fileSelect = document.getElementById('file-select');

      form.onsubmit = function (e) {
        e.preventDefault();
        const file = fileSelect.files[0];
        let resolveObj = {
          "imgUrl": DEFAULT_PROFILE_IMG,
          "storeId": storeId,
          "topThreeList": topThreeList
        };

        if (file != undefined) {
          const formData = new FormData();
          formData.append('profileImage', file);

          StoreUtil.ajaxPostWithCb(IMAGE_SERVER_POST, formData, sendImageCb);

          function sendImageCb() {
            const res = JSON.parse(this.responseText);
            resolveObj["imgUrl"] = IMAGE_SERVER_GET + res["filename"];
            resolve(resolveObj)
          }

        } else {
          resolve(resolveObj);
        }

        StoreUtil.changeOpacity("#mkbModal", "0");
        setTimeout(function () {
          StoreUtil.changeDisplay("#mkbModal", "none");
          StoreUtil.toggleEdit();
        }, 1000);
      }
    })
  }

  resetProfile(){
    const profileResetButton = document.querySelector("#resetProfile");
    const profilePic = document.querySelector(".mkbImgPreview");
    profileResetButton.addEventListener("click", function () {
      document.querySelector("#file-form input").value = "";
    });
  }


  setProfilePics(inputObj) {

    return new Promise(function (resolve) {
      const profilePic = document.querySelector(".mkbImgPreview");
      const clickedMkb = document.querySelector(".commentWriteBox p");
      const profilePicSmall = document.querySelector("." + clickedMkb.getAttribute("value") + "Img");
      inputObj["targetLevel"] = clickedMkb.getAttribute("value");
      const uploadedPicUrl = "url('" + inputObj["imgUrl"] + "')";
      profilePic.style.backgroundImage = uploadedPicUrl;
      profilePicSmall.style.backgroundImage = uploadedPicUrl;
      resolve(inputObj);
    });
  }

  postComment(inputObj) {
    return new Promise(function (resolve) {

      const targetCircle = document.querySelector(".commentWriteBox p");
      const targetLevel = targetCircle.getAttribute("value");

      const commentTextInput = document.querySelector("#commentTextInput");
      const packet = {
        "storeId": inputObj["storeId"],
        "mkb": {
          "mkbComment": document.querySelector("#commentTextInput").value,
          "time": new Date().toLocaleString(),
          "userId": targetCircle["innerText"],
          "imgUrl": inputObj["imgUrl"]
        }
      };
      StoreUtil.ajaxPost(SERVER_BASE_URL + "/stores/mkb/" + inputObj["storeId"], JSON.stringify(packet));
      resolve(inputObj);
    });
  }

  applyChange(inputObj) {
    const imgUrl = inputObj["imgUrl"];
    const targetLevel = inputObj["targetLevel"];
    const targetLevelImg = document.querySelector("." + targetLevel + "Img");
    document.querySelector("#mkbComment").innerText = document.querySelector("#commentTextInput").value;

    if (targetLevel === "gold") {
      document.querySelector("#mkbCommentOutsideMsg").innerText = document.querySelector("#commentTextInput").value;
    }
    const newMkb = new MKBComment(inputObj["storeId"], inputObj["topThreeList"])
  }
}