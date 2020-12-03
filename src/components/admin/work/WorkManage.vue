<template>
    <div id="workManage">
        <el-table :data="workDataList" border style="width: 100%" :cell-class-name="setIdColumn" >
            <el-table-column prop="id" label="作品ID号" width="100"></el-table-column>
            <el-table-column prop="name" label="作品名称"></el-table-column>
            <el-table-column prop="tag" label="标签">
                <template slot-scope="scope"><span v-html="scope.row.tag == 'undefined' ? '-' : scope.row.tag"></span></template>
            </el-table-column>
            <el-table-column prop="img" label="缩略图">
                <template slot-scope="scope">
                    <el-image
                        style="width: 100px; height: 120px"
                        :src="scope.row.img"
                        fit="cover"
                    ></el-image>
                </template>
            </el-table-column>
            <el-table-column prop="description" label="描述">
                <template slot-scope="scope"><span v-html="scope.row.description =='undefined' ? '-' : scope.row.description"></span></template>
            </el-table-column>
            <el-table-column prop="link" label="链接"></el-table-column>
            <el-table-column prop="addtime" label="修改时间">
                <template slot-scope="scope">
                    <p>{{ scope.row.addtime | date }}</p>
                </template>
            </el-table-column>
            <el-table-column prop="symbol" label="符号" width="100">
                <template slot-scope="scope">
                    <span v-html="scope.row.symbol =='undefined' ? '-' : scope.row.symbol"></span>
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
        <el-dialog :title="handleType=='add'?'添加作品':'编辑作品'"  :visible.sync="dialogVisible" width="50%" :before-close="handleClose">
            <el-form :model="curEditWorkData" ref="curEditWorkData" label-width="120px" :rules="rules" >
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
                            :on-change="imgUpload"
                        >
                            <img 
                                v-if="curEditWorkData.img" 
                                :src="curEditWorkData.img" 
                                class="avatar" 
                                ref="singleImg"
                                @mouseenter="mouseEnter" 
                                @mouseleave="mouseLeave" 
                                :style="{width:imgWidth+'px'}" 
                            />
                            <i v-else class="el-icon-plus avatar-uploader-icon" :style="{width:imgWidth+'px',height:imgHeight+'px','line-height':imgHeight+'px','font-size':imgHeight/6+'px'}" ></i>
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
                <el-form-item label="作品描述" prop="description">
                    <el-input v-model="curEditWorkData.description" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="作品链接" prop="link">
                    <el-input v-model="curEditWorkData.link" autocomplete="off"></el-input>
                </el-form-item>
                <el-form-item label="作品图标" prop="symbol">
                    <el-input v-model="curEditWorkData.symbol" autocomplete="off"></el-input>
                </el-form-item>
            </el-form>
            <span slot="footer" class="dialog-footer">
                <el-button @click="handleClose">取 消</el-button>
                <el-button type="primary" @click="commitHandle(handleType)">确 定</el-button>
            </span>
        </el-dialog>
    </div>
</template>

<script>
import { toUnicode } from "../../../utils/utils";
export default {
    data() {
        return {
            handleType:"add",
            dialogVisible: false,
            imgWidth:100,
            imgHeight:88,
            reuploadWidth: this.height * 0.7, // 动态改变”重新上传“大小
            workDataList: [ // 作品数据列表
                // {
                //     id:1,
                //     name:"作品1",
                //     tag:"CSS",
                //     img:"http://example.kkslide.fun/banner.jpg",
                //     description:"一个很牛叉的CSS样式",
                //     link:"https://kkslide.github.io/CSS-Collection.github.io/05-thanos-snap-effect/index.html",
                //     addtime:"2020-06-17 17:26:44",
                //     symbol:"&#x2600;&#xfe0e;"
                // }
            ],
            curEditWorkData:{
                name:"",
                tag:"",
                img:"",
                description:"",
                link:"",
                symbol:""
            },
            rules:{
                name:[{ required: true, message: '内容不能为空', trigger: 'blur' }],
                img:[{required:true,message:'要上传图片呀!!',trigger:'blur'}],
                // description:[{required:true,message:'描述内容!!',trigger:'blur'}],
                link:[{required:true,message:'这里要填写GitHub链接!!',trigger:'blur'}],
                // symbol:[{required:true,message:'图标写一下!!',trigger:'blur'}],
            }
        }
    },
    methods: {
        getData() { // 获取作品集
            this.$axios({ url: '/admin/work' })
                .then(res => {
                    this.workDataList = res.data
                })
        },
        imgUpload(files, fileList) { // 点击弹出剪裁框
            let tempForm = new FormData();
            tempForm.append('file',files.raw);
            this.$refs.uploading.style.display = 'block';
            this.$axios.post('/pic/img_upload',tempForm).then(res=>{
                this.$refs.uploading.style.display = 'none';
                if(res.status==200){
                    this.curEditWorkData.img = res.data.imageUrl;
                }else {
                    // 上传失败则显示上传失败，如多图则从图片列表删除图片
                    this.$refs.failUpload.style.display = 'block'
                }
            })
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
        commitHandle(type){ // 确认操作
            if(type=="add"){ // 新增
                this.curEditWorkData.addtime = new Date().Format('yyyy-M-d hh:mm:ss');
                this.$axios({
                    url:"/admin/work/add",
                    data: this.curEditWorkData,
                    method:'post'
                }).then(res=>{
                    console.log(res);
                    this.getData();
                    this.dialogVisible = false;
                });
            }
            else if(type=="edit"){ // 编辑
                this.curEditWorkData.addtime = new Date().Format('yyyy-M-d hh:mm:ss');
                this.$axios({
                    url: "/admin/work/edit",
                    method: "post",
                    data: this.curEditWorkData
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
            this.$confirm('真的要删除这个作品吗?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$axios({
                    url: '/admin/work/del',
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
            Object.assign(this.curEditWorkData,row);
              this.dialogVisible=true;
        },
        setIdColumn({ row, column, rowIndex }) { // 设置栏目样式
            if (column.property == 'link' || column.property == 'addtime') {
                return 'cell_nowrap'
            }
        },
        handleClose(done) { // 关闭弹窗
            this.$confirm('确认关闭？')
                .then(_ => {
                    this.curEditWorkData = {};
                    this.dialogVisible = false; 
                })
                .catch(err => { 
                    console.log(err);
                });
        },
    },
    created() {
        this.getData()
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