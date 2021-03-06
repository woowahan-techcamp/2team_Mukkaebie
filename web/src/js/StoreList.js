import {StoreInfo} from './StoreInfo.js'


export class StoreList {

  constructor(cat) {
    this.getStoreList(cat);
  }

  getStoreList(cat) {
    let urlCategoryPart = "/stores/bycategory/";
    if (cat === "모아보기") {
      urlCategoryPart = "/stores"
    }
    else {
      urlCategoryPart += cat;
    }

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
            // const storeImg = store.storeImg;
            const storeImg = "http://woowahan1.vipweb.kr/cache/usr/shoplogoc/2017/7/23/689649_201707231457.jpg";
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
          let y = scroll_pos + 100;
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
                last_known_scroll_position = renderTarget.scrollHeight;
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
          let storeLayout = document.querySelector(".storeLayout");

          clickedStore.addEventListener("click", function (e) {
            if (e.target && e.target.closest(".storeCard")) {
              storeLayout.style.opacity = "0";
              setTimeout(function () {
                let realTarget = e.target.closest(".storeCard");
                let storeInfo = new StoreInfo(realTarget.id);
              },500)
              setTimeout(function () {
                storeLayout.style.opacity = "1";
              },500)
            }
          });

        };
      }
    };
    xhr.open("GET", SERVER_BASE_URL + urlCategoryPart, true);
    xhr.send();
  }
}
