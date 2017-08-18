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
        });
    }
}



/* 폴더블 메뉴 */

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
                if (level2.style.maxHeight === "1000px") {
                    level2.style.maxHeight = "0px";
                } else {
                    level2.style.maxHeight = "1000px";
                }
            }
        }
    }
}

/* 리뷰관련 */

class Review {

    constructor(){
        this.getReview();
        this.postReview();
    }

    postReview() {
        let theButton = document.querySelector("#reviewTextInputBtn");
        theButton.addEventListener("click", function () {
          let packet = {"review": {}};
          packet["storeId"] = 101010;
          packet.review["content"] = document.querySelector("#reviewTextInput").value;
          packet.review["time"] = new Date().toLocaleString();
          packet.review["user"] = "ygtech";
          packet.review["stars"] = Math.floor(Math.random() * 6);

          let xhr1 = new XMLHttpRequest();
          xhr1.open("POST", "http://13.124.179.176:3000/stores/101010", true);
          xhr1.setRequestHeader('Content-Type', 'application/json');
          // send the collected data as JSON
          xhr1.send(JSON.stringify(packet));
          xhr1.onloadend = function () {
            alert("소중한 리뷰 감사합니다.");
            this.getReview();
            document.querySelector("#reviewTextInput").value = "";
          }.bind(this);
        }.bind(this));
    }

    getReview() {
        let xhttp = new XMLHttpRequest();
        xhttp.onreadystatechange = function () {
          if (this.readyState == 4 && this.status == 200) {
            const response = JSON.parse(this.responseText);
            const renderTarget = document.querySelector("#reviewList");
            renderTarget.innerHTML = "";
            response[0].review.reverse().forEach(function (oneReview) {
              const review = oneReview;
              const userId = review.user;
              const createdDate = review.time;
              const reviewContent = review.content;
              const orangeStar = "*".repeat(review.stars);
              const greyStar = "*".repeat(5-review.stars);
              const tempGrab = document.querySelector("#reviewTemplate").text;
              const result = eval('`' + tempGrab + '`');
              renderTarget.innerHTML += result;
            })
          }
        };
        xhttp.open("GET", "http://13.124.179.176:3000/stores/101010", true);
        xhttp.send();
    }

}




