<template>
  <div id="user">
    <el-table :data="users" border style="width: 100%">
      <el-table-column prop="_id" label="ID"></el-table-column>
      <el-table-column prop="username" label="姓名"></el-table-column>
      <el-table-column prop="password" label="密码"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="handleEdit(scope.$index, scope.row)">编辑</el-button>
          <el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
  </div>
</template>

<script>
export default {
  data() {
    return {
      users: []
    }
  },
  beforeCreate() {
    this.$axios({
      url: '/admin/getuser',
      method: 'get'
    }).then(res => {
      this.users = res.data.users
    })
  },
  methods: {
    handleEdit(index, row) {
      console.log(index, row);
    },
    handleDelete(index, row) {
      console.log(index, row);
    }
  }
}
</script>

<style lang="less" scoped>
#user {
  padding: 15px;
}
</style>