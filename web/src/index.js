import {
  TabUiWithAjax,
  Foldable,
  Review,
  scrollWithCart,
  makeOrder,
  toggleMobileCategory,
  Graph
} from './store.js'


import style from './scss/main.scss';




document.addEventListener("DOMContentLoaded", function(){


    let review = new Review();


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

    let foldable = new Foldable("foldableLevel1");

    let graph = new Graph();

    scrollWithCart();

    makeOrder();


});

document.querySelector('#mkbTab').addEventListener('click', function(){
  let graph = new Graph();
  graph.podiumAnimate();
});