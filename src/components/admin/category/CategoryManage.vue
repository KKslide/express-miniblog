<template>
    <div id="category">
        <el-table :data="categoryData" border style="width: 100%" :cell-class-name="setIdColumn">
            <el-table-column prop="_id" label="分类ID"></el-table-column>
            <el-table-column prop="name" label="分类名称"></el-table-column>
            <el-table-column prop="addtime" label="新增时间">
                <template slot-scope="scope">
                    <p>{{scope.row.addtime|date}}</p>
                </template>
            </el-table-column>
            <el-table-column prop="edittime" label="上次修改">
                <template slot-scope="scope">
                    <p>{{scope.row.edittime|date}}</p>
                </template>
            </el-table-column>
            <el-table-column prop="banner" label="分类缩略图">
                <!-- <template></template> -->
                <el-image
                    style="width: 150px; height: 34px"
                    :src="categoryDetail.banner"
                    fit="cover"
                ></el-image>
            </el-table-column>
            <el-table-column label="操作">
                <!-- <span>123</span> -->
                <template slot-scope="scope">
                    <el-button size="mini" @click="edit(scope.$index, scope.row)">编辑</el-button>
                    <el-button size="mini" type="danger" @click="del(scope.$index, scope.row)">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
        <el-button type="text" @click="dialogVisible = true">新增分类</el-button>
        <!-- 改用dialog组件 -->
        <el-dialog title="提示" :visible.sync="dialogVisible" width="30%" :before-close="handleClose">
            <!-- <span>这是一段信息</span> -->
            <el-form v-model="categoryDetail" ref="categoryDetail" label-width="120px">
                <el-form-item label="分类名称" prop="name">
                    <el-input v-model="categoryDetail.name" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="分类缩略图" prop="banner" v-if="false">
                    <el-form-item label="缩略图" :label-width="formLabelWidth" prop="minpic_url">
                        <form id="minPicForm" method="post" enctype="multipart/form-data">
                            <!-- 单图片上传 -->
                            <el-upload
                                class="avatar-uploader"
                                v-model="categoryDetail.banner"
                                action="'string'"
                                list-type="picture-card"
                                :auto-upload="false"
                                :show-file-list="false"
                                :on-change="handleCrop"
                                :http-request="upload"
                            >
                                <img 
                                    v-if="categoryDetail.banner" 
                                    :src="categoryDetail.banner" 
                                    class="avatar" 
                                    ref="singleImg" 
                                    @mouseenter="mouseEnter" 
                                    @mouseleave="mouseLeave" 
                                    :style="{width:bannerWidth+'px',height:bannerHeight+'px'}" 
                                />
                                <i v-else class="el-icon-plus avatar-uploader-icon" :style="{width:bannerWidth+'px',height:bannerHeight+'px','line-height':bannerHeight+'px','font-size':bannerHeight/6+'px'}" ></i>
                                <div id="uploadIcon" v-if="categoryDetail.banner" ref="reupload" @mouseenter="mouseEnter" @mouseleave="mouseLeave" :style="{width:'100%'}" >
                                    <i class="el-icon-zoom-in" title="查看原图" :style="{color:'#2E2E2E',fontSize:'25px',display:'inline-block',paddingRight:'15px'}" ></i>
                                    <i class="el-icon-refresh-right" title="重新上传" :style="{color:'#2E2E2E',fontSize:'25px',display:'inline-block'}" ></i>
                                </div>
                                <div class="reupload" ref="uploading" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}" >上传中..</div>
                                <div class="reupload" ref="failUpload" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}" >上传失败</div>
                            </el-upload>
                            <el-dialog :visible.sync="dialogVisible">
                                <img width="100%" :src="dialogImageUrl" alt />
                            </el-dialog>
                        </form>
                    </el-form-item>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="dialogVisible = false">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            dialogVisible: false,
            bannerWidth:2278,
            bannerHeight:516,
            reupload: true, // 控制"重新上传"开关
            categoryData: [],
            categoryDetail: {
                addtime: "2020-01-09T09:39:52.435Z",
                banner: "http://example.kkslide.fun/banner.jpg",
                edittime: "2020-01-13T03:17:15.151Z",
                name: "Fun"
            }
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
                closeOnClickModal: false,
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
                closeOnClickModal: false,
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
        setIdColumn({ row, column, rowIndex }) { // 设置栏目样式
            if (column.property == '_id') {
                return 'cell_nowrap'
            }
        },
        handleClose(done) { // 关闭弹窗
            this.$confirm('确认关闭？')
                .then(_ => {
                    done();
                })
                .catch(_ => { });
        },
        mouseEnter() {//鼠标划入显示“重新上传”
            this.$refs.reupload.style.display = 'block'
            if (this.$refs.failUpload.style.display === 'block') {
                this.$refs.failUpload.style.display = 'none'
            }
            this.$refs.singleImg.style.opacity = '0.6'
        },
        mouseLeave() { // 鼠标划出隐藏“重新上传”
            this.$refs.reupload.style.display = 'none'
            this.$refs.singleImg.style.opacity = '1'
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