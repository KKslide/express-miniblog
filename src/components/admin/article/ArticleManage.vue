<template>
    <div id="article">
        <!-- 文章列表 -->
        <el-table :data="articleData" border style="width: 100%" :cell-class-name="setIdColumn">
            <el-table-column prop="id" label="文章ID"></el-table-column>
            <el-table-column prop="title" label="文章标题"></el-table-column>
            <el-table-column prop="category" label="文章分类">
                <!-- <template slot-scope="scope">
                    <p>{{scope.row.category|getCatName}}</p>
                </template> -->
            </el-table-column>
            <el-table-column label="添加时间">
                <template slot-scope="scope">
                    <p>{{scope.row.addtime|date}}</p>
                </template>
            </el-table-column>
            <el-table-column prop="viewnum" label="阅读量"></el-table-column>
            <el-table-column prop="comment_num" label="评论">
                <template slot-scope="scope">
                    <el-button
                        @click="checkComment(scope.row)"
                        type="text"
                        size="normal"
                    >{{scope.row.comment_num}}</el-button>
                </template>
            </el-table-column>
            <el-table-column prop="isShow" label="是否显示"></el-table-column>
            <el-table-column label="操作">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        @click="dialog=true; editorInit(); handleEdit(scope.$index, scope.row)"
                    >编辑</el-button>
                    <el-button
                        size="mini"
                        type="danger"
                        @click="handleDelete(scope.$index, scope.row)"
                    >删除</el-button>
                </template>
            </el-table-column>
        </el-table>

        <!-- 评论列表弹窗 -->
        <el-dialog :title="'文章【'+curChosenArcData.title+'】的评论'" :visible.sync="commentModel" :modal-append-to-body="true" width="80%" center :close-on-click-modal="false">
            <CommentCom :curChosenArcComment="curChosenArcData" :upDateArc="getArticles"></CommentCom>
            <span slot="footer" class="dialog-footer">
                <el-button @click="commentModel = false">取 消</el-button>
                <el-button type="primary" @click="commentModel = false">确 定</el-button>
            </span>
        </el-dialog>
        <!-- 评论列表弹窗 -->

        <el-button
            type="text"
            @click="
                dialog = true;
                dialogType = 'add';
                drawer_title = '添加文章';
                minpic_url_list = [];
                imageUrl = '';
                rest();
                editorInit();
            "
            >添加文章</el-button
        >

        <el-divider class="pager_divider"></el-divider>
        <!-- 分页组件 -->
        <el-pagination
            background
            layout="prev, pager, next"
            :page-size="5"
            :page-count="pages"
            :total="total"
            @current-change="pageChange"
        ></el-pagination>
        <!-- 分页组件 -->

        <!-- 抽屉组件 - 新增或者编辑 -->
        <el-drawer
            :title="drawer_title"
            :before-close="handleClose"
            :visible.sync="dialog"
            :destroy-on-close="true"
            direction="btt"
            custom-class="demo-drawer"
            ref="drawer"
            size="85%"
            :modal-append-to-body="true"
        >
            <div class="demo-drawer__content" style="padding:0 15px 60px 15px;">
                <el-form :model="form" ref="form" :rules="rules">
                    <!-- 文章标题 -->
                    <el-form-item label="文章标题" :label-width="formLabelWidth" prop="title">
                        <el-input v-model="form.title" autocomplete="off"></el-input>
                    </el-form-item>
                    <!-- 是否显示 -->
                    <el-form-item label="是否显示" :label-width="formLabelWidth" prop="is_show">
                        <el-switch
                            v-model="form.is_show"
                            active-color="#13ce66"
                            inactive-color="#ff4949"
                            active-value="0"
                            inactive-value="1"
                        ></el-switch>(绿色为开启显示,选择关闭则不会在页面中显示)
                    </el-form-item>
                    <!-- 文章分类 -->
                    <el-form-item label="文章分类" :label-width="formLabelWidth" prop="category">
                        <el-select v-model="form.category" placeholder="请选文章分类">
                            <el-option v-for="(v,i) in categoryData" :key="i" :label="v.name" :value="v.id" ></el-option>
                        </el-select>
                    </el-form-item>
                    <!-- 文章简介 -->
                    <el-form-item label="文章简介" :label-width="formLabelWidth" prop="description">
                        <el-input v-model="form.description" autocomplete="off"></el-input>
                    </el-form-item>
                    <!-- 视频链接 -->
                    <el-form-item v-if="form.category==isVideo('Vlog')" label="视频链接" :label-width="formLabelWidth" >
                        <el-input v-model="form.video_src" autocomplete="off"></el-input>
                    </el-form-item>
                    <!-- 缩略图 -->
                    <el-form-item label="缩略图" :label-width="formLabelWidth" prop="minpic_url">
                        <form id="minPicForm" method="post" enctype="multipart/form-data">
                            <!-- 单图片上传 -->
                            <el-upload
                                class="avatar-uploader"
                                v-model="form.minpic_url"
                                action="'string'"
                                list-type="picture-card"
                                :auto-upload="false"
                                :show-file-list="false"
                                :on-change="handleCrop"
                                :http-request="upload"
                            >
                                <img
                                    v-if="imageUrl"
                                    :src="imageUrl"
                                    class="avatar"
                                    ref="singleImg"
                                    @mouseenter="mouseEnter"
                                    @mouseleave="mouseLeave"
                                    :style="{width:width+'px',height:height+'px'}"
                                />
                                <i
                                    v-else
                                    class="el-icon-plus avatar-uploader-icon"
                                    :style="{width:width+'px',height:height+'px','line-height':height+'px','font-size':height/6+'px'}"
                                ></i>
                                <!-- 单图片上传状态显示 -->
                                <!-- <div v-if="imageUrl" class="reupload" ref="reupload" @click.stop="handlePreviewSingle" @mouseenter="mouseEnter" @mouseleave="mouseLeave" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}">重新上传</div> -->
                                <div
                                    id="uploadIcon"
                                    v-if="imageUrl"
                                    ref="reupload"
                                    @mouseenter="mouseEnter"
                                    @mouseleave="mouseLeave"
                                    :style="{width:'100%'}"
                                >
                                    <i
                                        class="el-icon-zoom-in"
                                        title="查看原图"
                                        @click.stop="handlePreviewSingle"
                                        :style="{color:'#2E2E2E',fontSize:'25px',display:'inline-block',paddingRight:'15px'}"
                                    ></i>
                                    <i
                                        class="el-icon-refresh-right"
                                        title="重新上传"
                                        :style="{color:'#2E2E2E',fontSize:'25px',display:'inline-block'}"
                                    ></i>
                                </div>
                                <div
                                    class="reupload"
                                    ref="uploading"
                                    :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}"
                                >上传中..</div>
                                <div
                                    class="reupload"
                                    ref="failUpload"
                                    :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}"
                                >上传失败</div>
                            </el-upload>
                            <el-dialog :visible.sync="dialogVisible" :modal-append-to-body="true">
                                <img width="100%" :src="dialogImageUrl" alt />
                            </el-dialog>
                            <!-- 剪裁组件弹窗 -->
                            <el-dialog
                                :visible.sync="cropperModel"
                                width="800px"
                                :before-close="beforeClose"
                                :modal-append-to-body="true"
                            >
                                <Cropper
                                    :img-file="file"
                                    ref="vueCropper"
                                    :fixedNumber="fixedNumber"
                                    @upload="upload"
                                ></Cropper>
                            </el-dialog>
                            <!-- 剪裁组件弹窗 -->
                            <!-- 新上的cropper组件 -->
                        </form>
                    </el-form-item>
                    <!-- 文章内容 -->
                    <el-form-item label="文章内容" :label-width="formLabelWidth" prop="content">
                      <!-- <div id="wangEditor"></div> -->
                      <div id="wangEditor-wrapper">
                        <div id="wangEditor-toolbar"></div>
                        <div id="wangEditor-content" style="height: 300px;"></div>
                      </div>
                    </el-form-item>
                </el-form>
                <div id="drawer-footer" class="demo-drawer__footer">
                    <el-button @click="dialog = false; editorDestroy();">取 消</el-button>
                    <!-- <el-button type="primary" @click="$refs.drawer.closeDrawer()" :loading="loading" >{{ loading ? '提交中 ...' : '确 定' }}</el-button> -->
                    <el-button type="primary" @click="submit" :loading="loading" >{{ loading ? '提交中 ...' : '确 定' }}</el-button>
                </div>
            </div>
        </el-drawer>
    </div>
