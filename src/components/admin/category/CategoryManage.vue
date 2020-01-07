<template>
    <div id="category">
        <el-table :data="categoryData" border style="width: 100%" :cell-class-name="setIdColumn">
            <el-table-column prop="_id" label="分类ID"></el-table-column>
            <el-table-column prop="name" label="分类名称"></el-table-column>
            <el-table-column label="操作">
                <span>123</span>
                <template slot-scope="scope">
                    <el-button size="mini" @click="edit(scope.$index, scope.row)">编辑</el-button>
                    <el-button size="mini" type="danger" @click="del(scope.$index, scope.row)">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
        <el-button type="text" @click="open">新增分类</el-button>
        <!-- 分页组件 -->
        <!-- <el-pagination
      background
      layout="prev, pager, next"
      :page-size="5"
      :page-count="pages"
      :total="total"
      @current-change="pageChange"
        ></el-pagination>-->
        <!-- 分页组件 -->
    </div>
</template>

<script>
export default {
    data() {
        return {
            categoryData: []
        }
    },
    methods: {
        getData() {
            this.$axios({ url: '/admin/categories' })
                .then(res => {
                    this.categoryData = res.data.categories
                })
        },
        // 添加按钮
        open() {
            this.$prompt('请分类名称', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                // inputPattern: /[\w!#$%&'*+/=?^_`{|}~-]+(?:\.[\w!#$%&'*+/=?^_`{|}~-]+)*@(?:[\w](?:[\w-]*[\w])?\.)+[\w](?:[\w-]*[\w])?/,
                // inputErrorMessage: '邮箱格式不正确'
            }).then(({ value }) => {
                this.$axios({
                    url: '/admin/categories/add',
                    data: { "name": value },
                    method: 'post'
                }).then(res => {
                    if (res.data.msg == 1) {
                        this.$message({
                            type: 'success',
                            message: res.data.msg
                        });
                    } else {
                        this.$message({
                            type: 'danger',
                            message: res.data.msg
                        });
                    }
                }).then(() => {
                    this.getData()
                })
            }).catch(() => {
                this.$message({
                    type: 'info',
                    message: '取消输入'
                });
            });
        },
        // 删除按钮
        del(index, row) {
            this.$confirm('永久删除分类"' + row.name + '", 是否继续?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$axios({
                    url: '/admin/categories/del',
                    method: 'post',
                    data: {
                        "id": row._id
                    }
                }).then(res => {
                    if (res.data.code == 1) {
                        this.$message({
                            type: 'success',
                            message: '删除成功!'
                        });
                    } else {
                        this.$message({
                            type: 'info',
                            message: '删除失败啦!'
                        });
                    }
                }).then(() => {
                    this.getData()
                })
            }).catch(() => {
                this.$message({
                    type: 'info',
                    message: '已取消删除'
                });
            });
            // **************************
            //   this.$axios({
            //     url: '/admin/categories/del',
            //     method: 'post',
            //     data: {
            //       id: row._id
            //     }
            //   }).then(res => {
            //     if (res.data.code == 1) {
            //       this.$message({
            //         type: 'success',
            //         message: res.data.msg
            //       });
            //     }
            //   })
        },
        // 编辑按钮
        edit(index, row) {
            this.$prompt('修改分类名称', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                inputValue: row.name
            }).then(({ value }) => {
                console.log({
                    "id": row._id,
                    "name": value
                });
                this.$axios({
                    url: "/admin/categories/edit",
                    method: "post",
                    data: {
                        "id": row._id,
                        "name": value
                    }
                }).then(res => {
                    if (res.data.code == 1) {
                        this.$message({
                            type: 'success',
                            message: '更新成功!'
                        });
                    } else {
                        this.$message({
                            type: 'info',
                            message: '更新失败!!'
                        });
                    }
                }).then(() => {
                    this.getData();
                })
            })
        },
        setIdColumn({ row, column, rowIndex }) {
            if (column.property == '_id') {
                return 'cell_nowrap'
            }
        },
    },
    created() {
        this.getData()
    },
}
</script>

<style lang="less" scoped>
#category {
    padding: 15px;
}
</style>