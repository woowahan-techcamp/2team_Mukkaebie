//import Dummy from './dummy.js'

// const dummy = new Dummy();
// dummy.printHello();


class TabUiWithAjax {

    constructor(inputObj){
        this.nav = document.querySelector("#" + inputObj.containerName);
        this.selectedTabName = inputObj.selectedTabName;
        this.selectedTab = "." + inputObj.selectedTabName;
        this.generalTab = "." + inputObj.generalTabName;
        this.selectedContentName = inputObj.selectedContentName;
        this.selectedContent = "." + inputObj.selectedContentName;
        this.generalContentPrefix = inputObj.generalContentPrefix;
        this.tabId = [];
        this.cache = [];
        this.baseUrl = inputObj.baseUrl //"http://52.78.212.27:8080/woowa/";
        this.init();
    }

    init(){
        const firstTab = document.querySelector(this.selectedTabName);
        const firstContent = document.querySelector(this.selectedContentName);
        this.tabDataCollect();
        //this.tabAjaxData(firstTab.id, 1, firstContent);
        this.nav.addEventListener("click", function(){this.tabOperate(event)}.bind(this), false);
    }

    tabDataCollect(){
        const tempTab = document.querySelectorAll(this.generalTab);
        for (const tab of tempTab) {this.tabId.push(tab.id);this.cache.push(0);}
    }

    tabOperate(event){
        let currentTabId = "";
        //선택된 탭표시 제거 및 event delegation targetting
        document.querySelector(this.selectedTab).classList.remove(this.selectedTabName);
        if(event.target && event.target.tagName === "LI") {
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

    cacheCount () {
        const result = [];
        this.tabId.forEach((key, idx) => {
            result.push({name : key,
                click : this.cache[idx]
            })});
    }
}
inputObj = {
    containerName : "storeTabWrapper",
    selectedTabName : "selectedTab",
    selectedContentName : "selectedContent",
    generalTabName : "storeTab",
    generalContentPrefix : "#cont-",
    baseUrl: "",
}





/* 폴더블 메뉴 */

class Foldable {
    constructor(level1Class) {
        this.level1 = document.getElementsByClassName(level1Class);
    }

    makeFoldable() {
        for (let i = 0; i < this.level1.length; i++) {
            this.level1[i].onclick = function(){
                /* Toggle between adding and removing the "active" class,
                to highlight the button that controls the panel */
                this.classList.toggle("active");

                /* Toggle between hiding and showing the active panel */
                let level2 = this.nextElementSibling;
                if (level2.style.maxHeight === "150px") {
                    level2.style.maxHeight = "0px";
                } else {
                    level2.style.maxHeight = "150px";
                }
            }
        }
    }
}

/* 리뷰관련 */

function postReview() {
  var theButton = document.querySelector("#reviewTextInputBtn");
  theButton.addEventListener("click", function(){
    var packet = {"review":{}};
    packet["storeId"] = 101010;
    packet.review["content"] = document.querySelector("#reviewTextInput").value;
    packet.review["time"] =   new Date().toLocaleString();
    packet.review["user"] = "ygtech";

    var xhr1 = new XMLHttpRequest();
    xhr1.open("POST", "http://52.78.184.77:3000/stores/101010", true);
    xhr1.setRequestHeader('Content-Type', 'application/json');
    // send the collected data as JSON
    xhr1.send(JSON.stringify(packet));
    xhr1.onloadend = function () {
      alert("소중한 리뷰 감사합니다.")
      getReview();
      document.querySelector("#reviewTextInput").value = "";
    };
  });
}

function getReview() {
  var xhttp = new XMLHttpRequest();
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
        const orangeStar = "***"
        const greyStar = "**"
        const tempGrab = document.querySelector("#reviewTemplate").text;
        const result = eval('`' + tempGrab + '`');
        renderTarget.innerHTML += result;
      })
    }
  };
  xhttp.open("GET", "http://52.78.184.77:3000/stores/101010", true);
  xhttp.send();
}


/* 먹깨비 관련 */

