function randomImage(){
    let images = [
     'images/bg/background1.jpg',
     'images/bg/background2.jpg',
     'images/bg/background3.jpg'];
    let size = images.length;
    let x = Math.floor(size * Math.random());
    console.log(x);
    let element = document.getElementsByTagName('body');
    console.log(element);
    element[0].style["background-image"] = "url("+ images[x] + ")";
  }
  
  document.addEventListener("DOMContentLoaded", randomImage);