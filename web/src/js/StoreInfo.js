
import {Graph} from './Graph.js';
import {Review} from './Review.js';
import {Foldable} from './Foldable.js';
import {Cart} from './Cart.js';
import {TabUiWithAjax} from './Tab.js';
import StoreUtil from "./Util.js";




export class StoreInfo {

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