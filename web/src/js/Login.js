
import StoreUtil from './Util.js'



export class Login {
  constructor(){
    this.init()
  }

  init(){
    document.querySelector("#topLoggedinInfo").addEventListener("click", function () {
      document.querySelector("#loginModal").style.display = "block";
      setTimeout(function () {
        document.querySelector("#loginModal").style.opacity = "1";
      }, 100)
    });

    document.querySelector(".loginButton").addEventListener("click", function () {
      this.getInputInfo()
          .then(this.sendLoginInfo)
          .then(this.checkValidity)
          .then(this.succeedLogin)
          .catch(this.failLogin)
    }.bind(this));
  }

  getInputInfo(){
    return new Promise(function (resolve) {
      const idInfo = document.querySelector(".loginIDInput").value;
      const packet = {"userId" : idInfo};
      resolve(packet);
    });
  }

  sendLoginInfo(userId){
    return new Promise(function (resolve) {
      const xhttp = new XMLHttpRequest();
      xhttp.onreadystatechange = function() {
        if (this.readyState == 4 && this.status == 200) {
          const res = JSON.parse(this.responseText);
          resolve(res[0])}
      };
      xhttp.open("GET", SERVER_BASE_URL + "/users/cf/" + userId["userId"]);
      xhttp.send();
    })
  }

  checkValidity(pwd){
    return new Promise(function (resolve, reject) {
      const pwInfo = document.querySelector(".loginPWInput").value;
      if (pwd["_id"] === pwInfo){
        resolve(pwd["userId"])
      }
      else {
        reject('아이디나 비밀번호를 확인해 주세요');
      }
    })
  }

  succeedLogin(userId){
    StoreUtil.makeAfterLoginModal();
    document.querySelector("#loginModal").style.display = "none";
    const topLoggedinInfo = document.querySelector("#topLoggedinInfo");
    topLoggedinInfo.innerText = userId;
    session = userId;
    document.querySelector(".review-user").innerText = session;
  }

  failLogin(msg){
    document.querySelector("#loginMsg").innerText = msg;
  }

}
