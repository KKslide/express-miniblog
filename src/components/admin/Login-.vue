<template>
  <div class="Land">
    <!-- <div class="topzi">Login</div> -->
    <el-form
      :model="ruleForm"
      status-icon
      :rules="rules"
      ref="ruleForm"
      label-width="100px"
      class="demo-ruleForm"
    >
      <el-form-item prop="username" label="姓名">
        <el-input v-model="ruleForm.username"></el-input>
      </el-form-item>
      <el-form-item label="密码" prop="password">
        <el-input type="password" v-model="ruleForm.password" auto-complete="off"></el-input>
      </el-form-item>
      <el-form-item>
        <el-button type="primary" @click="submitForm('ruleForm')">提交</el-button>
        <el-button @click="resetForm('ruleForm')">重置</el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script>
export default {
  data() {
    return {
      ruleForm: {
        password: '',
        username: ''
      },
      rules: {
        password: [{ required: true, validator: '密码不能为空', trigger: 'blur' }],
        username: [{ required: true, message: '用户名不能为空', trigger: 'blur' }],
      }
    };
  },
  methods: {
    submitForm(formName) {
      this.$refs[formName].validate((valid) => {
        if (valid) {
          this.$axios({
            url: "/admin/login",
            method: "post",
            data: this.ruleForm
          }).then(res => {
            if (res.data.code == 1) {
              this.$message({
                type: 'success',
                message: res.data.msg
              });
              this.$router.push({ name: 'admin' })
            } else {
              this.$message({
                type: 'danger',
                message: res.data.msg
              });
              return false;
            }
          })
        } else {
          console.error('code wrong....');
          return false;
        }
      });
    },
    resetForm(formName) {
      this.$refs[formName].resetFields();
    }
  }
}
</script>

<style scoped>
.topzi {
  font-size: 40px;
  margin-bottom: 40px;
  text-align: center;
}
.Land {
  width: 30%;
  position: fixed;
  top: 50%;
  left: 0;
  transform: translateY(-50%);
  right: 0;
  margin: 0 auto;
  border: 1px solid rgba(0, 0, 0, 0.3);
  box-shadow: 0px 4px 11px 5px rgba(0, 0, 0, 0.5);
  border-radius: 15px;
  padding: 40px 20px 10px 15px;
}
</style>