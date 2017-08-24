




export class MKBComment {

  constructor(id, top3List) {
    this.makeMKBModal(id, top3List);
    this.getComment(id, top3List);
    this.postImage().then(this.postComment.bind(null, id)).then(this.getComment.bind(null, id, top3List));
  }

  makeMKBModal(id, top3List) {

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

          if (this.attributes["data-user"]["value"] != session) {
            document.querySelector(".mkbEdit").style.display = "none";
          }
          else{
            document.querySelector(".mkbEdit").style.display = "block";
          }
          const previewTarget = document.querySelector(".mkbImgPreview");
          previewTarget.style.backgroundImage = event.target.style.backgroundImage;
          const mkbResponse = res[0]["mkb"];
          let clickedUser = "";
          if (this.attributes["data-user"] != undefined || this.attributes["data-user"] != null) {
            let clickedUser = this.attributes["data-user"]["value"];
            let clickedMkb;

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
            const commentUser = document.querySelector(".commentWriteBox p");
            commentUser.innerText = clickedUser;
            commentUser.setAttribute("value", this.attributes["value"]["value"]);
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

        let mkbLevelList = ["gold", "silver", "bronze"];
        finalMkbList.forEach(function (topBuyer, idx) {
          renderContent(topBuyer, mkbLevelList[idx]);
        });


        function renderContent(oneComment, mkbLevel) {
          const comment = oneComment;
          const profilePicSmall = document.querySelector("." + mkbLevel + "Img");
          if (typeof(comment) === "string") {
            profilePicSmall.setAttribute("data-user", comment);
            profilePicSmall.style.backgroundImage = "url('" + DEFAULT_PROFILE_IMG + "')";
          } else {
            profilePicSmall.setAttribute("data-user", comment["userId"]);
            profilePicSmall.style.backgroundImage = "url('" + comment['imgUrl'] + "')";
          }
          profilePicSmall.setAttribute("value", mkbLevel);
          profilePicSmall.setAttribute("data-store", id);
        }
      }
    };
    xhr.open("GET", SERVER_BASE_URL + "/stores/" + id, true);
    xhr.send();
  }


  postImage(id) {
    return new Promise(function (resolve) {
      const form = document.getElementById('file-form');
      const fileSelect = document.getElementById('file-select');
      const uploadButton = document.getElementById('upload-button');

      form.onsubmit = function (event) {
        event.preventDefault();
        uploadButton.innerHTML = '바꾸는 중...';
        const file = fileSelect.files[0];

        if (file != undefined) {
          const formData = new FormData();
          formData.append('profileImage', file);

          const xhr = new XMLHttpRequest();
          xhr.onreadystatechange = function () {
            if (this.readyState == 4 && this.status == 200) {
              const res = JSON.parse(this.responseText);

              resolve(IMAGE_SERVER_URL + "/uploads/" + res["filename"])
              const profilePic = document.querySelector(".mkbImgPreview");
              const targetCircle = document.querySelector(".commentWriteBox p")
              const profilePicSmall = document.querySelector("." + targetCircle.getAttribute("value") + "Img");
              profilePic.style.backgroundImage = "url('" + IMAGE_SERVER_URL + "/uploads/" + res["filename"] + "')";
              profilePicSmall.style.backgroundImage = "url('" + IMAGE_SERVER_URL + "/uploads/" + res["filename"] + "')";
            }
          }
          xhr.open('POST', IMAGE_SERVER_URL + '/profile/');

          xhr.onload = function () {
            if (xhr.status === 200) {
              uploadButton.innerHTML = 'Upload';
            } else {
              alert('An error occurred!');
            }
          };
          xhr.send(formData);
        } else {
          resolve(DEFAULT_PROFILE_IMG);
        }
      }
    })
  }

  postComment(id, imgUrl) {

    return new Promise(function (resolve) {

      let packet = {"mkb": {}};
      packet["storeId"] = id;
      packet.mkb["mkbComment"] = document.querySelector("#commentTextInput").value;
      packet.mkb["time"] = new Date().toLocaleString();
      const targetCircle = document.querySelector(".commentWriteBox p")
      packet.mkb["userId"] = targetCircle["innerText"];
      packet.mkb["imgUrl"] = imgUrl;


      let xhr = new XMLHttpRequest();
      xhr.open("POST", SERVER_BASE_URL + "/stores/mkb/" + id, true);
      xhr.setRequestHeader('Content-Type', 'application/json');

      xhr.send(JSON.stringify(packet));
      xhr.onloadend = function () {
        resolve(null);
        document.querySelector("#commentTextInput").setAttribute("value", "");
      }.bind(this)

    })
  }
}