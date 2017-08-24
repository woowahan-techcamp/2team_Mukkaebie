

import {StoreInfo} from './StoreInfo.js'


export class StoreList {

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
          if (store.review) {
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

          if (layoutTarget.getElementsByClassName("storeCardRow").length == 0) {
            return false;
          }

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

            if (!scrollTimer && now - lastScrollFireTime > (3 * minScrollTime)) {
              processScroll();
              lastScrollFireTime = now;
            }
            scrollTimer = setTimeout(function () {
              scrollTimer = null;
              lastScrollFireTime = new Date().getTime();
              processScroll();
            }, minScrollTime);

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


