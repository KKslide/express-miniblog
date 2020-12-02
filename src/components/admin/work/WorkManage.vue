<template>
    <div id="workManage">
        <el-table :data="workDataList" border style="width: 100%" :cell-class-name="setIdColumn" >
            <el-table-column prop="w_id" label="作品ID号"></el-table-column>
            <el-table-column prop="name" label="作品名称"></el-table-column>
            <el-table-column prop="tag" label="标签"></el-table-column>
            <el-table-column prop="img" label="缩略图">
                <template slot-scope="scope">
                    <el-image
                        style="width: 100px; height: 120px"
                        :src="scope.row.img"
                        fit="cover"
                    ></el-image>
                </template>
            </el-table-column>
            <el-table-column prop="desc" label="描述"></el-table-column>
            <el-table-column prop="link" label="链接"></el-table-column>
            <el-table-column prop="addtime" label="修改时间">
                <template slot-scope="scope">
                    <p>{{ scope.row.addtime | date }}</p>
                </template>
            </el-table-column>
            <el-table-column prop="symbol" label="符号">
                <template slot-scope="scope">
                    <span v-html="scope.row.symbol"></span>
                </template>
            </el-table-column>
            <el-table-column label="操作">
                <template slot-scope="scope">
                    <el-button size="mini" @click="edit(scope.$index, scope.row)" >编辑</el-button >
                    <el-button size="mini" type="danger" @click="del(scope.$index, scope.row)" >删除</el-button >
                </template>
            </el-table-column>
        </el-table>
        <el-button type="text" @click='open'>新增作品</el-button>
        <!-- dialog组件 -->
        <el-dialog :title="handleType=='add'?'添加作品':'编辑作品'" :visible.sync="dialogVisible" width="50%" :before-close="handleClose">
            <el-form :model="curEditWorkData" ref="curEditWorkData" label-width="120px" :rules="rules" @submit.native.prevent="">
                <el-form-item label="作品名称" prop="name">
                    <el-input v-model="curEditWorkData.name" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="标签" prop="tag">
                    <el-input v-model="curEditWorkData.tag" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="作品缩略图" prop="img">
                    <span>(长宽要求：尽量竖向或正方形)</span>
                    <form id="minPicForm" method="post" enctype="multipart/form-data">
                        <!-- 单图片上传 -->
                        <el-upload
                            class="avatar-uploader"
                            v-model="curEditWorkData.img"
                            action="'string'"
                            list-type="picture-card"
                            :auto-upload="false"
                            :show-file-list="false"
                            :on-change="handleCrop"
                        >
                            <img 
                                v-if="curEditWorkData.img" 
                                :src="curEditWorkData.img" 
                                class="avatar" 
                                ref="singleImg"
                                @mouseenter="mouseEnter" 
                                @mouseleave="mouseLeave" 
                                :style="{width:bannerWidth+'px',height:bannerHeight+'px'}" 
                            />
                            <i v-else class="el-icon-plus avatar-uploader-icon" :style="{width:bannerWidth+'px',height:bannerHeight+'px','line-height':bannerHeight+'px','font-size':bannerHeight/6+'px'}" ></i>
                            <div id="uploadIcon" v-if="curEditWorkData.img" ref="reupload" @mouseenter="mouseEnter" @mouseleave="mouseLeave" :style="{width:'100%'}" >
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
                <el-form-item label="作品描述" prop="desc">
                    <el-input v-model="curEditWorkData.desc" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="作品链接" prop="link">
                    <el-input v-model="curEditWorkData.link" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="作品图标" prop="symbol">
                    <el-input v-model="curEditWorkData.symbol" autocomplete="off"></el-input>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="dialogVisible=false">取 消</el-button>
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
            workDataList: [ // 作品数据列表
                {
                    w_id:1,
                    name:"作品1",
                    tag:"CSS",
                    img:"http://example.kkslide.fun/banner.jpg",
                    desc:"一个很牛叉的CSS样式",
                    link:"https://kkslide.github.io/CSS-Collection.github.io/05-thanos-snap-effect/index.html",
                    addtime:"2020-06-17 17:26:44",
                    symbol:"&#x2600;&#xfe0e;"
                },
                {
                    w_id:2,
                    name:"作品2",
                    tag:"THREE.js",
                    img:"http://example.kkslide.fun/banner.jpg",
                    desc:"一个很牛叉的THREE.js",
                    link:"https://kkslide.github.io/CSS-Collection.github.io/05-thanos-snap-effect/index.html",
                    addtime:"2020-06-17 17:26:44",
                    symbol:"&#9787;"
                }
            ],
            curEditWorkData:{
                name:"",
                tag:"",
                img:"",
                desc:"",
                link:"",
                symbol:""
            },
            rules:{
                name:[{ required: true, message: '内容不能为空', trigger: 'blur' }],
                img:[{required:true,message:'要上传图片呀!!',trigger:'blur'}],
                // desc:[{required:true,message:'描述内容!!',trigger:'blur'}],
                link:[{required:true,message:'这里要填写GitHub链接!!',trigger:'blur'}],
                // symbol:[{required:true,message:'图标写一下!!',trigger:'blur'}],
            }
        }
    },
    methods: {
        getData() { // 获取作品集
            this.$axios({ url: '' })
                .then(res => {
                    
                })
        },
        commitHandle(type){ // 确认操作
            if(this.workDataList.banner==''){
                this.$message({ type: 'info', message: '一定要添加作品封面!!!' });
                return false;
            }
            if(type=="add"){ // 新增
                this.$axios({
                    url:"/admin/categories/add",
                    data:{
                        'name':this.workDataList.name,
                        'img':this.workDataList.img
                    },
                    method:'post'
                }).then(res=>{
                    this.getData();
                    this.dialogVisible = false;
                });
            }
            else if(type=="edit"){ // 编辑
                this.$axios({
                    url: "/admin/categories/edit",
                    method: "post",
                    data: {
                        "w_id": this.workDataList.w_id,
                        "name": this.workDataList.name,
                        "img": this.workDataList.img,
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
        open(){ // 打开模态框
            this.dialogVisible=true;
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
            // this.curEditWorkData.name=row.name;
            // this.curEditWorkData.tag=row.tag;
            // this.curEditWorkData.img=row.img;
            // this.curEditWorkData.desc=row.desc;
            // this.curEditWorkData.link=row.link;
            // this.curEditWorkData.symbol=row.symbol;
            this.curEditWorkData
            console.log(this.curEditWorkData,row);
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
                    console.log(this.curEditWorkData);
                })
                .catch(err => { 
                    console.log(err);
                });
        },
    },
    created() {
        // this.getData()
    },
}
</script>

<style lang="scss" scoped>
#workManage {
    padding: 15px;
        .avatar {
        background-size: cover;
        background-position: center center;
        background-repeat: no-repeat;
        width: 100px;
        height: 120px;
        // max-height: 120px;
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
        width: 100px;
        height: 120px;
        line-height: 120px;
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
        width: 100px !important;
        height: 120px !important;
    }
}
</style>