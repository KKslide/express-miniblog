<template>
  <div>
    <el-upload
      :class="{'noshow':hideUpload,'avatar-uploader':true}"
      ref="upload"
      :action="upload_url"
      list-type="picture-card"
      :name="upload_name"
      :on-remove="handleRemove"
      :on-exceed="handleExceed"
      :on-change="handleChange"
      :file-list="ad_url_list"
      :auto-upload="false"
      :limit="1"
    >
      <!-- :http-request="uploadSectionFile" -->
      <span class="font-14">选择jpg或png</span>
      <div slot="tip" class="el-upload__tip" style="display:none;">尺寸360*233px, 1M以内</div>
    </el-upload>
  </div>
</template>

<script>
export default {
  data() {
    return {
      upload_url: '',//上传URL
      upload_name: '',//图片或视频名称
      ad_url: '',//上传后的图片或视频URL
      ad_url_list: [],//预览列表
      hideUpload: false,
      limitCount: 1
    };
  },
  methods: {
    handleExceed: function () {
      this.$alert('请先删除选择的图片或视频，再上传', '提示', {
        type: 'warning'
      });
    },
    handleRemove: function (file, fileList) {
      var self = this;
      self.ad_url = '';
      this.hideUpload = fileList.length >= this.limitCount;
    },
    handleChange(file, fileList) {
      this.hideUpload = fileList.length >= this.limitCount;
    },
    uploadSectionFile: function (params) {
      console.log(params);
      var self = this,
        file = params.file,
        fileType = file.type,
        isImage = fileType.indexOf('image') != -1,
        isVideo = fileType.indexOf('video') != -1,
        file_url = self.$refs.upload.uploadFiles[0].url;

      var isLt2M = file.size / 1024 / 1024 < 2;
      if (!isLt2M) {
        this.$alert('上传图片或视频大小不能超过 2MB!', '提示', { type: 'error' });
        self.$refs.upload.uploadFiles = [];
        return;
      }

      if (!isImage && !isVideo) {
        this.$alert('请选择图片或视频!', '提示', { type: 'error' });
        self.$refs.upload.uploadFiles = [];
        return;
      }

      if (isImage) {
        var img = new Image();
        img.src = file_url;
        img.onload = function () {
          //   if (img.width !== 750 || img.height != 1125) {
          //     this.$alert('图片尺寸为750*1125px', '提示', { type: 'error' });
          //     //将上传列表清空
          //     self.$refs.upload.uploadFiles = [];
          //     return;
          //   }
          //图片上传
          self.upload_url = '你的图片上传URL';
          self.upload_name = 'file_img[]';
          self.uploadFile(file, isVideo, '');
        }
      }
    },
    uploadFile: function (file, isVideo, videoDiv) {
      var self = this,
        formData = new FormData();
      formData.append(self.upload_name, file);

      axios.post(self.upload_url, formData, { headers: { 'Content-Type': 'multipart/form-data' } })
        .then(function (res) {
          if (res.result === '0000') {
            self.ad_url = res.data[0];
            //创建一个显示video的容器
            if (isVideo) {
              var liItem = document.getElementsByClassName('el-upload-list__item')[0];
              videoDiv.style.width = '278px';
              videoDiv.style.height = '415px';
              liItem.prepend(videoDiv);
            }
            return;
          }
          this.$alert('上传失败，请重新上传', '提示', { type: 'error' });
          self.$refs.upload.uploadFiles = [];
        })
        .catch(function (err) {
          console.error(err);
        });
    }

  }
}
</script>

<style scoped>
.avatar {
  background-size: cover;
  background-position: center center;
  background-repeat: no-repeat;
  max-height: 148px;
  margin: 0 auto;
  width: unset !important;
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
  height: 148px;
  line-height: 148px;
  text-align: center;
}
.avatar {
  width: 148px;
  height: 148px;
  display: block;
}
.noshow .el-upload--picture-card {
  display: none;
}
</style>