let StoreUtil = {
  scrollWithCart: function(){
    document.addEventListener("scroll", function () {
      if(window.innerWidth > 768){
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

  makeOrder: function(storeId){
    let userList = ["dbtech", "jhtech", "mhtech"];


    let orderButton = document.querySelector("#cartOrderButton");

    orderButton.addEventListener("click", function () {

      let totalPrice =  Number(document.querySelector("#cartTotalPrice").innerText);

      let cartContent = Array.from(document.querySelector(".storeCartContent").children);

      let menuList = []

      cartContent.forEach(function(item){
        console.log(item);
        menuList.push(item.getAttribute("value"));
      })

      let randNum1 = Math.floor(Math.random() * 3);

      let packet = {};
      packet["sellerId"] = storeId;
      packet["buyerId"] = userList[randNum1];
      packet["content"] = menuList;
      packet["price"] = totalPrice;
      console.log(packet)
      let xhr1 = new XMLHttpRequest();
      xhr1.open("POST", "http://13.124.179.176:3000/orders", true);
      xhr1.setRequestHeader('Content-Type', 'application/json');

      // send the collected data as JSON
      xhr1.send(JSON.stringify(packet));

      xhr1.onloadend = function () {
        alert('주문해주셔서 감사합니다.');
        console.log(storeId);
        let graph = new Graph(storeId);
        StoreUtil.resetCart();
      }.bind(this);
    }.bind(this));
  },

  resetCart: function(){
    let renderTarget = document.querySelector(".storeCartContent");
    let cartTotalPrice = document.querySelector("#cartTotalPrice");
    cartTotalPrice.innerText = 0;
    cartTotalPrice.value = 0;
    renderTarget.innerHTML = "";
    Array.from(document.querySelectorAll("input[type='checkbox']")).forEach(function(cb){cb.checked=false})
    Array.from(document.querySelectorAll(".foldableLevel1.active")).forEach(function(fb){fb.click()})
  },

  toggleMobileCategory: function(){
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


class Graph {
    constructor(storeId){
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

              orders[i].content.forEach(function(ele){
                if (ele in top){
                  topMenu[ele] += 1;
                }
                else {
                  topMenu[ele] = 1;
                }
              })

              // if (orders[i].content in topMenu) {
              //   topMenu[orders[i].content] += 1;
              // } else {
              //   topMenu[orders[i].content] = 1;
              // }

            }


            let items = Object.keys(topMenu).map(function (key) {
              return [key, topMenu[key]];
            });

            items.sort(function (first, second) {
              return second[1] - first[1];
            })

            let top5 = items.slice(0, 5);


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
              circleContent += '<circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="' + colorArr[i] + '" stroke-width="8" stroke-dasharray="' + share + ' ' + reverse + '" stroke-dashoffset="' + offset + '">';
              circleContent += '<title class="donut-segment-title">' + top5[i].toString().split(',')[0] + '</title>';
              circleContent += '</circle>';

              labelText[i] = '';
              labelText[i].innerHTML = top5[i].toString().split(',')[0] + ' ' + share.toFixed(2) + '%';
              totalLength = totalLength + share;
              offset = 100 - totalLength + 25;
              if (i == 4) {
                labelText[5].innerHTML = '';
                labelText[5].innerHTML = '기타 ' +(100 - totalLength).toFixed(2) + '%';
              }
            }

            let svg = document.querySelector('svg');
            svg.insertAdjacentHTML('beforeend', circleContent);

          }
        };
        xhr.open('GET', 'http://13.124.179.176:3000/orders/bystore/' + storeId, true);
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

            let top3_name = document.querySelectorAll('.name');
            let top3_order = document.querySelectorAll('.orders');

            for (let i = 0; i < top3.length; i++) {
              let name = top3[i].toString().split(",")[0];
              let order = top3[i].toString().split(",")[1];
              top3_name[i].innerHTML = name;
              top3_order[i].innerHTML = order;
            }

          }

        }

        xhr.open('GET', 'http://13.124.179.176:3000/orders/bystore/' + storeId, true);
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

        const layoutTarget = document.querySelector(".storeLayout");
        layoutTarget.innerHTML = '<div class="m-x-3 m-b-2">홈 >	피자|서울 송파구 잠실4동을 중심으로	총 71곳을 찾았습니다.</div><div class="col-xs-12 storeCardRow"></div>';
        const response = JSON.parse(this.responseText);
        const renderTarget = document.querySelector(".storeCardRow");
        renderTarget.innerHTML = "";
        response.slice(0, 30).forEach(function (oneStore) {
          const store = oneStore;
          const storeId = store.storeId;
          const storeImg = store.storeImg;
          const storeName = store.storeName;
          const address = store.address;
          const tempGrab = document.querySelector("#storeListTemplate").text;
          const result = eval('`' + tempGrab + '`');
          renderTarget.innerHTML += result;
        })

        let clickedStore = document.querySelector(".storeCardRow");

        clickedStore.addEventListener("click", function (e) {
          if (e.target && e.target.className == "storeCard") {
            var realTarget = e.target;
          } else if(e.target.className == "col-xs-4") {
            var realTarget = e.target.children[0];
          } else if(e.target.className == 'col-xs-12') {
            var realTarget = e.target.children[0].children[0];
          } else {
            var realTarget = e.target.closest(".storeCard");
          }
          let storeInfo = new StoreInfo(realTarget.id);

        });

      }
    };
    xhttp.open("GET", "http://13.124.179.176:3000/stores/bycategory/" + cat, true);
    xhttp.send();

  }

}


class StoreInfo {

  constructor(id) {
    this.storeId = id;
    this.getStoreInfo(id);
  }



