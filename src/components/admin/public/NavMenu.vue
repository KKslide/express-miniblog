<template>
    <div id="nav">
        <div class="line"></div>
        <el-menu
            :default-active="activeIndex"
            class="el-menu-demo"
            mode="horizontal"
            @select="handleSelect"
            background-color="#545c64"
            text-color="#fff"
            active-text-color="#ffd04b"
        >
            <el-menu-item index="admhome">首页</el-menu-item>
            <el-menu-item index="user" data-url="user">用户管理</el-menu-item>
            <el-menu-item index="category">分类管理</el-menu-item>
            <el-menu-item index="article">文章管理</el-menu-item>
            <el-menu-item index="massage">留言管理</el-menu-item>
        </el-menu>
        <div class="admin_tip">
            <el-dropdown>
                <span class="el-dropdown-link">
                    选项
                    <!-- <i class="el-icon-arrow-down el-icon--right"></i> -->
                    <i class="el-icon-setting el-icon--right"></i>
                </span>
                <el-dropdown-menu slot="dropdown">
                    <el-dropdown-item @click.native="openPage">去到主页</el-dropdown-item>
                    <el-dropdown-item @click.native="logout">退出登陆</el-dropdown-item>
                </el-dropdown-menu>
            </el-dropdown>
        </div>
    </div>
</template>

<script>
export default {
    data() {
        return {
            activeIndex: this.$route.name
        };
    },
    mounted() {

    },
    methods: {
        handleSelect(key, keyPath) {
            this.$router.push({ name: key })
        },
        openPage(){
            window.open(window.location.origin)
        },
        logout() {
            this.$axios.get('/admin/logout').then(res => {
                if (res.data.code == 1) {
                    this.$message({
                        type: "success",
                        message: "退出登陆!"
                    })
                    this.$router.push('/login')
                }
            })
        }
    },
    watch: {
        $route(to, from) {
            this.activeIndex = to.name
        }
    }
}
</script>

<style lang="less" scoped>
#nav {
    margin-top: 10px;
    position: relative;
    .admin_tip {
        position: absolute;
        top: 50%;
        transform: translateY(-50%);
        right: 10px;
    }
}
.el-dropdown-link {
    cursor: pointer;
    color: #fff;
}
.el-icon-arrow-down {
    font-size: 12px;
}
</style>