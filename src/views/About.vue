<template>
    <div class="about">
        <h1 id="hhh">This is an about page</h1>
    </div>
</template>
<script>
export default {
    mounted() {
        $("#hhh").on("click", function () {
            $(this).toggleClass("aaa")
        })
    }
}
</script>
<style lang="scss" scoped>
    #hhh{
        color:red;
        cursor: pointer;
    }
</style>