
import StoreUtil from "./Util.js"



export class MKBComment {

  constructor(storeId, topThreeList) {
    this.makeMKBModal(storeId, topThreeList);

    this.getComment(storeId, topThreeList)
        .then(this.renderContent);

    this.sendImage(storeId, topThreeList)
            .then(this.setProfilePics)
            .then(this.postComment)
            .then(this.applyChange)
  }

  makeMKBModal(id) {

    let modal = document.querySelector('#mkbModal');
    let modalBtn = Array.from(document.querySelectorAll(".mkbProfileImgs"));
    let closeBtn = document.querySelector(".mkbModalClose");


    modalBtn.forEach(function (circle) {
      circle.addEventListener("click", function (event) {

        function getResponse() {
          return new Promise(function (resolve) {
            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
              if (this.readyState == 4 && this.status == 200) {
                const response = JSON.parse(this.responseText);
                resolve(response)
              }
            };
            xhr.open("GET", SERVER_BASE_URL + "/stores/" + id, true);
            xhr.send();
          })
        }

        const renderModal = (res) => {
          document.querySelector(".mkbEdit").innerText = "수정";
          if (this.attributes["data-user"]["value"] != session) {
            document.querySelector(".mkbEdit").style.display = "none";
          }
          else{
            document.querySelector(".mkbEdit").style.display = "block";
          }
          const previewTarget = document.querySelector(".mkbImgPreview");
          previewTarget.style.backgroundImage = event.target.style.backgroundImage;
          const mkbResponse = res[0]["mkb"] ? res[0]["mkb"] : [];
          let clickedUser = "";
          if (this.attributes["data-user"] != undefined || this.attributes["data-user"] != null) {
            let clickedUser = this.attributes["data-user"]["value"];
            let clickedMkb = [];

            let clickeMkbData = mkbResponse.filter(function (mkb) {
              return mkb["userId"] == clickedUser;
            });
            if (clickeMkbData.length > 0) {
              clickedMkb = clickeMkbData[clickeMkbData.length - 1];
            }

            if (clickedMkb) {
              document.getElementById("commentTextInput")["value"] = clickedMkb["mkbComment"];
            }
            else {
              document.getElementById("commentTextInput")["value"] = "";
            }
            const mkbComment = document.querySelector("#mkbComment");
            const mkbCommentUserId = document.querySelector("#mkbCommentUserId");
            const commentUser = document.querySelector(".commentWriteBox p");

            commentUser.innerText = clickedUser;
            commentUser.setAttribute("value", this.attributes["value"]["value"]);
            if (clickedUser === ""){
              mkbComment.innerText = "먹깨비 없음";
            }
            else if (clickedMkb["mkbComment"] == undefined) {
              mkbComment.innerText = "우하하 나는 먹깨비다!";
            } else {
              mkbComment.innerText = clickedMkb["mkbComment"];
            }
            mkbCommentUserId.innerText = clickedUser;
          }
        }
        getResponse().then(renderModal);
        modal.style.display = "block";
        setTimeout(function () {
          modal.style.opacity = "1";
        }, 200)
      });
    })

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

