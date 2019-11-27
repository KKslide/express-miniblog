<template>
  <div>
    <div class="info-nr" id="info-nr">
      <div id="info-nr-phone" class="info-nr-phone">
        <section id="toMenu" class="el-icon-s-tools"></section>
        <div class="menu_01 menu_item"></div>
        <div class="menu_02 menu_item"></div>
        <div class="menu_03 menu_item"></div>
        <div class="menu_04 menu_item"></div>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  name: "test-keep-alive",
  data() {
    return {
      left: sessionStorage.getItem('attr', 'left'),
      top: sessionStorage.getItem('attr', 'top')
    }
  },
  beforeMount() {
  },
  mounted() {
    if (!sessionStorage.getItem('attr')) {
      sessionStorage.setItem('attr', JSON.stringify({
        'left': $("#info-nr").offset().left,
        'top': $("#info-nr").offset().top
      }))
    } else {
      $("#info-nr").css({ 'top': JSON.parse(sessionStorage.getItem('attr')).top + 'px' })
    }

    var timerID = null;
    var addFunc = function () {
      $(".info-nr-phone").addClass("info-nr-phone2");
      $(".menu_01").addClass("to_01");
      $(".menu_02").addClass("to_02");
      $(".menu_03").addClass("to_03");
      $(".menu_04").addClass("to_04");
    }
    var rmFunc = function () {
      $(".info-nr-phone").removeClass("info-nr-phone2");
      $(".menu_01").removeClass("to_01");
      $(".menu_02").removeClass("to_02");
      $(".menu_03").removeClass("to_03");
      $(".menu_04").removeClass("to_04");
    }
    $(document).click(function (e) {
      var e = e || window.event;
      var elem = e.target;
      if ($(elem).is('#toMenu')) { /*  || $(elem).is('.menu_item') */
        // 区域内
        addFunc();
        clearTimeout(timerID);
        timerID = setTimeout(() => { rmFunc() }, 3000); // 2秒后自动消失
      }
      else if ($(elem).is('.menu_item')) { // 如果点到的是展开项
        clearTimeout(timerID);
        timerID = setTimeout(() => { rmFunc() }, 3000); // 2秒后自动消失
      }
      else { //在区域外
        rmFunc()
      }
    });

    // 拖拽
    var screenHeight = document.documentElement.clientHeight;
    var screenWidth = document.documentElement.clientWidth;
    var fdiv = document.getElementById("info-nr");
    var startX = 0, startY = 0; // 起始位置, 用于记录
    fdiv.addEventListener('touchstart', (e) => { // 开始拖拽
      startX = e.targetTouches[0].clientX;
      startY = e.targetTouches[0].clientY;
    }, false);
    fdiv.addEventListener('touchmove', function (event) { // 拖拽中
      if ($(".info-nr-phone").hasClass("info-nr-phone2")) return // 如果已经是展开状态就不准移动
      if (event.targetTouches.length == 1) { // 如果这个元素的位置内只有一个手指的话
        event.preventDefault();// 阻止浏览器默认事件，重要 
        var touch = event.targetTouches[0];
        fdiv.style.top = (touch.clientY - parseInt(fdiv.clientHeight) / 2) + "px";
        fdiv.style.right = (screenWidth - touch.clientX - parseInt(fdiv.clientHeight) / 2) + "px";
      }
    }, false);
    fdiv.addEventListener('touchend', (e) => { // 拖拽结束
      var touch = e.changedTouches[0], newTop, elem = e.target;
      if ($(elem).is('.menu_item') || touch.clientX == startX || touch.clientY == startY) return // 如果是展开状态则不移动
      if ((touch.clientY) <= 200) {//超过顶部
        newTop = 200;
      } else if (touch.clientY > (screenHeight - parseInt(fdiv.clientHeight))) {//超过底部
        newTop = (screenHeight - parseInt(fdiv.clientHeight)) - 200;
      } else {
        newTop = (touch.clientY - parseInt(fdiv.clientHeight) / 2);
      }
      //   console.log('鼠标离顶部高度' + touch.clientY, '元素离顶部高度' + $("#info-nr").offset().top, '滚动高度' + $(document).scrollTop());
      $("#info-nr").animate({ 'right': '10%', 'top': newTop }, function () {
        sessionStorage.setItem('attr', JSON.stringify({
          'left': $("#info-nr").offset().left,
          'top': $("#info-nr").offset().top
        }))
      })
    }, false);

  }
}
</script>

<style lang="less" scoped>
// 设置选项卡
.info-nr {
  position: fixed;
  top: 85%;
  right: 10%;
  z-index: 9999;
  tap-highlight-color: rgba(0, 0, 0, 0);
}

#toMenu {
  display: block;
  width: 45px !important;
  height: 45px !important;
  line-height: 45px !important;
  font-size: 25px;
  text-align: center;
  border-radius: 45px;
  position: absolute;
  bottom: 0;
  right: 0;
  z-index: 9999;
  background: rgba(125, 125, 125, 0.41);
//   border: 2px solid #e1e1e1d4;
}

.info-nr-phone {
  height: 45px;
  width: 45px;
}

#info-nr-phone {
  position: relative;
}

.info-nr-phone > div {
  width: 40px;
  height: 40px;
  border-radius: 40px;
  box-shadow: 0 0 0 3px #ffffff, 0 2px 5px 0 rgba(0, 0, 0, 0.25);
  position: absolute;
  bottom: 2px;
  right: 2px;
  z-index: 900;
  -moz-transition: transform 200ms;
  -webkit-transition: -webkit-transform 200ms;
  -ms-transition: transform 200ms;
}

.info-nr-phone > .to_01 {
  -webkit-transform: translate(-14px, -120px) rotate(720deg);
  -moz-transform: translate(-14px, -120px) rotate(720deg);
  -ms-transform: translate(-14px, -120px) rotate(720deg);
  -o-transform: translate(-14px, -120px) rotate(720deg);
  transform: translate(-14px, -65px) rotate(720deg);
  background: rgb(58, 58, 58);
  background-size: auto 66%;
}

.info-nr-phone > .to_02 {
  -webkit-transform: translate(-78px, -108px) rotate(720deg);
  -moz-transform: translate(-78px, -108px) rotate(720deg);
  -ms-transform: translate(-78px, -108px) rotate(720deg);
  -o-transform: translate(-78px, -108px) rotate(720deg);
  transform: translate(-71px, -31px) rotate(720deg);
  background: rgb(45, 70, 75);
  background-size: auto 70%;
}

.info-nr-phone > .to_03 {
  -webkit-transform: translate(-85px, -80px) rotate(720deg);
  -moz-transform: translate(-85px, -80px) rotate(720deg);
  -ms-transform: translate(-85px, -80px) rotate(720deg);
  -o-transform: translate(-85px, -80px) rotate(720deg);
  transform: translate(-67px, 28px) rotate(720deg);
  background: rgb(141, 67, 131);
  background-size: auto 60%;
}

.info-nr-phone > .to_04 {
  -webkit-transform: translate(-79px, -36px) rotate(720deg);
  -moz-transform: translate(-79px, -36px) rotate(720deg);
  -ms-transform: translate(-79px, -36px) rotate(720deg);
  -o-transform: translate(-79px, -36px) rotate(720deg);
  transform: translate(-15px, 62px) rotate(720deg);
  background: rgb(111, 217, 221);
  background-size: auto 60%;
}
</style>