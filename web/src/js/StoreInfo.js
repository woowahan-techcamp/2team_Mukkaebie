
import {Graph} from './Graph.js';
import {Review} from './Review.js';
import {Cart} from './Cart.js';
import {TabUiWithAjax} from './Tab.js';
import StoreUtil from "./Util.js";




export class StoreInfo {

  constructor(storeId) {
    this.getStoreInfo(storeId)
        .then(function(storeInfo){
          this.renderOneStore(storeId, storeInfo)
        }.bind(this));
  }

  renderOneStore(storeId, storeInfo) {
    const menuObj = storeInfo.menu[0];
    this.renderStoreFrame(storeInfo);
    this.renderMenu(menuObj);
    this.applyOtherJS(storeId);
  }

  renderStoreFrame (storeInfo) {
    const storeName = storeInfo.storeName;
    const address = storeInfo.address;
    const ratingValue = storeInfo.ratingValue * 20;
    const ratingCount = storeInfo.ratingCount;
    const minPrice = storeInfo.minPrice;
    const openHour = storeInfo.openHour;
    const telephone = storeInfo.telephone;
    const storeDesc = storeInfo.storeDesc;

    const tempGrab = document.querySelector('#storeDetailTemplate').text;
    const storeDetailHtml = eval('`' + tempGrab + '`');
    const layoutTarget = document.querySelector('.storeLayout');
    layoutTarget.innerHTML = storeDetailHtml;
  }

  applyOtherJS(storeId){
    let tab = new TabUiWithAjax(
        {
          containerName: "storeTabWrapper",
          selectedTabName: "selectedTab",
          selectedContentName: "selectedContent",
          generalTabName: "storeTab",
          generalContentPrefix: "#cont-",
        }
    );

    const graph = new Graph(storeId);
    const review = new Review(storeId);
    StoreUtil.makeFoldableMenu("foldableLevel1");
    StoreUtil.makeOrder(storeId);
    const cart = new Cart();
  }

  renderMenu(menuObj){
    let wholeMenuHtml = '';
    const renderTarget = document.querySelector('.foldableMenu');
    for (let categoryKey in menuObj) {
      let menuUnits = '';
      const menuArr = menuObj[categoryKey];
      for (let menuKey in menuArr) {
        const menuName = menuKey;
        const menuPrice = menuArr[menuKey];
        const tempGrab = document.querySelector('#menuUnitTemplate').text;
        menuUnits += eval('`' + tempGrab + '`');
      }
      wholeMenuHtml += `<div class="foldableLevel1"><h6>${categoryKey}</h6></div><div class="foldableLevel2">${menuUnits}</div>`
    }
    renderTarget.innerHTML = wholeMenuHtml;
  }

  getStoreInfo(storeId) {
    return new Promise(function (resolve) {
      function getStoreInfoCb(){
        const response = JSON.parse(this.responseText);
        resolve(response[0], storeId);
      }
      StoreUtil.ajaxGet(SERVER_BASE_URL + "/stores/" + storeId, getStoreInfoCb);
    });
  }
}