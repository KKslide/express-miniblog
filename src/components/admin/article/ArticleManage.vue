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
            <el-table-column label="添加时间" width="190">
                <template slot-scope="scope">
                    <p>{{scope.row.addtime|date}}</p>
                </template>
            </el-table-column>
            <el-table-column prop="num" label="阅读量"></el-table-column>
            <el-table-column prop="comment_count" label="评论">
                <template slot-scope="scope">
                    <el-button
                        @click="checkComment(scope.row)"
                        type="text"
                        size="normal"
                    >{{scope.row.comment_count}}</el-button>
                </template>
            </el-table-column>
            <el-table-column prop="isShow" label="是否显示"></el-table-column>
            <el-table-column label="操作">
                <template slot-scope="scope">
                    <el-button
                        size="mini"
                        @click="dialog=true; handleEdit(scope.$index, scope.row)"
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

        <!-- <el-button type="text" @click="table = true">打开嵌套表格的 Drawer</el-button> -->
        <el-button
            type="text"
            @click="dialog = true;dialogType='add'; rest();drawer_title='添加文章';minpic_url_list=[];imageUrl='http://example.kkslide.fun/upload_6aa9339ff86b4ba10446744336f486ca'"
            style="float:right;margin-right:20px;"
        >添加文章</el-button>

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
            <div class="demo-drawer__content" style="padding:0 15px 10px 15px;">
                <el-form :model="form" ref="form" :rules="rules">
                    <!-- 文章标题 -->
                    <el-form-item label="文章标题" :label-width="formLabelWidth" prop="title">
                        <el-input v-model="form.title" autocomplete="off"></el-input>
                    </el-form-item>
                    <!-- 是否显示 -->
                    <el-form-item label="是否显示" :label-width="formLabelWidth" prop="isShow">
                        <el-switch
                            v-model="isShow"
                            active-color="#13ce66"
                            inactive-color="#ff4949"
                            active-value="1"
                            inactive-value="0"
                        ></el-switch>(绿色为开启显示,选择关闭则不会在页面中显示)
                    </el-form-item>
                    <!-- 文章分类 -->
                    <el-form-item label="文章分类" :label-width="formLabelWidth" prop="category">
                        <el-select v-model="form.category" placeholder="请选文章分类">
                            <el-option
                                v-for="(v,i) in categoryData"
                                :key="i"
                                :label="v.name"
                                :value="v.id"
                            ></el-option>
                        </el-select>
                    </el-form-item>
                    <!-- 文章简介 -->
                    <el-form-item label="文章简介" :label-width="formLabelWidth" prop="description">
                        <el-input v-model="form.description" autocomplete="off"></el-input>
                    </el-form-item>
                    <!-- 视频链接 -->
                    <el-form-item
                        v-if="form.category==isVideo('Video')"
                        label="视频链接"
                        :label-width="formLabelWidth"
                    >
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
                        <quill-editor
                            ref="myQuillEditor"
                            v-model="form.content"
                            class="myQuillEditor"
                            :options="editorOption"
                        />
                        <form
                            id="upload"
                            class="hidden"
                            enctype="multipart/form-data"
                            method="post"
                        >
                            <!--用来上传图片-->
                            <input
                                type="file"
                                name="image"
                                id="selectImg"
                                accept="image/gif, image/jpeg, image/png"
                                @change="inputChangeImg"
                                multiple
                            />
                            <input type="button" value="提交" @click="uploadPic" />
                        </form>
                    </el-form-item>
                </el-form>
                <div class="demo-drawer__footer" style="margin-bottom:10px;">
                    <el-button @click="dialog = false">取 消</el-button>
                    <!-- <el-button type="primary" @click="$refs.drawer.closeDrawer()" :loading="loading" >{{ loading ? '提交中 ...' : '确 定' }}</el-button> -->
                    <el-button
                        type="primary"
                        @click="submit"
                        :loading="loading"
                    >{{ loading ? '提交中 ...' : '确 定' }}</el-button>
                </div>
            </div>
        </el-drawer>
    </div>
</template>