</template>

<script>
const { Boot, createEditor, createToolbar } = window.wangEditor;
import CommentCom from './CommentManage' // 评论模块
import Cropper from './Cropper'
import { IsURL, deepClone } from "../../../utils/utils"
export default {
    data() {
        return {
            originArticleData: null, // 接口传过来的
            articleData: [ // 转化好的文章列表格式
                // {
                //   id: 'sadfsadfsdaf',
                //   title: 'aaa',
                //   category: 'AA',
                //   user: 'kk',
                //   addtime: '2016-05-02',
                //   num: 188
                // }
            ],
            total: 1, // 总条数
            pages: 1, // 总页数
            curPage: 1, // 当前页
            drawer_title: '',
            imageUrl: '', // 文章title缩略图
            categoryData: [], // 分类列表
            table: false,
            dialog: false,
            dialogType: null, // 判断是添加还是编辑
            loading: false,
            curChosenArcData: {}, // 当前选中文章的评论数据
            commentModel: false, // 评论模块弹窗
            hideUpload: false, //   缩略图上传按钮隐藏
            limitCount: 1, //   缩略图上传按钮隐藏
            minpic_url_list: [], // 缩略图列表
            //   cropper配置------------------------------------------------------
            file: '', // 当前被选择的图片文件
            imageUrl: '', // 单图情况框内图片链接
            dialogImageUrl: '', // 多图情况弹窗内图片链接
            uploadList: [], // 上传图片列表
            reupload: true, // 控制"重新上传"开关
            dialogVisible: false, // 展示弹窗开关
            cropperModel: false, // 剪裁组件弹窗开关
            reuploadWidth: this.height * 0.7, // 动态改变”重新上传“大小
            //   cropper配置------------------------------------------------------

            form: {
                title: '',
                category: '',
                description: '',
                video_src: '',
                content: '',
                minpic_url: '',
            },
            isShow: "1",
            formLabelWidth: '90px',
            editor: null, // wangEditor编辑器实例
            editorOption: { //   富文本编辑器配置
            },
            rules: { // 校验规则
                title: [{ required: true, message: '写一下文章标题啦', trigger: 'blur' }],
                category: [{ required: true, message: '选一下文章类型啦', trigger: 'blur' }],
                minpic_url: [{ required: true, message: '没有上传封面图片噢', trigger: 'blur' }],
                description: [{ required: true, message: '选一下文章类型啦', trigger: 'blur' }],
                content: [{ required: true, message: '文章没有写东西呢', trigger: 'blur' }],
            },
        }
    },
    //   *************cropper组件配置****************
    props: {
        targetUrl: {
            // 上传地址
            type: String,
            // default: '/pic/upload'
            default: '/pic/img_upload'
        },
        multiple: {
            // 多图开关
            type: Boolean,
            default: false
        },
        initUrl: {
            // 初始图片链接
            default: ''
        },
        fixedNumber: {
            // 剪裁框比例设置
            default: function () {
                return [1.5416666666666667, 1]
            }
        },
        width: {
            // 单图剪裁框宽度
            type: Number,
            default: 148
        },
        height: {
            // 单图剪裁框高度
            type: Number,
            default: 96
        }
    },
    //   *************cropper组件配置****************
    components: {
        Cropper,
        CommentCom
    },
    created() {
        this.getArticles();
    },
    mounted() {
        if (typeof this.initUrl === 'string') {
            this.imageUrl = this.initUrl
        } else {
            this.uploadList = this.formatImgArr(this.initUrl)
        }
    },
    updated() {
        if (this.$refs.vueCropper) {
            this.$refs.vueCropper.Update()
        }
    },
    watch: {
        initUrl: function (val) {
            // 监听传入初始化图片
            console.info('watch')
            console.info(val)
            if (val) {
                if (typeof this.initUrl === 'string') {
                    this.imageUrl = val
                } else {
                    this.uploadList = this.formatImgArr(val)
                }
            }
        }
    },
    methods: {
        rest() { //   重置表单
            for (var key in this.form) {
                this.form[key] = ''
            }
            // 暂时先写死一个
            this.form["minpic_url"] = 'http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca';
        },
        handleClose(done) { //   在关闭窗口前的处理操作
            this.confirmClose(this.close, done)
        },
        confirmClose(flag, done) { // 确认删除
            if (flag) {
                done();
                this.flag = null;
                return false;
            }
            this.$confirm('保存草稿功能未开放, 确定要关闭吗 ?')
                .then(_ => {
                    this.editorDestroy()
                    done();
                })
                .catch(_ => { });
        },
        setIdColumn({ row, column, rowIndex }) { // cell不换行
            if (column.property == 'id') {
                return 'cell_nowrap'
            }
            else if (column.label == '操作') {
                return 'btn_flex'
            }
        },
        getArticles() {  // 获取文章列表
            this.getCates().then(_=>{
                this.$axios({ url: '/admin/articles', params: { pageNo: this.curPage, pageSize: 5 }, method: 'get' })
                    .then(res => {
                        this.total = res.data.data[0].total; // 总共的数量
                        this.pages = Math.ceil(this.total/5);
                        // 先保存原格式的文章信息
                        this.originArticleData = res.data.data;
                        var newContents = [];
                        res.data.data.forEach(v => {
                            newContents.push({
                                id: v.id,
                                title: v.title,
                                category: ( _id => {
                                    var res = this.categoryData.filter(v=>{
                                        return v.id==_id;
                                    });
                                    return res.length==0?'unknown':res[0].name;
                                })(v.category),
                                addtime: v.addtime,
                                viewnum: v.viewnum,
                                isShow: v.is_show == '0' ? '是' : '否',
                                comment_num: v.comment_num
                            })
                        })
                        this.articleData = newContents; // 格式化后的文章信息
                    })
            })
        },
        checkComment(params) { // 查看评论模块
            this.commentModel = true;
            this.curChosenArcData = params;
        },
        pageChange(currentPage) { // 点击分页按钮
            this.curPage = currentPage;
            this.getArticles();
        },
        getCates() { // 获取文章分类
            var params = { serchType:'all'};
            return new Promise((resolve,reject)=>{
                this.$axios({ url: '/admin/categories',params })
                    .then(res => {
                        this.categoryData = res.data.data
                        resolve()
                    })
            })
        },
        submit() { // 文章提交事件
            this.$refs.form.validate((valid) => {
                if (!valid) { // 如果不合法
                    return
                } else {
                    if (this.form.category == 'unknown') {
                        this.$message({ type: 'warning', message: '请选择一个文章分类' })
                        return
                    }
                    if (this.dialogType == 'add') { // 添加文章
                        this.form.isShow = this.isShow;
                        this.$axios({
                            url: "/admin/articles/add",
                            method: "post",
                            data: this.form
                        }).then(res => {
                            if (res.data.code == 1) {
                                this.$message({
                                    type: 'success',
                                    message: "添加文章成功 !"
                                });
                            } else {
                                this.$message({
                                    type: 'danger',
                                    message: '添加失败, 请联系管理员 !'
                                });
                            }                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                 
                        }).then(() => {
                            this.getArticles()
                            this.close = true;
                            this.$refs.drawer.closeDrawer();
                        })
                    }
                    if (this.dialogType == 'edit') { // 编辑文章
                        // 需要对content内容进行字符转义, 否则会出事, 主要可能是pre标签的内容出现引号会出事
                        this.form.content = this.form.content.replace(/'/g,"\\'").replace(/"/g,'\\"');
                        this.$axios({
                            url: '/admin/articles/edit',
                            method: 'post',
                            data: this.form
                        }).then(res => {
                            if (res.data.code == 1) {
                                this.$message({
                                    type: 'success',
                                    message: "修改文章成功 !"
                                });
                            } else {
                                this.$message({
                                    type: 'danger',
                                    message: '修改失败, 请联系管理员 !'
                                });
                            }
                        }).then(() => {
                            this.getArticles()
                            this.close = true;
                            this.$refs.drawer.closeDrawer();
                        })
                    }
                }
            });
        },
        handleDelete(index, row) { // 删除文章
            this.$confirm('永久删除文章【"' + row.title + '】", 是否继续?', '提示', {
                confirmButtonText: '确定',
                cancelButtonText: '取消',
                type: 'warning'
            }).then(() => {
                this.$axios({
                    url: '/admin/articles/del',
                    method: 'post',
                    data: { id: row.id }
                }).then(res => {
                    if (res.data.code == 1) {
                        this.$message({
                            type: 'success',
                            message: "删除文章成功 !"
                        });
                    } else {
                        this.$message({
                            type: 'danger',
                            message: '删除失败, 请联系管理员 !'
                        });
                    }
                }).then(() => {
                    this.getArticles()
                })
            }).catch(() => {
                this.$message({
                    type: 'info',
                    message: '已取消删除'
                });
            });

        },
        handleEdit(index, row) { // 编辑文章
            this.minpic_url_list = [] // 先清空
            let id = row.id
            let nowForm = {};
            this.originArticleData.map(v => {
                if (v.id == id) {
                    nowForm = v
                }
            });
            nowForm.category = row.category
            nowForm.content = nowForm.composition
            nowForm.id = id
            this.categoryData.map(v => { if (v.name == nowForm.category) nowForm.category = v.id })
            this.form = nowForm
            this.dialogType = 'edit'
            if (nowForm.minpic_url != "") {
                this.minpic_url_list.push({ url: nowForm.minpic_url })
                this.imageUrl = nowForm.minpic_url
                this.form.minpic_url = nowForm.minpic_url
            } else {
                this.hideUpload = false
            }
            this.isShow = row.is_show == '是' ? '1' : '0';
            this.$nextTick(_=>{
                // this.editor.txt.html(this.form.composition);
                this.editor.setHtml(this.form.composition)
            })
        },

        /* ********* wangEditor编辑器的配置 *********** */
        editorInit () {
          const that = this;
          const editorConfig = {
            placeholder: "请编辑博文内容...",
            autoFocus: false,
            onCreated(editor) {
              editor.getMenuConfig("uploadImage").customUpload = (file, insertFn) => {
                let tempForm = new FormData();
                tempForm.append('file', file);
                const uploading = that.$loading({
                  lock: true,
                  text: '图片上传中...',
                  spinner: 'el-icon-loading',
                  background: 'rgba(0, 0, 0, 0.7)'
                });
                that.$axios.post('/pic/img_upload',tempForm).then(res => {
                    if (res.status==200) {
                        insertFn(res.data.imageUrl)
                    } else {
                      alert('上传失败!')                      
                    }
                    uploading.close()
                })
              }
            },
            onChange(editor) {
              const html = editor.getHtml();
              that.form.content = html
            },
          };

          this.$nextTick(() => {
            that.editor = Object.seal(createEditor({
              selector: "#wangEditor-content",
              html: "",
              config: editorConfig,
              mode: "defalut", // 'default' or 'simple'
            }));
            createToolbar({
              editor: that.editor,
              selector: "#wangEditor-toolbar",
              // config:
              mode: "defalut"
            })
          })
        },
        internetPic (src) { // 上传网络图片成功回调
            // console.log(src);
        },
        editorDestroy () { // 销毁编辑器
            this.editor.destroy()
            this.editor = null
        },
        /* ********* wangEditor编辑器的配置 *********** */

        /* ************* cropper截图上传 ************** */
        handlePreviewSingle(file) {//点击进行图片展示
            // console.log('aaaaa',this.dialogImageUrl);
            // console.log(this.imageUrl);
            this.dialogImageUrl = this.imageUrl
            this.dialogVisible = true
        },
        mouseEnter() {//鼠标划入显示“重新上传”
            this.$refs.reupload.style.display = 'block'
            if (this.$refs.failUpload.style.display === 'block') {
                this.$refs.failUpload.style.display = 'none'
            }
            this.$refs.singleImg.style.opacity = '0.6'
        },
        mouseLeave() {
            // 鼠标划出隐藏“重新上传”
            this.$refs.reupload.style.display = 'none'
            this.$refs.singleImg.style.opacity = '1'
        },
        handleCrop(files, fileList) {
            // 点击弹出剪裁框
            this.cropperModel = true
            this.file = files
            //  this.imageUrl = file.url
        },
        upload(data) {
            // 自定义upload事件
            this.$refs.uploading.style.display = 'block'
            const imgData = new FormData();
            const fileName = 'minpic_' + new Date().Format('yyyy_MM_dd_hh_mm_ss') + '.'
            const fileOfBlob = new File([data], fileName + data.type.split('/')[1]);
            imgData.append('file', fileOfBlob);
            imgData.image = fileOfBlob;
            this.$axios.post(this.targetUrl, imgData).then(res => {
                // 上传完成后隐藏正在上传
                this.$refs.uploading.style.display = 'none'
                if (res.status === 200) {
                    // 上传成功将照片传回父组件
                    const currentPic = res.data.imageUrl
                    this.$emit('imgupload', currentPic)
                    this.imageUrl = currentPic
                    this.form.minpic_url = currentPic
                    // console.log('上传成功,url为 ', this.imageUrl)
                } else {
                    // 上传失败则显示上传失败，如多图则从图片列表删除图片
                    this.$refs.failUpload.style.display = 'block'
                }
            })
            this.cropperModel = false
        },
        formatImgArr(arr) {
            const result = arr.map((item, index) => {
                if (typeof item === 'string') {
                    return {
                        url: item,
                        uid: `index${index}`
                    }
                } else {
                    return item.url
                }
            })
            return result
        },
        beforeClose(done) {
            this.uploadList.pop()
            this.cropperModel = false
        },
        /* ************* cropper截图上传 ************** */
        isVideo(val) {
            let temp = null;
            this.categoryData.forEach(v => { if (v.name == val) temp = v.id; });
            return temp;
        }
    }
}
</script>

<style lang="less" scoped>
// 分割线样式
.pager_divider{
    margin: 10px 0;
}
.avatar {
    background-size: cover;
    background-position: center center;
    background-repeat: no-repeat;
    width: 148px;
    height: 96px;
    max-height: 96px;
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
    width: 148px;
    height: 96px;
    line-height: 96px;
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

#drawer-footer {
  margin-bottom: 10px;
  position: absolute;
  // left: 15px;
  bottom: 0;
  background-color: #fff;
  padding: 15px 0;
  width: 100%;
}

// *********************** wangEditor富文本编辑器 ************************
#wangEditor-wrapper {
  border-radius: 3px;
  border: 1px solid rgba(0, 0, 0, .1);
}
#wangEditor-toolbar {
  border-bottom: 1px solid rgba(0, 0, 0, .1);
}
#wangEditor{
    padding: 10px;
}
#article {
    padding: 15px;
}
</style>