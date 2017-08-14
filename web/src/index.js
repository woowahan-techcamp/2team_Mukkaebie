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


import style from './scss/main.scss';




document.addEventListener("DOMContentLoaded", function(){
        postReview();

        getReview();

        //tab operate
        let test1 = new TabUiWithAjax(
            {
              containerName: "storeTabWrapper",
              selectedTabName: "selectedTab",
              selectedContentName: "selectedContent",
              generalTabName: "storeTab",
              generalContentPrefix: "#cont-",
              baseUrl: "",
            }
        );

        let test = new Foldable("foldableLevel1");

        test.makeFoldable();

        scrollWithCart();

        makeOrder();

        makeDonutgraph();
    });

document.querySelector('#mkbTab').addEventListener('click', podiumAnimate);