function mkbLoad() {
  var xhr = new XMLHttpRequest();
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

      for (let i = 0; i < 3; i++) {
        let name = top3[i].toString().split(",")[0];
        let order = top3[i].toString().split(",")[1];
        top3_name[i].innerHTML = name;
        top3_order[i].innerHTML = order;
      }

    }

  }

  xhr.open('GET', 'http://52.78.184.77:3000/orders/bystore/101010', true);
  xhr.send(null);
}
function podiumAnimate() {
  let gold = document.querySelector('.gold .podium');
  gold.style.transition = 'all 1.5s ease';
  gold.style.height = '180px';

  let silver = document.querySelector('.silver .podium');
  silver.style.transition = 'all 1.5s ease';
  silver.style.height = '120px';

  let bronze = document.querySelector('.bronze .podium');
  bronze.style.transition = 'all 1.5s ease';
  bronze.style.height = '80px';
}


/* 장바구니 스크롤 반응 */
function scrollWithCart(){
  document.addEventListener("scroll", function(){
    if (window.scrollY > 583) {
      var cart = document.querySelector(".storeCart");
      cart.style.position = "fixed";
      cart.style.top="10px";
      cart.style.width="200px"
    }
    else {
      var cart = document.querySelector(".storeCart");
      cart.style.position = "inherit";
      cart.style.top="";
      cart.style.width=""
    }
  })
}

function makeOrder(){
  var userList = ["ygtech", "dbtech", "jhtech", "mhtech"]
  var orderButton = document.querySelector("#cartOrderButton");

  orderButton.addEventListener("click", function(){
    var randNum = Math.floor(Math.random() * 4);
    console.log(randNum);
    var packet = {};
    packet["sellerId"] = 101010;
    packet["buyerId"] = userList[randNum];
    packet["content"] = ["testcase"];
    packet["price"] =   1000;
    console.log(packet);
    var xhr1 = new XMLHttpRequest();
    xhr1.open("POST", "http://52.78.184.77:3000/orders", true);
    xhr1.setRequestHeader('Content-Type', 'application/json');

    // send the collected data as JSON
    xhr1.send(JSON.stringify(packet));

    xhr1.onloadend = function () {
      alert("저희 업소를 이용해 주셔서 감사합니다.")
      mkbLoad();
    };
  });
}

/* 모바일 카테고리 토글 */
function toggleMobileCategory() {
  var x = document.querySelector('.mobileCategory');
  var btn = document.querySelector(".mobileTitleButton");
  if (btn.classList.contains("unfolded")) {
    x.style.display = 'none';
    btn.classList.remove("unfolded");
  } else {
    x.style.display = 'block';
    btn.classList.add("unfolded");
  }
}

/* 도넛 그래프 만들기 */
function makeDonutgraph(){
  var xhr = new XMLHttpRequest();

  xhr.onload = function () {
    if (xhr.status === 200) {
      let responseObject = JSON.parse(xhr.responseText);
      let menu = responseObject[0].menu;
      let top5 = menu.sort(function (a, b) {
        return a.orders < b.orders ? 1 : -1;
      }).slice(0, 5);
      let circleContent = '';
      let colorArr = ['rgb(110,239,192)', 'rgb(42,193,188)', 'rgb(130,198,255)', 'rgb(251,136,136)', 'rgb(251,229,136)'];
      let total = 0;
      let share = 0;
      let reverse = 0;
      let offset = 25;
      let totalLength = 0;
      let label = document.querySelectorAll('.donutLabel');

      for (let i = 0; i < menu.length; i++) {
        total += menu[i].orders;
      }

      for (let i = 0; i < 5; i++) {
        share = top5[i].orders / total * 100;
        reverse = 100 - share;
        circleContent += '<circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="' + colorArr[i] + '" stroke-width="8" stroke-dasharray="' + share + ' ' + reverse + '" stroke-dashoffset="' + offset + '">';
        circleContent += '<title class="donut-segment-title">' + top5[i].title + '</title>';
        circleContent += '<desc class="donut-segment-desc">' + top5[i].price + '원</desc>';
        circleContent += '</circle>';

        label[i].insertAdjacentHTML('beforeend', top5[i].title + ' ' + share.toFixed(2) + '%');
        totalLength = totalLength + share;
        offset = 100 - totalLength + 25;
        if (i == 4) {
          label[5].insertAdjacentHTML('beforeend', (100 - totalLength).toFixed(2) + '%');
        }
      }


      var svg = document.querySelector('svg');
      svg.insertAdjacentHTML('beforeend', circleContent);

    }
  };

  xhr.open('GET', 'http://52.78.184.77:3000/stores/101010', true);
  xhr.send(null);
}