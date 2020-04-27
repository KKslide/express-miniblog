<template>
    <img :src="url" :class="imgClass" :data-index="dataIndex" />
</template>

<script>
export default {
    props: ['src', 'imgClass', 'dataIndex'],
    data() {
        return {
            url: '../../../../static/img/loading.png'
        }
    },
    mounted() {
        let tempImg = new Image();
        tempImg.src = this.src;
        tempImg.onerror = _ => {
            tempImg.src = "../../../assets/images/space.jpg"
        };
        tempImg.onload = () => {
            this.url = tempImg.src;
        }
    }
}
</script>

<style lang="scss" scoped>
</style>