  getStoreInfo(id) {
    let xhr = new XMLHttpRequest();
    xhr.onreadystatechange = function () {
      if (this.readyState == 4 && this.status == 200) {

        const response = JSON.parse(this.responseText);
        const storeInfo = response[0];
        const layoutTarget = document.querySelector('.storeLayout');



        function getInfo(store) {
          const info = store;
          const storeName = info.storeName;
          const address = info.address;
          const ratingCount = info.ratingCount;
          const minPrice = info.minPrice;
          const openHour = info.openHour;
          const telephone = info.telephone;
          const storeDesc = info.storeDesc;

          let menu = info.menu[0];
          let menuSet = [];


          for (let categoryKey in menu) {
            const categoryName = categoryKey;
            const menuArr = menu[categoryKey];

            for (let menuKey in menuArr) {
              const menuName = menuKey;
              const menuPrice = menuArr[menuKey];

              menuSet.push([categoryName, menuName, menuPrice]);

            }
          }

          let markup = '';
          let categorySet = {};

          menuSet.forEach(function (ele) {
            if (ele[0] in categorySet) {

              categorySet[ele[0]] += 1;

              markup += `

                <div class="foldableLevel1">${ele[1]}</div>
                <div class="foldableLevel2 p-x-2 m-y-1">
                  <span class="p-r-1">${ele[2]}</span>
                  <input type="checkbox" value="${ele[1]}" data="${ele[2]}">
                </div>
              `
            } else {

              categorySet[ele[0]] = 1;

              markup += `
              </div>
              <div class="foldableLevel1">
                <h6>${ele[0]}</h6>
              </div>
              <div class="foldableLevel2">
                <div class="foldableLevel1">${ele[1]}</div>
                <div class="foldableLevel2 p-x-2">
                  <span class="p-r-1">${ele[2]}</span>
                  <input type="checkbox" value="${ele[1]}" data="${ele[2]}">
                </div>
              `

            }
          });

          markup += `</div>`;



          const tempGrab = document.querySelector('#storeDetailTemplate').text;
          const result = eval('`' + tempGrab + '`');
          layoutTarget.innerHTML = result;
          const renderMenu = layoutTarget.querySelector('.foldableMenu');
          renderMenu.innerHTML = markup;

        };

        getInfo(storeInfo);

        let tab = new TabUiWithAjax(
            {
              containerName: "storeTabWrapper",
              selectedTabName: "selectedTab",
              selectedContentName: "selectedContent",
              generalTabName: "storeTab",
              generalContentPrefix: "#cont-",
              baseUrl: "",
            }
        );
        console.log("here", id);
        let graph = new Graph(id);

        let foldable = new Foldable("foldableLevel1");

        StoreUtil.makeOrder(id);

        let cart = new Cart();

      }
    };
    xhr.open("GET", "http://13.124.179.176:3000/stores/" + id, true);
    xhr.send();
  }

}


class Cart {
  constructor() {
    this.init()
  }
  init(){
    document.querySelector(".foldableMenu").addEventListener("click", function(e){
      if (e.target.tagName === "INPUT"){
        this.addToCart(e.target.value, e.target.attributes.data.value);
      }
    }.bind(this));
  }

  addToCart(cont, price) {
    let renderTarget = document.querySelector(".storeCartContent");
    let renderTargetChildren = Array.from(renderTarget.children);
    let numberPrice = price.slice(0, price.length-1).split(',').join('');
    let renderContent = "<li data='"+ numberPrice +"' value='" + cont + "'>" + cont + " " + price + "</li>";
    let hasContent = false;
    let childToRemove;
    renderTargetChildren.forEach(function(child) {
      console.log(child.outerHTML)
      if (cont + " " + price === child.outerText) {
        hasContent = true;
        childToRemove = child;
      }
    })

    if (hasContent === false) {
      renderTarget.innerHTML += renderContent;
    } else {
      renderTarget.removeChild(childToRemove);
    }
    this.calcTotal();
  }

  calcTotal(){
    let cartList = document.querySelector(".storeCartContent");
    let cartListChildren = Array.from(cartList.children);
    let totalPrice = 0;
    cartListChildren.forEach(function(child) {
      totalPrice += Number(child.attributes.data.value);
    })
    document.querySelector("#cartTotalPrice").innerText = totalPrice;


  }
}


export {TabUiWithAjax, Foldable, Review, Graph, StoreList, StoreInfo, StoreUtil, Cart}