  getComment(id, top3List) {
    return new Promise(function (resolve) {
      let xhr = new XMLHttpRequest();
      xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
          const response = JSON.parse(this.responseText);
          const renderTarget = document.querySelector("#mkbComment");
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

          resolve(finalMkbList, id);
        }
      };
      xhr.open("GET", SERVER_BASE_URL + "/stores/" + id, true);
      xhr.send();
    });
  }

  renderContent(finalMkbList, id){
    const mkbLevelList = ["gold", "silver", "bronze"];
    const mkbOutsideCommentId = document.querySelector("#mkbCommentOutsideId");
    const mkbOutsideCommentMsg = document.querySelector("#mkbCommentOutsideMsg");

    finalMkbList.forEach(function(comment, idx){
      const mkbLevel = mkbLevelList[idx];
      const profilePicSmall = document.querySelector("." + mkbLevel + "Img");

      if (typeof(comment) === "string") {
        profilePicSmall.setAttribute("data-user", comment);
        profilePicSmall.style.backgroundImage = "url('" + DEFAULT_PROFILE_IMG + "')";
        if (comment === "") {
          mkbOutsideCommentId.innerHTML = "大 먹깨비 공석";
        }

      } else {
        profilePicSmall.setAttribute("data-user", comment["userId"]);
        profilePicSmall.style.backgroundImage = "url('" + comment['imgUrl'] + "')";
      }
      if (mkbLevel === "gold") {


        if (typeof(comment) === "string") {
          mkbOutsideCommentId.innerHTML = comment;
          mkbOutsideCommentMsg.innerHTML = "우하하! 나는 먹깨비다";
        }
        else{mkbOutsideCommentMsg.innerHTML = comment["mkbComment"];
          mkbOutsideCommentId.innerHTML = comment["userId"];}

      }
      StoreUtil.setAttributes(profilePicSmall, {"value": mkbLevel,"data-store":id})
    });
  }

  // init(id){
  //
  //   const form = document.getElementById('file-form');
  //
  //   form.onsubmit = function () {
  //     this.sendImage()
  //         .then(this.setProfilePics)
  //         .then(this.postComment.bind(null, id))
  //         .then(this.applyChange)
  //   }


    // const uploadButton = document.getElementById("upload-button");
    //
    // uploadButton.addEventListener("click", function () {
    //
    // })
  // }


  // sendImage(storeId, topThreeList) {
  //   return new Promise(function (resolve) {
  //
  //     const sendImageCb = function(){
  //       const res = JSON.parse(this.responseText);
  //       resolve({
  //         "imgUrl":IMAGE_SERVER_GET +res["filename"],
  //         "storeId":storeId,
  //         "topThreeList" : topThreeList
  //       });
  //     };
  //
  //     const formData = new FormData();
  //     const fileSelect = document.getElementById('file-select');
  //     const file = fileSelect.files[0];
  //     formData.append('profileImage', file);
  //
  //     if (file != undefined) {
  //       StoreUtil.ajaxPostWithCb(IMAGE_SERVER_POST, formData, sendImageCb);
  //     } else {
  //       resolve({
  //         "imgUrl": DEFAULT_PROFILE_IMG,
  //         "storeId":storeId,
  //         "topThreeList" : topThreeList
  //       });
  //     }
  //   });
  // }

  sendImage(storeId, topThreeList) {
    return new Promise(function (resolve) {
      const form = document.getElementById('file-form');
      const fileSelect = document.getElementById('file-select');

      form.onsubmit = function (event) {
        event.preventDefault();
        const file = fileSelect.files[0];
        if (file != undefined) {
          const formData = new FormData();
          formData.append('profileImage', file);
          document.querySelector("#mkbModal").style.opacity = 0;
          setTimeout(function () {
            document.querySelector("#mkbModal").style.display = "none";
            document.querySelector(".logInRequired").classList.remove("mkbShow");
          }, 1000);


          const xhr = new XMLHttpRequest();
          xhr.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
              const res = JSON.parse(this.responseText);
              resolve({
                "imgUrl":IMAGE_SERVER_GET +res["filename"],
                "storeId":storeId,
                "topThreeList" : topThreeList
              });
            }
          }
          xhr.open('POST', IMAGE_SERVER_POST);
          xhr.send(formData);
        } else {
          resolve({
           "imgUrl": DEFAULT_PROFILE_IMG,
           "storeId":storeId,
           "topThreeList" : topThreeList
         });
        }
      }
    })
  }


  setProfilePics(inputObj){

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
        "storeId" : inputObj["storeId"],
        "mkb": {
          "mkbComment" : document.querySelector("#commentTextInput").value,
          "time" : new Date().toLocaleString(),
          "userId": targetCircle["innerText"],
          "imgUrl": inputObj["imgUrl"]
        }
      };
      StoreUtil.ajaxPost(SERVER_BASE_URL + "/stores/mkb/" + inputObj["storeId"], JSON.stringify(packet));
      resolve(inputObj);
    });
  }

  applyChange(inputObj){
    const imgUrl = inputObj["imgUrl"];
    const targetLevel = inputObj["targetLevel"];
    console.log(targetLevel);
    const targetLevelImg = document.querySelector("." + targetLevel + "Img");
    document.querySelector("#mkbComment").innerText = document.querySelector("#commentTextInput").value;

    if (targetLevel === "gold") {
      document.querySelector("#mkbCommentOutsideMsg").innerText = document.querySelector("#commentTextInput").value;
    }

    // targetLevelImg.style.backgroundImage = "url('" + inputObj["imgUrl"] + "')";

    // const mkbComment = new MKBComment(inputObj["storeId"], inputObj["topThreeList"]);

  }



}