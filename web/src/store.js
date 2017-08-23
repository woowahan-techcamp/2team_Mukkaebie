class TabUiWithAjax {

  constructor(inputObj) {
    this.nav = document.querySelector("#" + inputObj.containerName);
    this.selectedTabName = inputObj.selectedTabName;
    this.selectedTab = "." + inputObj.selectedTabName;
    this.generalTab = "." + inputObj.generalTabName;
    this.selectedContentName = inputObj.selectedContentName;
    this.selectedContent = "." + inputObj.selectedContentName;
    this.generalContentPrefix = inputObj.generalContentPrefix;
    this.tabId = [];
    this.cache = [];
    this.baseUrl = inputObj.baseUrl;
    this.init();
  }

  init() {
    const firstTab = document.querySelector(this.selectedTabName);
    const firstContent = document.querySelector(this.selectedContentName);
    this.tabDataCollect();
    //this.tabAjaxData(firstTab.id, 1, firstContent);
    this.nav.addEventListener("click", function () {
      this.tabOperate(event)
    }.bind(this), false);
  }

  tabDataCollect() {
    const tempTab = document.querySelectorAll(this.generalTab);
    for (const tab of tempTab) {
      this.tabId.push(tab.id);
      this.cache.push(0);
    }
  }

  tabOperate(event) {
    let currentTabId = "";
    //선택된 탭표시 제거 및 event delegation targetting
    document.querySelector(this.selectedTab).classList.remove(this.selectedTabName);
    if (event.target && event.target.tagName === "LI") {
      event.target.classList.add(this.selectedTabName);
      currentTabId += event.target.id;
    } else {
      let correctedTarget = document.querySelector("#mkbTab");
      correctedTarget.classList.add(this.selectedTabName);
      currentTabId += correctedTarget.id;
    }

    const targetContentName = this.generalContentPrefix + currentTabId;
    const targetContent = document.querySelector(targetContentName);
    document.querySelector(this.selectedContent).classList.remove(this.selectedContentName);
    targetContent.classList.add(this.selectedContentName);
    const pageNum = this.tabId.indexOf(currentTabId) + 1;
    //this.tabAjaxData(event.target.id, pageNum, targetContent)
  }

  // 후에 사용 예정
  // tabAjaxData(tab, pageNum, targetContent) {
  // 	if (this.cache[pageNum-1] === 0 ) {
  // 		const tabAjax = new Ajax( this.baseUrl + "best/" + tab , function(){
  // 			const cardResult = JSON.parse(this.responseText);
  // 			const tempGrab = document.querySelector("#bfmain-tabui-card-temp");
  // 			const cardTemp = Handlebars.compile(tempGrab.innerHTML);
  // 			targetContent.innerHTML = cardTemp(cardResult);
  // 		});
  // 		this.cache[pageNum-1] += 1;
  // 		this.cacheCount();
  // 	}
  // }

  cacheCount() {
    const result = [];
    this.tabId.forEach((key, idx) => {
      result.push({
        name: key,
        click: this.cache[idx]
      })
    })
    ;
  }
}


class Foldable {
  constructor(level1Class) {
    this.level1 = document.getElementsByClassName(level1Class);
    this.makeFoldable();
  }

  makeFoldable() {
    for (let i = 0; i < this.level1.length; i++) {
      this.level1[i].onclick = function () {
        /* Toggle between adding and removing the "active" class,
         to highlight the button that controls the panel */
        this.classList.toggle("active");

        /* Toggle between hiding and showing the active panel */
        let level2 = this.nextElementSibling;
        if (level2) {
          if (level2.style.maxHeight === "1500px") {
            level2.style.maxHeight = "0px";
          } else {
            level2.style.maxHeight = "1500px";
          }
        }
      }
    }
  }
}


class Review {

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


class MKBComment {

  constructor(id, top3List) {
    this.makeMKBModal(id, top3List);
    this.getComment(id, top3List);
    this.postImage().then(this.postComment.bind(null, id)).then(this.getComment.bind(null, id, top3List));
  }

