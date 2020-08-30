<template>
  <!-- <img :src="url" :width="size.width" :height="size.height" :class="imgClass" :data-index="dataIndex" /> -->
  <img :src="url" :width="size.width" :class="imgClass" :data-index="dataIndex" />
</template>

<script>
export default {
  props: ["src", "imgClass", "dataIndex", "size"],
  data() {
    return {
      url: "../../../../static/img/loading.png",
    };
  },
  methods: {
    prepareImg(newValue) {
      let tempImg = new Image();
      tempImg.src = newValue ? newValue : this.src;
      tempImg.onerror = (_) => {
        tempImg.src = "../../../assets/images/space.jpg";
      };
      tempImg.onload = () => {
        this.url = tempImg.src;
      };
    },
  },
  mounted() {
    this.prepareImg();
  },
  watch: {
    src: function (nv, ov) {
      this.prepareImg(nv);
    },
  },
};
</script>

<style lang="scss" scoped>
</style>