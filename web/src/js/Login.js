
import StoreUtil from './Util.js'



export class Login {
  constructor(){
    this.init()
  }

  init(){
    document.querySelector("#topLoggedinButton").addEventListener("click", this.makeLoginModal);

    document.querySelector(".loginButton").addEventListener("click", function () {
      this.getInputInfo()
          .then(this.sendLoginInfo)
          .then(this.checkValidity)
          .then(this.succeedLogin)
          .catch(this.failLogin)
          .then(this.logout)
    }.bind(this));
  }

  makeLoginModal(){
    document.querySelector("#loginModal").style.display = "block";
    setTimeout(function () {
      document.querySelector("#loginModal").style.opacity = "1";
    }, 100)
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
      if (pwd["pwd"] === pwInfo){
        resolve(pwd["userId"])
      }
      else {
        reject('아이디나 비밀번호를 확인해 주세요');
      }
    })
  }

  succeedLogin(userId){

    return new Promise(function(resolve){
      StoreUtil.makeAfterLoginModal();
      document.querySelector("#loginModal").style.display = "none";
      const topLoginButton = document.querySelector("#topLoggedinButton");
      const topLogoutButton = document.querySelector("#topLogoutButton");
      const topLoggedinInfo = document.querySelector("#topLoggedinInfo");
      topLoginButton.style.display = "none";
      topLogoutButton.style.display = "block";
      topLoggedinInfo.innerText = userId + " 님";

      if (document.querySelector("p.review-user")) {
        document.querySelector("p.review-user").innerText = userId;
      }

      session = userId;

      document.querySelector(".loginIDInput").value = "";
      document.querySelector(".loginPWInput").value = "";
      resolve();
    })
  }

  failLogin(msg){
    document.querySelector("#loginMsg").innerText = msg;
  }

  logout(){

    document.querySelector("#topLogoutButton").addEventListener("click", function (event) {
      document.querySelector("#topLoggedinButton").style.display = "block";
      document.querySelector("#topLogoutButton").style.display = "none";
      document.querySelector("#topLoggedinInfo").innerText = "";
      session = "비회원";
      if (document.querySelector("p.review-user")) {
        document.querySelector("p.review-user").innerText = "비회원";
      }
    })
  }
}