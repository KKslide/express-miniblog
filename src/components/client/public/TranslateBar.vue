<template>
  <div>
    <div id="translate_bar">
      <i class="el-icon-setting"></i>
      <span>{{$t("lang")}}</span>
    </div>
  </div>
</template>

<script>
export default {
  name: "translate",
  mounted() {
    var bar = document.getElementById('translate_bar');
    var barText = bar.children[1];
    var timer = null;
    timer = setTimeout(() => {
      bar.style.right = '-40px';
    }, 8000);
    bar.ontouchstart = function () {
      this.style.right = '3px';
      setTimeout(() => {
        bar.style.right = '-40px';
      }, 8000);
    }
    bar.onmouseover = function () {
      this.style.right = '3px';
    }
    bar.onmouseleave = function () {
      this.style.right = '-40px';
    }
    barText.onclick = function () {
      localStorage.getItem('localeLanguage') == 'en' ? setup('zh') : setup('en');
    }
  }
}
</script>

<style lang="less" scoped>
#translate_bar {
  position: fixed;
  right: 3px;
  bottom: 25%;
  width: 75px;
  height: 25px;
  line-height: 25px;
  text-align: center;
  border: 1px solid #333;
  border-radius: 10px;
  z-index: 9999;
  background-color: #fff;
  transition: right 0.5s;
  i {
  }
  span {
    transform: translateX(4px);
    font-size: 10px;
    display: inline-block;
    height: 23px;
    padding: 0 3px 0 0;
  }
}
#translate_bar:hover {
  cursor: pointer;
  right: 3px;
}
</style>