import {MKBComment} from "./MKBComment.js";


export class Graph {

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
              `<circle class="donut-segment" cx="21" cy="21" r="15.91549430918954" fill="transparent" stroke="${colorArr[i]}" stroke-width="8" stroke-dasharray="${share} ${reverse}" stroke-dashoffset="${offset}">
                  <title class="donut-segment-title">${top5[i].toString().split(',')[0]}</title>
               </circle>`;

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
        let top3_name = document.querySelectorAll('.name');
        let top3_order = document.querySelectorAll('.orders');
        let top3UserList = [];
        for (let i = 0; i < 3; i++) {
          let name = ""
          if (i < top3.length) {
            name = top3[i].toString().split(",")[0];
          }
          top3UserList.push(name);
        }
        let mkb = new MKBComment(storeId, top3UserList);
        mkb.initialRendering();
      }
    };
    xhr.open('GET', SERVER_BASE_URL + '/orders/bystore/' + storeId, true);
    xhr.send(null);
  }

}