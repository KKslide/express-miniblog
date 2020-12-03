<template>
    <div id="category">
        <el-table :data="categoryData" border style="width: 100%" :cell-class-name="setIdColumn">
            <el-table-column prop="id" label="分类ID"></el-table-column>
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
                <template slot-scope="scope">
                    <el-image
                        style="width: 150px; height: 34px"
                        :src="scope.row.banner"
                        fit="cover"
                    ></el-image>
                </template>
            </el-table-column>
            <el-table-column label="操作">
                <template slot-scope="scope">
                    <el-button size="mini" @click="edit(scope.$index, scope.row)">编辑</el-button>
                    <el-button size="mini" type="danger" @click="del(scope.$index, scope.row)">删除</el-button>
                </template>
            </el-table-column>
        </el-table>
        <el-button type="text" @click='open'>新增分类</el-button>
        <!-- 改用dialog组件 -->
        <el-dialog :title="handleType=='add'?'添加分类':'编辑分类'" :visible.sync="dialogVisible" width="50%" :before-close="handleClose">
            <!-- <span>这是一段信息</span> -->
            <el-form :model="categoryDetail" ref="categoryDetail" label-width="120px" :rules="rules" @submit.native.prevent="">
                <el-form-item label="分类名称" prop="name">
                    <el-input v-model="categoryDetail.name" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="分类缩略图" prop="banner">
                    <span>(banner长宽要求：2278x516)</span>
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
                        >
                            <!-- :http-request="upload" -->
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
                            <div class="reupload icon" ref="uploading" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}" >上传中..</div>
                            <div class="reupload icon" ref="failUpload" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}" >上传失败</div>
                        </el-upload>
                        <!-- <el-dialog :visible.sync="dialogVisible">
                            <img width="100%" :src="dialogImageUrl" alt />
                        </el-dialog> -->
                    </form>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible = false">取 消</el-button>
                <el-button type="primary" @click="commitHandle(handleType)">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
export default {
    data() {
        return {
            handleType:"add",
            dialogVisible: false,
            bannerWidth:396,
            bannerHeight:88,
            file:'',
            reupload: true, // 控制"重新上传"开关
            reuploadWidth: this.height * 0.7, // 动态改变”重新上传“大小
            categoryData: [],
            categoryDetail: {
                id: "",
                name: "",
                banner: "http://example.kkslide.fun/banner.jpg",
                // addtime: "",
                // edittime: "",
            },
            rules:{
                name:[{ required: true, message: '内容不能为空', trigger: 'blur' }],
                banner:[{required:true,message:'请上传分类图banner',trigger:'blur'}]
            }
        }
    },
    methods: {
        getData() {
            this.$axios({ url: '/admin/categories' })
                .then(res => {
                    this.categoryData = res.data.data
                })
        },
        commitHandle(type){ // 添加分类操作
            if(this.categoryDetail.banner==''){
                this.$message({ type: 'info', message: '请添加封面图banner' });
                return false;
            }
            if(type=="add"){
                this.$axios({
                    url:"/admin/categories/add",
                    data:{
                        'name':this.categoryDetail.name,
                        'banner':this.categoryDetail.banner
                    },
                    method:'post'
                }).then(res=>{
                    this.getData();
                    this.dialogVisible = false;
                });
            }
            else if(type=="edit"){
                this.$axios({
                    url: "/admin/categories/edit",
                    method: "post",
                    data: {
                        "id": this.categoryDetail.id,
                        "name": this.categoryDetail.name,
                        "banner": this.categoryDetail.banner,
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
                    this.dialogVisible=false;
                })
            }
        },
        open(){
            this.dialogVisible=true;
            this.categoryDetail.name="";
            this.categoryDetail.banner="http://example.kkslide.fun/banner.jpg";
            this.handleType="add";
        },
        del(index, row) { // 删除按钮
            this.$confirm('永久删除分类"' + row.name + '", 是否继续?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$axios({
                    url: '/admin/categories/del',
                    method: 'post',
                    data: {
                        "id": row.id
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
        edit(index, row) { // 编辑按钮
            this.handleType="edit";
            this.dialogVisible=true;
            this.categoryDetail.id=row.id;
            this.categoryDetail.name=row.name;
            this.categoryDetail.banner=row.banner;
        },
        setIdColumn({ row, column, rowIndex }) { // 设置栏目样式
            if (column.property == 'id') {
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
        handleCrop(files, fileList) { // 点击弹出剪裁框
            let tempForm = new FormData();
            tempForm.append('file',files.raw);
            this.$refs.uploading.style.display = 'block';
            this.$axios.post('/pic/upload',tempForm).then(res=>{
                this.$refs.uploading.style.display = 'none';
                if(res.status==200){
                    this.categoryDetail.banner = res.data.imageUrl;
                }else {
                    // 上传失败则显示上传失败，如多图则从图片列表删除图片
                    this.$refs.failUpload.style.display = 'block'
                }
            })
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
    .avatar {
        background-size: cover;
        background-position: center center;
        background-repeat: no-repeat;
        width: 150px;
        height: 34px;
        // max-height: 34px;
        display: block;
        margin: 0 auto;
    }
    .avatar-uploader .el-upload {
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }

    .avatar-uploader .el-upload:hover {
        border-color: #409eff;
    }
    .avatar-uploader-icon {
        font-size: 28px;
        color: #8c939d;
        width: 150px;
        height: 34px;
        line-height: 34px;
        text-align: center;
    }
    // 新增的上传组件样式
    .avatar-uploader .el-upload {
        border: 1px dashed #d9d9d9;
        border-radius: 6px;
        cursor: pointer;
        position: relative;
        overflow: hidden;
    }
    .avatar-uploader .el-upload:hover {
        border-color: #409eff;
    }
    .avatar-uploader-icon {
        color: #8c939d;
        text-align: center;
    }
    .avatar {
        display: block;
    }
    .reupload {
        border-radius: 50%;
        position: absolute;
        color: #fff;
        background-color: #000000;
        opacity: 0.6;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        display: none;
    }
    #uploadIcon {
        position: absolute;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        display: none;
    }
    .avatar-uploader .el-upload.el-upload--picture-card {
        width: unset !important;
        height: unset !important;
    }
}

</style>