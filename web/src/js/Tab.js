




export class TabUiWithAjax {

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
  })
    ;
  }
}

