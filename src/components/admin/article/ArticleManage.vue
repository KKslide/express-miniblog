<template>
  <div id="article">
    <!-- 文章列表 -->
    <el-table :data="articleData" border style="width: 100%">
      <el-table-column prop="_id" label="文章ID"></el-table-column>
      <el-table-column prop="title" label="文章标题"></el-table-column>
      <el-table-column prop="category" label="文章分类"></el-table-column>
      <el-table-column prop="user" label="作者"></el-table-column>
      <el-table-column label="添加时间">
        <template slot-scope="scope">
          <p>{{scope.row.addtime|date}}</p>
        </template>
      </el-table-column>
      <el-table-column prop="num" label="阅读量"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="dialog=true; handleEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 抽屉组件 -->
    <!-- <el-button type="text" @click="table = true">打开嵌套表格的 Drawer</el-button> -->
    <el-button
      type="text"
      @click="dialog = true;dialogType='add'; rest();drawer_title='添加文章';minpic_url_list=[];"
    >添加文章</el-button>
    <el-drawer
      :title="drawer_title"
      :before-close="handleClose"
      :visible.sync="dialog"
      :destroy-on-close="true"
      direction="btt"
      custom-class="demo-drawer"
      ref="drawer"
      size="80%"
    >
      <div class="demo-drawer__content" style="padding:0 15px 10px 15px;">
        <el-form :model="form" ref="form" :rules="rules">
          <!-- 文章标题 -->
          <el-form-item label="文章标题" :label-width="formLabelWidth" prop="title">
            <el-input v-model="form.title" autocomplete="off"></el-input>
          </el-form-item>
          <!-- 文章分类 -->
          <el-form-item label="文章分类" :label-width="formLabelWidth" prop="category">
            <el-select v-model="form.category" placeholder="请选文章分类">
              <el-option v-for="(v,i) in categoryData" :key="i" :label="v.name" :value="v._id"></el-option>
            </el-select>
          </el-form-item>
          <!-- 文章简介 -->
          <el-form-item label="文章简介" :label-width="formLabelWidth" prop="description">
            <el-input v-model="form.description" autocomplete="off"></el-input>
          </el-form-item>
          <!-- 文章简介2 -->
          <el-form-item label="文章描述" :label-width="formLabelWidth">
            <el-input v-model="form.description_sub" autocomplete="off"></el-input>
          </el-form-item>
          <!-- 缩略图 -->
          <el-form-item label="缩略图" :label-width="formLabelWidth" prop="minpic_url">
            <form id="minPicForm" method="post" enctype="multipart/form-data">
              <!-- :http-request="handleUpload" -->
              <!-- :file-list="ad_url_list" -->
              <el-upload
                ref="upload"
                action="/admin/content/mpic_upload"
                :auto-upload="false"
                :class="{'noshow':hideUpload,'avatar-uploader':true}"
                list-type="picture-card"
                :file-list="minpic_url_list"
                :limit="1"
                :on-success="handleAvatarSuccess"
                :before-upload="beforeAvatarUpload"
                :on-remove="handleRemove"
                :on-exceed="handleExceed"
                :on-change="handleUploadMinPic"
                v-model="form.minpic_url"
              >
                <!-- <img v-if="imageUrl" :src="imageUrl" class="avatar" />
                <i v-else class="el-icon-plus avatar-uploader-icon"></i>-->
                <span class="font-14">选择jpg或png</span>
                <div slot="tip" class="el-upload__tip" style="display:none;">尺寸360*233px, 1M以内</div>
              </el-upload>
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
            <form id="upload" class="hidden" enctype="multipart/form-data" method="post">
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
        <div class="demo-drawer__footer">
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
]
export default {
  data() {
    return {
      originArticleData: [], // 接口传过来的
      articleData: [ // 转化好的文章列表格式
        // {
        //   _id: 'sadfsadfsdaf',
        //   title: 'aaa',
        //   category: 'AA',
        //   user: 'kk',
        //   addtime: '2016-05-02',
        //   num: 188
        // }
      ],
      drawer_title: '',
      imageUrl: '', // 文章title缩略图
      categoryData: [], // 分类列表
      table: false,
      dialog: false,
      dialogType: null, // 判断是添加还是编辑
      loading: false,
      hideUpload: false, //   缩略图上传按钮隐藏
      limitCount: 1, //   缩略图上传按钮隐藏
      minpic_url_list: [], // 缩略图列表

      form: {
        title: '',
        category: '',
        description: '',
        description_sub: '',
        content: '',
        minpic_url: ''
      },
      formLabelWidth: '90px',
      editorOption: { //   富文本编辑器配置
        placeholder: "请在这里编辑文章内容",
        modules: {
          toolbar: {
            container: toolbarOptions,  // 工具栏
            handlers: {
              'image': function (value) {
                if (value) {
                  // alert('自定义图片')
                  document.getElementById("selectImg").click();    //调用选择图片
                } else {
                  this.quill.format('image', false);
                }
              }
            }
          }
        }
      },
      rules: {
        title: [{ required: true, message: '写一下文章标题啦', trigger: 'blur' }],
        category: [{ required: true, message: '选一下文章类型啦', trigger: 'blur' }],
        minpic_url: [{ required: true, message: '没有上传封面图片噢', trigger: 'blur' }],
        description: [{ required: true, message: '选一下文章类型啦', trigger: 'blur' }],
      },
    }
  },
  components: {
    quillEditor
  },
  created() {
    this.getArticles();
    this.getCates();
  },
  methods: {
    //   重置表单
    rest() {
      for (var key in this.form) {
        this.form[key] = ''
      }
    },
    //   在关闭窗口前的处理操作
    handleClose(done) {
      this.confirmClose(this.close, done)
    },
    confirmClose(flag, done) {
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
    // 获取文章列表
    getArticles() {
      this.$axios({ url: '/admin/articles' })
        .then(res => {
          // 先保存原格式的文章信息
          this.originArticleData = res.data;
          var newContents = [];
          res.data.contents.map(v => {
            // this.articleData.push({
            newContents.push({
              _id: v._id,
              title: v.title,
              category: v.category.name,
              user: v.user.username,
              addtime: v.addtime,
              num: v.num,
            })
          })
          this.articleData = newContents; // 格式化后的文章信息
        })
    },
    // 获取文章分类
    getCates() {
      this.$axios({ url: '/admin/categories' })
        .then(res => {
          this.categoryData = res.data.categories
        })
    },
    // 文章提交事件
    submit() {
      this.$refs.form.validate((valid) => {
        if (!valid) {
          if (!this.form.content) this.$message({ type: "danger", message: "没有填写文章内容！" })
          return false
        }
      });
      if (this.dialogType == 'add') {
        this.$axios({
          url: "/admin/articles/add",
          method: "post",
          data: this.form
        }).then(res => {
          if (res.data.code == 1) {
            this.$message({
              type: 'success',
              // message: res.code.msg
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
      if (this.dialogType == 'edit') {
        // console.log(this.form);
        this.$axios({
          url: '/admin/content/edit',
          method: 'post',
          data: this.form
        }).then(res => {
          if (res.data.code == 1) {
            this.$message({
              type: 'success',
              // message: res.code.msg
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
    },
    // 删除文章
    handleDelete(index, row) {
      this.$confirm('永久删除分类"' + row.title + '", 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$axios({
          url: '/admin/articles/del',
          method: 'post',
          data: { id: row._id }
        }).then(res => {
          if (res.data.code == 1) {
            this.$message({
              type: 'success',
              // message: res.code.msg
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
    // 编辑文章
    handleEdit(index, row) {
      this.minpic_url_list = [] // 先清空
      let id = row._id
      let nowForm = {}
      this.originArticleData.contents.map(v => {
        if (v._id == id) {
          nowForm = v
        }
      })
      nowForm.category = row.category
      nowForm.content = nowForm.composition
      nowForm.id = id
      this.categoryData.map(v => { if (v.name == nowForm.category) nowForm.category = v._id })
      this.form = nowForm
      this.dialogType = 'edit'
      if (nowForm.minpic_url != "") {
        this.minpic_url_list.push({ url: nowForm.minpic_url })
      } else {
        this.hideUpload = false
      }
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

    /* ********* 缩略图 图片上传操作 *********** */
    handleExceed: function () {
      this.$alert('请先删除选择的图片或视频，再上传', '提示', {
        type: 'warning'
      });
    },
    handleAvatarSuccess(res, file) {
      this.imageUrl = URL.createObjectURL(file.raw);
    },
    beforeAvatarUpload(file) {
      const isJPG = file.type === 'image/jpeg';
      const isPNG = file.type === 'image/png';
      const isLt2M = file.size / 1024 / 1024 < 2;

      if (!isJPG || !isPNG) {
        this.$message.error('上传头像图片只能是 JPG 或 PNG  格式!');
      }
      if (!isLt2M) {
        this.$message.error('上传头像图片大小不能超过 2MB!');
      }
      return isJPG && isLt2M;
    },
    handleUploadMinPic(files, fileList) {
      let form = document.getElementById("minPicForm");
      let imgData = new FormData(form);
      imgData.image = files.raw;

      this.$axios({
        // url: "/admin/content/mpic_upload",
        // url: "/admin/content/img_upload",
        url: "/pic/upload",
        method: 'post',
        data: imgData
      }).then(res => {
        // console.log(res);
        if (res.status == 200) {
          this.imageUrl = res.data.imageUrl
          this.form.minpic_url = res.data.imageUrl
          //   this.handleAvatarSuccess(res, files)
          this.hideUpload = fileList.length >= this.limitCount;
        }
      })
    },
    handleRemove(file, fileList) {
      this.hideUpload = fileList.length >= this.limitCount;
    }
    /* ********* 缩略图 图片上传操作 *********** */

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