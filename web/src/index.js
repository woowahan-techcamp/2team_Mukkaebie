import {
  TabUiWithAjax,
  Foldable,
  postReview,
  getReview,
  mkbLoad,
  podiumAnimate,
  scrollWithCart,
  makeOrder,
  toggleMobileCategory,
  makeDonutgraph
} from './store.js'

import './css/main.css';

import './css/store.css';

import './css/chart.css';



let inputObj = {
    containerName: "storeTabWrapper",
    selectedTabName: "selectedTab",
    selectedContentName: "selectedContent",
    generalTabName: "storeTab",
    generalContentPrefix: "#cont-",
    baseUrl: "",
}


document.addEventListener("DOMContentLoaded", function () {
        postReview()
        getReview();

        //tab operate
        let test1 = new TabUiWithAjax(inputObj);

        let test = new Foldable("foldableLevel1");

        test.makeFoldable();

        scrollWithCart();

        makeOrder();
        makeDonutgraph()
    });

document.querySelector('#mkbTab').addEventListener('click', function() {
    podiumAnimate();

})