  makeMKBModal (id, top3List) {

    let modal = document.querySelector('#mkbModal');
    let modalBtn = Array.from(document.querySelectorAll(".mkbProfileImgs"));
    let closeBtn = document.querySelector(".mkbModalClose");


    modalBtn.forEach(function (circle) {
      circle.addEventListener("click", function (event) {

        function getResponse() {
          return new Promise(function(resolve){
            let xhr = new XMLHttpRequest();
            xhr.onreadystatechange = function () {
              if (this.readyState == 4 && this.status == 200) {
                const response = JSON.parse(this.responseText);
                resolve(response)
              }
            };
            xhr.open("GET", SERVER_BASE_URL + "/stores/" + id , true);
            xhr.send();
          })
        }

        const renderModal = (res) => {

          const previewTarget = document.querySelector(".mkbImgPreview");
          previewTarget.style.backgroundImage = event.target.style.backgroundImage;
          const mkbResponse = res[0]["mkb"];
          let clickedUser = "";
          if (this.attributes["data-user"] != undefined || this.attributes["data-user"] != null){
            let clickedUser = this.attributes["data-user"]["value"];
            let clickedMkb;

            let clickeMkbData = mkbResponse.filter(function(mkb){
              return mkb["userId"] == clickedUser;
            });
            if ( clickeMkbData.length > 0){
              clickedMkb = clickeMkbData[clickeMkbData.length-1];
            }

            if (clickedMkb){
              document.getElementById("commentTextInput")["value"] = clickedMkb["mkbComment"];
            }
            else{
              document.getElementById("commentTextInput")["value"] = "";
            }
            const commentUser = document.querySelector(".commentWriteBox p");
            commentUser.innerText = clickedUser;
            commentUser.setAttribute("value",this.attributes["value"]["value"]);
          }
        }
        getResponse().then(renderModal);
        modal.style.display = "block";
        setTimeout(function () {
          modal.style.opacity = "1";
        }, 200)
      });
    })

    closeBtn.addEventListener("click", function(){
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

          let oneBuyer = targetArr.filter(function(mkbRow){

            return mkbRow.userId == topBuyer;
          });


          if ( oneBuyer.length > 0){
            finalMkbList.push(oneBuyer[oneBuyer.length-1]);
          } else {
            finalMkbList.push(topBuyer);
          }

        });

        let mkbLevelList = [ "gold","silver","bronze" ];
        finalMkbList.forEach(function (topBuyer, idx) {
          renderContent(topBuyer, mkbLevelList[idx]);
        });


        function renderContent(oneComment, mkbLevel) {
          const comment = oneComment;
          const profilePicSmall = document.querySelector("." + mkbLevel + "Img");
          if (typeof(comment) === "string"){
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
    return new Promise(function(resolve){
      const form = document.getElementById('file-form');
      const fileSelect = document.getElementById('file-select');
      const uploadButton = document.getElementById('upload-button');

      form.onsubmit = function(event) {
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
              const profilePicSmall = document.querySelector("."+ targetCircle.getAttribute("value") +"Img");
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

    return new Promise(function(resolve){

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

})}}


class Graph {
  constructor(storeId) {
    this.makeDonutgraph(storeId);
    this.podiumAnimate(storeId);
    this.storeId = storeId;
  }

  podiumAnimate(storeId) {
    let gold = document.querySelector('.gold .podium');
    gold.classList.add('goldAnimate');
    let goldOrders = document.querySelector('.gold .orders');
    goldOrders.classList.add('goldOrdersAnimate');
    let goldName = document.querySelector('.gold .name');
    goldName.classList.add('goldNameAnimate');

    let silver = document.querySelector('.silver .podium');
    silver.classList.add('silverAnimate');
    let silverOrders = document.querySelector('.silver .orders');
    silverOrders.classList.add('silverOrdersAnimate');
    let silverName = document.querySelector('.silver .name');
    silverName.classList.add('silverNameAnimate');

    let bronze = document.querySelector('.bronze .podium');
    bronze.classList.add('bronzeAnimate');
    let bronzeOrders = document.querySelector('.bronze .orders');
    bronzeOrders.classList.add('bronzeOrdersAnimate');
    let bronzeName = document.querySelector('.bronze .name');
    bronzeName.classList.add('bronzeNameAnimate');

    this.mkbLoad(storeId);
  }

  makeDonutgraph(storeId) {
    let xhr = new XMLHttpRequest();

    xhr.onload = function () {
      if (xhr.status === 200) {


        let orders = JSON.parse(xhr.responseText);
        let topMenu = {};

        for (let i = 0; i < orders.length; i++) {

          orders[i].content.forEach(function (ele) {
            if (ele in topMenu) {
              topMenu[ele] += 1;
            }
            else {
              topMenu[ele] = 1;
            }
          })

        }


        let items = Object.keys(topMenu).map(function (key) {
          return [key, topMenu[key]];
        });

        items.sort(function (first, second) {
          return second[1] - first[1];
        })

        let top5 = items.slice(0, 5);


        let datetimeContent = '';
        let circleContent = '';
        let colorArr = ['rgb(110,239,192)', 'rgb(42,193,188)', 'rgb(130,198,255)', 'rgb(251,136,136)', 'rgb(251,229,136)'];
        let total = 0;
        let share = 0;
        let reverse = 0;
        let offset = 25;
        let totalLength = 0;
        let labelText = document.querySelectorAll('.labelText');


        for (let key in topMenu) {
          total += topMenu[key];
        }

        for (let i = 0; i < top5.length; i++) {
          share = Number(top5[i].toString().split(',')[1]) / total * 100;
          reverse = 100 - share;
          circleContent +=
              `<circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="${colorArr[i]}" stroke-width="8" stroke-dasharray="${share} ${reverse}" stroke-dashoffset="${offset}">`;
          circleContent +=
              `<title class="donut-segment-title">${top5[i].toString().split(',')[0]}</title>`;
          circleContent += `</circle>`;

          labelText[i] = '';
          labelText[i].innerHTML = top5[i].toString().split(',')[0] + ' ' + share.toFixed(2) + '%';
          totalLength = totalLength + share;
          offset = (100 - totalLength + 25) % 100;
          if (i == 4) {
            labelText[5].innerHTML = '';
            labelText[5].innerHTML = '기타 ' + (100 - totalLength).toFixed(2) + '%';
          }
        }

        let oldCircle = document.getElementsByClassName('donut-segment');
        let circleArr = Array.from(oldCircle);

        function clear() {
          let elems = document.querySelectorAll(".donut-segment");
          for (let i = elems.length - 1; i >= 0; i--) {
            let parent = elems[i].parentNode;
            parent.removeChild(elems[i]);
          }
        }

        clear();

        Date.prototype.format = function (f) {
          if (!this.valueOf()) return " ";

          let weekName = ["일요일", "월요일", "화요일", "수요일", "목요일", "금요일", "토요일"];
          let date = this;
          let hour = '';

          return f.replace(/(yyyy|yy|MM|dd|E|hh|mm|ss|a\/p)/gi, function ($1) {
            switch ($1) {
              case "yyyy":
                return date.getFullYear();
              case "yy":
                return (date.getFullYear() % 1000).zf(2);
              case "MM":
                return (date.getMonth() + 1).zf(2);
              case "dd":
                return date.getDate().zf(2);
              case "E":
                return weekName[date.getDay()];
              case "hh":
                return ((hour = date.getHours() % 12) ? hour : 12).zf(2);
              case "mm":
                return date.getMinutes().zf(2);
              case "ss":
                return date.getSeconds().zf(2);
              case "a/p":
                return date.getHours() < 12 ? "오전" : "오후";
              default:
                return $1;
            }
          });
        };

        String.prototype.string = function (len) {
          var s = '', i = 0;
          while (i++ < len) {
            s += this;
          }
          return s;
        };
        String.prototype.zf = function (len) {
          return "0".string(len - this.length) + this;
        };
        Number.prototype.zf = function (len) {
          return this.toString().zf(len);
        };


        let datetime = new Date().format("yyyy년 MM월 dd일 a/p hh시 mm분 ss초 기준");

        datetimeContent = `${datetime}`;
        let dateTarget = document.querySelector('.dateTab');
        dateTarget.innerHTML = datetimeContent;


        let svg = document.querySelector('svg');
        svg.insertAdjacentHTML('beforeend', circleContent);

      }
    };
    xhr.open('GET', SERVER_BASE_URL + '/orders/bystore/' + storeId, true);
    xhr.send(null);
  }

  mkbLoad(storeId) {
    let xhr = new XMLHttpRequest();
    xhr.onload = function () {
      if (xhr.status === 200) {
        let orders = JSON.parse(xhr.responseText);
        let rankers = {};
        for (let i = 0; i < orders.length; i++) {
          if (orders[i].buyerId in rankers) {
            rankers[orders[i].buyerId] += 1;
          } else {
            rankers[orders[i].buyerId] = 1;
          }
        }

        let items = Object.keys(rankers).map(function (key) {
          return [key, rankers[key]];
        });

        items.sort(function (first, second) {
          return second[1] - first[1];
        });

        let top3 = items.slice(0, 3);
        console.log(top3);
        let top3_name = document.querySelectorAll('.name');
        let top3_order = document.querySelectorAll('.orders');
        let top3UserList = [];
        for (let i = 0; i < top3.length; i++) {
          let name = top3[i].toString().split(",")[0];
          let order = top3[i].toString().split(",")[1];
          top3UserList.push(name);
          // top3_name[i].innerHTML = name;
          // top3_order[i].innerHTML = order;
        }
        let mkb = new MKBComment(storeId, top3UserList);
      }
    }
    xhr.open('GET', SERVER_BASE_URL + '/orders/bystore/' + storeId, true);
    xhr.send(null);
  }

}


class StoreList {

  constructor(cat) {
    this.getStoreList(cat);
  }

  getStoreList(cat) {
    let xhttp = new XMLHttpRequest();
    xhttp.onreadystatechange = function () {
      if (this.readyState == 4 && this.status == 200) {

        const response = JSON.parse(this.responseText);
        const layoutTarget = document.querySelector(".storeLayout");
        const category = response[0].category;
        const storeCount = response.length;
        layoutTarget.innerHTML =
            `<div class="m-x-3 m-b-2">
                홈 >	${category} | 서울 송파구 방이1동을 중심으로 총 ${storeCount}곳을 찾았습니다.
            </div>
            <div class="col-xs-12 storeCardRow"></div>
            <div class="load-button">더보기</div>
            <div class="spinner" style="display: none"></div>`;
        const renderTarget = document.querySelector(".storeCardRow");
        renderTarget.innerHTML = "";
        let size = 30;
        let spinner = document.querySelector('.spinner');
        response.slice(0, size).forEach(function (oneStore) {
          const store = oneStore;
          const storeId = store.storeId;
          const storeImg = store.storeImg;
          const storeName = store.storeName;
          const address = store.address;
          if(store.review) {
            const reviewCount = store.review.length;
          }
          const ratingCount = store.ratingCount;
          const ratingValue = store.ratingValue * 20;
          const tempGrab = document.querySelector("#storeListTemplate").text;
          const result = eval('`' + tempGrab + '`');
          renderTarget.innerHTML += result;
        })

        let loadMoreButton = document.querySelector('.load-button');


        if (response.length > 30) {
          loadMoreButton.style.display = 'block';
        }

        loadMoreButton.addEventListener('click', function () {
          let fadeInTarget = document.querySelectorAll('.fadeIn');
          let index = 0;
          let targetArr = [...fadeInTarget];
          targetArr.forEach(function () {
            targetArr[index].classList.remove("fadeIn");
            index++;
          });
          let result = '';
          size = 30;
          console.log(size);
          response.slice(size, size = size + 30).forEach(function (oneStore) {
            const store = oneStore;
            const storeId = store.storeId;
            const storeImg = store.storeImg;
            const storeName = store.storeName;
            const address = store.address;
            const reviewCount = store.review.length;
            const ratingCount = store.ratingCount;
            const ratingValue = store.ratingValue * 20;
            const tempGrab = document.querySelector("#storeListTemplate").text;
            result += eval('`' + tempGrab + '`');
          });

          loadFirst();

          function loadFirst() {
            loadMoreButton.style.display = 'none';
            spinner.style.display = 'block';

            setTimeout(function () {
              renderTarget.innerHTML += result;
              spinner.style.display = 'none';
            }, 1000);
          }
        });

        let scrollTimer, lastScrollFireTime = 0;


        window.addEventListener("scroll", function () {
          let minScrollTime = 500;
          let now = new Date().getTime();

          function processScroll() {

            let contentHeight = renderTarget.offsetHeight;
            let yOffset = window.pageYOffset;
            let y = yOffset + 300;
            if (loadMoreButton.style.display == 'none' && y >= contentHeight) {
              let fadeInTarget = document.querySelectorAll('.fadeIn');
              let index = 0;
              let targetArr = [...fadeInTarget];
              targetArr.forEach(function () {
                targetArr[index].classList.remove("fadeIn");
                index++;
              });
              let result = '';
              if (size !== 30 && size <= response.length) {
                response.slice(size, size = size + 30).forEach(function (oneStore) {
                  const store = oneStore;
                  const storeId = store.storeId;
                  const storeImg = store.storeImg;
                  const storeName = store.storeName;
                  const address = store.address;
                  const reviewCount = store.review.length;
                  const ratingCount = store.ratingCount;
                  const ratingValue = store.ratingValue * 20;
                  const tempGrab = document.querySelector("#storeListTemplate").text;
                  result += eval('`' + tempGrab + '`');
                });

                loadMore();

              }


              function loadMore() {
                spinner.style.display = 'block';
                setTimeout(function () {
                  renderTarget.innerHTML += result;
                  spinner.style.display = 'none';
                }, 1000);
              }

            }

          }

          if (!scrollTimer) {
            if (now - lastScrollFireTime > (3 * minScrollTime)) {
              processScroll();
              lastScrollFireTime = now;
            }
            scrollTimer = setTimeout(function () {
              scrollTimer = null;
              lastScrollFireTime = new Date().getTime();
              processScroll();
            }, minScrollTime);
          }

        });


        let clickedStore = document.querySelector(".storeCardRow");

        clickedStore.addEventListener("click", function (e) {
          if (e.target && e.target.className == "storeCard") {
            var realTarget = e.target;
          } else if (e.target.className == "col-xs-4") {
            var realTarget = e.target.children[0];
          } else if (e.target.className == 'col-xs-12') {
            var realTarget = e.target.children[0].children[0];
          } else {
            var realTarget = e.target.closest(".storeCard");
          }
          let storeInfo = new StoreInfo(realTarget.id);
        });
      }
    };
    xhttp.open("GET", SERVER_BASE_URL + "/stores/bycategory/" + cat, true);
    xhttp.send();

  }

}


class StoreInfo {

  constructor(id) {
    this.storeId = id;
    this.getStoreInfo(id).then(this.renderInfo.bind(null, id));
  }

  renderInfo(storeId, info) {

    const storeName = info.storeName;
    const address = info.address;
    const ratingValue = info.ratingValue * 20;
    const ratingCount = info.ratingCount;
    const minPrice = info.minPrice;
    const openHour = info.openHour;
    const telephone = info.telephone;
    const storeDesc = info.storeDesc;
    let menuObj = info.menu[0];

    let wholeMenuHtml = '';
    let menuUnits = '';

    for (let categoryKey in menuObj) {
      const menuArr = menuObj[categoryKey];
      menuUnits = '';
      for (let menuKey in menuArr) {
        const menuName = menuKey;
        const menuPrice = menuArr[menuKey];
        const tempGrab = document.querySelector('#menuUnitTemplate').text;
        menuUnits += eval('`' + tempGrab + '`');
      }
      wholeMenuHtml += `<div class="foldableLevel1"><h6>${categoryKey}</h6></div><div class="foldableLevel2">${menuUnits}</div>`
    }
    const tempGrab = document.querySelector('#storeDetailTemplate').text;
    const storeDetailHtml = eval('`' + tempGrab + '`');
    const layoutTarget = document.querySelector('.storeLayout');
    layoutTarget.innerHTML = storeDetailHtml;
    const renderMenu = layoutTarget.querySelector('.foldableMenu');
    renderMenu.innerHTML = wholeMenuHtml;

    let tab = new TabUiWithAjax(
        {
          containerName: "storeTabWrapper",
          selectedTabName: "selectedTab",
          selectedContentName: "selectedContent",
          generalTabName: "storeTab",
          generalContentPrefix: "#cont-",
          baseUrl: ""
        }
    );
    let graph = new Graph(storeId);
    let review = new Review(storeId);
    let foldable = new Foldable("foldableLevel1");
    StoreUtil.makeOrder(storeId);
    StoreUtil.makeModal();
    let cart = new Cart();

  }

  getStoreInfo(id) {
    return new Promise(function (resolve) {
      let xhr = new XMLHttpRequest();
      xhr.onreadystatechange = function () {
        if (this.readyState == 4 && this.status == 200) {
          const response = JSON.parse(this.responseText);
          resolve(response[0], id);
        }
      };
      xhr.open("GET", SERVER_BASE_URL + "/stores/" + id, true);
      xhr.send();
    });
  }
}


class Cart {
  constructor() {
    this.init();
  }

  init() {
    document.querySelector(".foldableMenu").addEventListener("click", function (e) {
      if (e.target.tagName === "INPUT") {
        this.addToCart(e.target.value, e.target.attributes.data.value);
      }
    }.bind(this));
  }

  addToCart(cont, price) {
    let renderTarget = document.querySelector(".storeCartContent");
    let renderTargetChildren = Array.from(renderTarget.children);
    let numberPrice = price.slice(0, price.length - 1).split(',').join('');
    let renderContent = "<li data='" + numberPrice + "' value='" + cont + "'>" + cont + " " + price + "</li>";
    let hasContent = false;
    let childToRemove;
    renderTargetChildren.forEach(function (child) {
      if (cont + " " + price === child.outerText) {
        hasContent = true;
        childToRemove = child;
      }
    });

    if (hasContent === false) {
      renderTarget.innerHTML += renderContent;
    } else {
      renderTarget.removeChild(childToRemove);
    }
    this.calcTotal();
  }

  calcTotal() {
    let cartList = document.querySelector(".storeCartContent");
    let cartListChildren = Array.from(cartList.children);
    let totalPrice = 0;
    cartListChildren.forEach(function (child) {
      totalPrice += Number(child.attributes.data.value);
    })
    document.querySelector("#cartTotalPrice").innerText = totalPrice;
  }
}


let StoreUtil = {
  scrollWithCart: function () {
    document.addEventListener("scroll", function () {
      if (window.innerWidth > 768) {
        if (window.scrollY > 583) {
          let cart = document.querySelector(".storeCart");
          cart.style.position = "fixed";
          cart.style.top = "10px";
          cart.style.width = "200px"
        }
        else {
          let cart = document.querySelector(".storeCart");
          cart.style.position = "inherit";
          cart.style.top = "";
          cart.style.width = ""
        }
      }
      else {
        let cart = document.querySelector(".storeCart");
        cart.style.position = "inherit";
        cart.style.top = "";
        cart.style.width = ""
      }
    })
  },

  makeModal: function () {
    //모달
    let modal = document.querySelector('#orderModal');
    let modalBtn = document.querySelector("#cartOrderButton");

    modalBtn.addEventListener("click", function () {
      modal.style.display = "block";
      setTimeout(function () {
        modal.style.opacity = 1;
      }, 500)
      setTimeout(function () {
        modal.style.opacity = 0;
        setTimeout(function(){
          modal.style.display = "none";
        },500)
      }, 3000)

    })
  },

  makeOrder: function (storeId) {
    let userList = ["dbtech", "jhtech", "mhtech"];


    let orderButton = document.querySelector("#cartOrderButton");

    orderButton.addEventListener("click", function () {

      let totalPrice = Number(document.querySelector("#cartTotalPrice").innerText);

      let cartContent = Array.from(document.querySelector(".storeCartContent").children);

      let menuList = [];

      cartContent.forEach(function (item) {

        menuList.push(item.getAttribute("value"));
      })

      let randNum1 = Math.floor(Math.random() * 3);

      let packet = {};
      packet["sellerId"] = storeId;
      packet["buyerId"] = userList[randNum1];
      packet["content"] = menuList;
      packet["price"] = totalPrice;

      let xhr1 = new XMLHttpRequest();
      xhr1.open("POST", SERVER_BASE_URL + "/orders", true);
      xhr1.setRequestHeader('Content-Type', 'application/json');

      // send the collected data as JSON
      xhr1.send(JSON.stringify(packet));

      xhr1.onloadend = function () {
        let graph = new Graph(storeId);
        StoreUtil.resetCart();
      }.bind(this);
    }.bind(this));
  },

  resetCart: function () {
    let renderTarget = document.querySelector(".storeCartContent");
    let cartTotalPrice = document.querySelector("#cartTotalPrice");
    cartTotalPrice.innerText = 0;
    cartTotalPrice.value = 0;
    renderTarget.innerHTML = "";
    Array.from(document.querySelectorAll("input[type='checkbox']")).forEach(function (cb) {
      cb.checked = false
    });
    Array.from(document.querySelectorAll(".foldableLevel1.active")).forEach(function (fb) {
      fb.click()
    })
  },

  toggleMobileCategory: function () {
    let x = document.querySelector('.mobileCategory');
    let btn = document.querySelector(".mobileTitleButton");
    if (btn.classList.contains("unfolded")) {
      x.style.display = 'none';
      btn.classList.remove("unfolded");
    } else {
      x.style.display = 'block';
      btn.classList.add("unfolded");
    }
  }
}


export {TabUiWithAjax, Foldable, Review, Graph, StoreList, StoreInfo, StoreUtil, Cart}
