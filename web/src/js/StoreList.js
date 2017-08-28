import {StoreInfo} from './StoreInfo.js'


export class StoreList {

  constructor(cat) {
    this.getStoreList(cat);
  }

  getStoreList(cat) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
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
        let size = 0;
        let spinner = document.querySelector('.spinner');

        renderStoreList();

        let loadMoreButton = document.querySelector('.load-button');
        if (response.length > 30) {
          loadMoreButton.style.display = 'block';
        }

        loadMoreButton.addEventListener('click', function () {
          preventFadeIn();
          loadFirst();
        });

        if (spinner.style.display == 'none') {
          loadMore();
        }
        ;

        gotoStoreDetail();


        function renderStoreList() {
          response.slice(size, size = size + 30).forEach(function (oneStore) {
            const store = oneStore;
            const storeId = store.storeId;
            const storeImg = store.storeImg;
            const storeName = store.storeName;
            const address = store.address;
            if (store.review) {
              const reviewCount = store.review.length;
            } else {
              const reviewCount = 0;
            }
            const ratingCount = store.ratingCount;
            const ratingValue = store.ratingValue * 20;
            const tempGrab = document.querySelector("#storeListTemplate").text;
            const result = eval('`' + tempGrab + '`');
            renderTarget.innerHTML += result;
          })
        }


        function preventFadeIn() {
          let fadeInTarget = document.querySelectorAll('.fadeIn');
          let index = 0;
          let targetArr = [...fadeInTarget];
          targetArr.forEach(function () {
            targetArr[index].classList.remove("fadeIn");
            index++;
          });
        }

        function loadFirst() {
          loadMoreButton.style.display = 'none';
          spinner.style.display = 'block';

          setTimeout(function () {
            spinner.style.display = 'none';
            renderStoreList();
          }, 1000);
        }


        function processScroll(scroll_pos) {
          let contentHeight = renderTarget.offsetHeight;
          let y = scroll_pos + 300;
          if (y >= contentHeight) {
            preventFadeIn();

            if (size >= 60 && size <= response.length) {
              spinner.style.display = 'block';
              setTimeout(function () {
                spinner.style.display = 'none';
                renderStoreList();
              }, 800);
            }
          }
        }

        function loadMore() {

          let timer = null;
          if (layoutTarget.getElementsByClassName("storeCardRow").length !== 0) {

            window.addEventListener('scroll', function () {
              let last_known_scroll_position = 0;
              let ticking = false;
              if (timer !== null) clearTimeout(timer);
              timer = setTimeout(function () {
                last_known_scroll_position = window.scrollY;
                if (!ticking) {
                  window.requestAnimationFrame(function () {
                    processScroll(last_known_scroll_position);
                    ticking = false;
                  });
                }
                ticking = true;
              }, 250);
            }, false);
          }
        }


        function gotoStoreDetail() {

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
      }
    };
    xhr.open("GET", SERVER_BASE_URL + "/stores/bycategory/" + cat, true);
    xhr.send();
  }
}