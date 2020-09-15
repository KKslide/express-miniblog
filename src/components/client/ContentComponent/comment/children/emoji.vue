<template>
    <span
        class="emoji-item-common"
        :class="['emoji-'+text,isInput?'emoji-size-small':'emoji-size-large']"
        @click="emojiClick"
    ></span>
</template>
<script>
export default {
    data() {
        return {};
    },
    components: {},
    props: ["text", "isInput"],
    methods: {
        emojiClick() {
            this.$emit("onClick", this.text);
        }
    }
};
</script>
<style lang="less" scoped>
.emoji-item-common{
    transition: transform .3s;
}
.emoji-item-common:hover{
    transform: scale(1.1);
}
</style>