<script>
import CommentCom from './CommentManage'
import Cropper from './cropper.vue'
import { quillEditor } from 'vue-quill-editor'
import 'quill/dist/quill.core.css'
import 'quill/dist/quill.snow.css'
import 'quill/dist/quill.bubble.css'
const toolbarOptions = [ // 富文本编辑器配置
    ['bold', 'italic', 'underline', 'strike'],        // toggled buttons
    ['blockquote', 'code-block'],
    [{ 'header': 1 }, { 'header': 2 }],               // custom button values
    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
    [{ 'script': 'sub' }, { 'script': 'super' }],      // superscript/subscript
    [{ 'indent': '-1' }, { 'indent': '+1' }],          // outdent/indent
    [{ 'direction': 'rtl' }],                         // text direction
    [{ 'size': ['small', false, 'large', 'huge'] }],  // custom dropdown
    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
    [{ 'color': [] }, { 'background': [] }],          // dropdown with defaults from theme
    [{ 'font': [] }],
    [{ 'align': [] }],
    ['link', 'image', 'video'],
    ['clean']                                         // remove formatting button
];
let that;
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
            editorOption: { //   富文本编辑器配置
                placeholder: "请在这里编辑文章内容",
                modules: {
                    toolbar: {
                        container: toolbarOptions,  // 工具栏
                        handlers: {
                            'image': function (value) {
                                if (value) {
                                    document.getElementById("selectImg").click();    //调用选择图片
                                } else {
                                    this.quill.format('image', false);
                                }
                            }
                        }
                    }
                }
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
            default: '/pic/upload'
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
        quillEditor,
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
                    done();
                    //   this.loading = true;
                    //   setTimeout(() => {
                    //     this.loading = false;
                    //     done();
                    //   }, 100);
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
                this.$axios({ url: '/admin/articles', params: { page: this.curPage }, method: 'get' })
                    .then(res => {
                        this.total = res.data.total;
                        this.pages = res.data.pages;
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
                                num: v.num,
                                isShow: v.isShow == 1 ? '是' : '否',
                                comment_count: 0,
                                comment: v.comment
                            })
                        })
                        this.articleData = newContents; // 格式化后的文章信息
                        this.isShow = newContents.isShow
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
                        this.form.isShow = this.isShow;
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
            this.isShow = nowForm.isShow + "" || "0"
        },
        /* ********* 富文本编辑器图片上传操作 *********** */
        selectImg() {  //选择图片
            document.getElementById("selectImg").click();
        },
        inputChangeImg: function () { // input 选择图片时的操作
            let that = this;
            let input = document.getElementById('selectImg');
            if (input.files && input.files[0]) {
                let item = input.files[0];
                let reader = new FileReader();
                reader.readAsDataURL(item);
                reader.onload = function () {
                    let url = this.result;
                    that.uploadPic(item).then(res => {
                        that.handleSuccess(res.data)
                    })
                }
            }
        },
        handleSuccess(res) {
            let quill = this.$refs.myQuillEditor.quill
            let length = quill.getSelection().index;    // 获取光标所在位置
            quill.insertEmbed(length, 'image', res.imageUrl);   // 插入图片  res.url为服务器返回的图片地址  
            quill.setSelection(length + 1);              // 调整光标到最后
        },
        uploadPic: function (item) {  //提交图片
            let form = document.getElementById('upload'),
                formData = new FormData(form);
            formData.file = item;
            //   return this.$axios({ url: "/admin/content/img_upload", method: "post", data: formData }) // 调用接口上传图片
            return this.$axios({ url: "/pic/upload", method: "post", data: formData }) // 调用接口上传图片
        },
        /* ********* 富文本编辑器图片上传操作 *********** */

        /* ************* cropper截图上传 ************** */
        handlePreviewSingle(file) {//点击进行图片展示
            console.log('aaaaa',this.dialogImageUrl);
            console.log(this.imageUrl);
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
            let imgData = new FormData();
            imgData.append('file', data);
            imgData.image = data;
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

<style lang="less"scoped>
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

// *********************** 富文本编辑器 ************************
#article {
    padding: 15px;
}
.editor {
    line-height: normal !important;
    height: 800px;
}
.ql-snow .ql-tooltip[data-mode="link"]::before {
    content: "请输入链接地址:";
}
.ql-snow .ql-tooltip.ql-editing a.ql-action::after {
    border-right: 0px;
    content: "保存";
    padding-right: 0px;
}

.ql-snow .ql-tooltip[data-mode="video"]::before {
    content: "请输入视频地址:";
}

.ql-snow .ql-picker.ql-size .ql-picker-label::before,
.ql-snow .ql-picker.ql-size .ql-picker-item::before {
    content: "14px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="small"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="small"]::before {
    content: "10px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="large"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="large"]::before {
    content: "18px";
}
.ql-snow .ql-picker.ql-size .ql-picker-label[data-value="huge"]::before,
.ql-snow .ql-picker.ql-size .ql-picker-item[data-value="huge"]::before {
    content: "32px";
}

.ql-snow .ql-picker.ql-header .ql-picker-label::before,
.ql-snow .ql-picker.ql-header .ql-picker-item::before {
    content: "文本";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before {
    content: "标题1";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before {
    content: "标题2";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before {
    content: "标题3";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before {
    content: "标题4";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before {
    content: "标题5";
}
.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before,
.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before {
    content: "标题6";
}

.ql-snow .ql-picker.ql-font .ql-picker-label::before,
.ql-snow .ql-picker.ql-font .ql-picker-item::before {
    content: "标准字体";
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="serif"]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="serif"]::before {
    content: "衬线字体";
}
.ql-snow .ql-picker.ql-font .ql-picker-label[data-value="monospace"]::before,
.ql-snow .ql-picker.ql-font .ql-picker-item[data-value="monospace"]::before {
    content: "等宽字体";
}
.ql-align-center {
    text-align: center;
}
.ql-align-right {
    text-align: right;
}
.ql-align-left {
    text-align: left;
}
</style>