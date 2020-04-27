<template>
  <div>
    <!-- 多图片上传 -->
    <el-upload v-if="multiple" action="string" list-type="picture-card" :on-preview="handlePreview" :auto-upload="false" :on-remove="handleRemove" :http-request="upload" :on-change="consoleFL" :file-list="uploadList" >
      <i class="el-icon-plus"></i>
    </el-upload>
    <!-- 单图片上传 -->
    <el-upload v-else class="avatar-uploader" action="'string'" list-type="picture-card" :auto-upload="false" :show-file-list="false" :on-change="handleCrop" :http-request="upload" >
      <img v-if="imageUrl" :src="imageUrl" class="avatar" ref="singleImg" @mouseenter="mouseEnter" @mouseleave="mouseLeave" :style="{width:width+'px',height:height+'px'}" />
      <i v-else class="el-icon-plus avatar-uploader-icon" :style="{width:width+'px',height:height+'px','line-height':height+'px','font-size':height/6+'px'}" ></i>
      <!-- 单图片上传状态显示 -->
      <!-- <div v-if="imageUrl" class="reupload" ref="reupload" @click.stop="handlePreviewSingle" @mouseenter="mouseEnter" @mouseleave="mouseLeave" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}">重新上传</div> -->
      <div id="uploadIcon" v-if="imageUrl" ref="reupload" @mouseenter="mouseEnter" @mouseleave="mouseLeave" :style="{width:'100%'}" >
        <i class="el-icon-zoom-in" @click.stop="handlePreviewSingle" :style="{color:'#2E2E2E',fontSize:'25px',display:'inline-block',paddingRight:'15px'}" ></i>
        <i class="el-icon-upload" :style="{color:'#2E2E2E',fontSize:'25px',display:'inline-block'}"></i>
      </div>
      <div class="reupload" ref="uploading" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}" >上传中..</div>
      <div class="reupload" ref="failUpload" :style="{width:reuploadWidth+'px',height:reuploadWidth+'px','line-height':reuploadWidth+'px','font-size':reuploadWidth/5+'px'}" >上传失败</div>
    </el-upload>
    <!-- 多图片预览弹窗 -->
    <el-dialog :visible.sync="dialogVisible">
      <img width="100%" :src="dialogImageUrl" alt />
    </el-dialog>
    <!-- 剪裁组件弹窗 -->
    <el-dialog :visible.sync="cropperModel" width="800px" :before-close="beforeClose">
      <Cropper :img-file="file" ref="vueCropper" :fixedNumber="fixedNumber" @upload="upload"></Cropper>
    </el-dialog>
  </div>
</template>
<script>
import Cropper from './cropper.vue'
export default {
  name: 'uploader',
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
        return [16, 9]
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
  data() {
    return {
      file: '', // 当前被选择的图片文件
      imageUrl: '', // 单图情况框内图片链接
      dialogImageUrl: '', // 多图情况弹窗内图片链接
      uploadList: [], // 上传图片列表
      reupload: true, // 控制"重新上传"开关
      dialogVisible: false, // 展示弹窗开关
      cropperModel: false, // 剪裁组件弹窗开关
      reuploadWidth: this.height * 0.7 // 动态改变”重新上传“大小
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
  mounted() {
    if (typeof this.initUrl === 'string') {
      this.imageUrl = this.initUrl
    } else {
      this.uploadList = this.formatImgArr(this.initUrl)
    }
  },
  methods: {
    /** **************************** multiple多图情况 **************************************/
    handlePreview(file) {
      // 点击进行图片展示
      this.dialogImageUrl = file.url
      this.dialogVisible = true
    },
    handleRemove(file, fileList) {
      // 删除图片后更新图片文件列表并通知父级变化
      this.uploadList = fileList
      this.$emit('imgupload', this.formatImgArr(this.uploadList))
    },
    consoleFL(file, fileList) {
      // 弹出剪裁框，将当前文件设置为文件
      this.cropperModel = true
      this.file = file
      this.uploadList = fileList
    },
    /************************************************************************************/

    /****************************** single单图情况 **************************************/
    handlePreviewSingle(file) {//点击进行图片展示
      this.dialogImageUrl = this.file.url
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
    /************************************************************************************/

    upload(data) {
      // 自定义upload事件
      if (!this.multiple) {
        // 如果单图，则显示正在上传
        this.$refs.uploading.style.display = 'block'
      }
      let imgData = new FormData();
      imgData.append('file', data);
      imgData.image = data;
      this.$axios.post(this.targetUrl, imgData).then(res => {
        // console.log(res);
        if (!this.multiple) {
          // 上传完成后隐藏正在上传
          this.$refs.uploading.style.display = 'none'
        }
        if (res.status === 200) {
          // 上传成功将照片传回父组件
          const currentPic = res.data.imageUrl
          if (this.multiple) {
            this.uploadList.push({
              url: currentPic,
              uid: '111'
            })
            this.uploadList.pop()
            this.$emit('imgupload', this.formatImgArr(this.uploadList))
          } else {
            this.$emit('imgupload', currentPic)
            this.imageUrl = currentPic
          }
        } else {
          // 上传失败则显示上传失败，如多图则从图片列表删除图片
          if (!this.multiple) {
            this.$refs.failUpload.style.display = 'block'
          } else {
            this.uploadList.pop()
          }
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
    }
  },
  components: {
    Cropper
  }
}
</script>
<style scoped>
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
</style>
