<template>
  <div>
    <div class="hide-video-box"></div>
    <el-upload
      class="avatar-uploader"
      ref="upload"
      :action="upload_url"
      list-type="picture-card"
      :name="upload_name"
      :on-remove="handleRemove"
      :on-exceed="handleExceed"
      :file-list="ad_url_list"
      :limit="1"
      :http-request="uploadSectionFile"
    >
      <!-- :show-file-list="false" -->
      <!-- 
      <span class="font-14">选择图片或视频</span>
      <div slot="tip" class="el-upload__tip">尺寸750*1125px，大小2M以内，视频支持MP4</div>
      -->
      <img v-if="imageUrl" :src="imageUrl" class="avatar" />
      <i v-else class="el-icon-plus avatar-uploader-icon"></i>
    </el-upload>
  </div>
</template>

<script>
export default {
  data: function () {
    return {
      imageUrl: '',
      upload_url: '',//上传URL
      upload_name: '',//图片或视频名称
      ad_url: '',//上传后的图片或视频URL
      ad_url_list: [],//预览列表
    }
  },
  methods: {
    handleExceed: function () {
      this.$alert('请先删除选择的图片或视频，再上传', '提示', {
        type: 'warning'
      });
    },
    handleRemove: function (res, file) {
      var self = this;
      self.ad_url = '';
      var liItem = document.getElementsByClassName('hide-video-box')[0];
      liItem.innerHTML = '';
    },
    uploadSectionFile: function (params) {
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
      } else if (isVideo) {
        var isMP4 = file.type === 'video/mp4';
        if (!isMP4) {
          this.$alert('上传视频只支持 mp4 格式!', '提示', { type: 'error' });
          self.$refs.upload.uploadFiles = [];
          return;
        }
        var videoDiv = document.createElement('video');
        var liItem = document.getElementsByClassName('hide-video-box')[0];
        videoDiv.src = file_url;
        liItem.appendChild(videoDiv);

        videoDiv.onloadeddata = function (event) {
          var target = event.target;
          var width = target.offsetWidth;
          var height = target.offsetHeight;

          if (width !== 750 || height != 1125) {
            this.$alert('视频尺寸为750*1125px', '提示', { type: 'error' });
            //将上传列表清空
            self.$refs.upload.uploadFiles = [];
            return;
          }

          //视频上传
          self.upload_url = '你的视频上传URL';
          self.upload_name = 'file_video[]';
          self.uploadFile(file, isVideo, videoDiv);
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
