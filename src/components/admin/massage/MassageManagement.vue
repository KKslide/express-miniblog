<template>
  <div id="massage_list">
    <el-table :data="tableData" stripe style="width: 100%" :cell-class-name="setCell">
      <el-table-column prop="addtime" label="日期">
        <template slot-scope="scope">
          <p>{{scope.row.addtime|date}}</p>
        </template>
      </el-table-column>
      <el-table-column prop="viewer" label="用户/邮箱"></el-table-column>
      <el-table-column prop="massage" label="内容"></el-table-column>
      <el-table-column label="操作">
        <template slot-scope="scope">
          <el-button size="mini" @click="dialog=true; handleCheck(scope.$index, scope.row)">查看</el-button>
          <el-button size="mini" type="danger" @click="handleDelete(scope.$index, scope.row)">删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <!-- 弹窗组件 -->
    <el-dialog title="留言详情" :visible.sync="dialogTableVisible">
      <el-form :label-position="labelPosition" label-width="100px">
        <el-form-item label="时间">
          <div v-html="fixedTime" class="chosen_content"></div>
          <!-- <div class="chosen_content">{{chosen.addtime|date}}</div> -->
        </el-form-item>
        <el-form-item label="用户/邮箱">
          <el-input v-model="chosen.viewer" disabled class="disabled"></el-input>
        </el-form-item>
        <el-form-item label="主题">
          <el-input v-model="chosen.subject" disabled class="disabled"></el-input>
        </el-form-item>
        <el-form-item label="内容">
          <div v-html="chosen.content" class="chosen_content"></div>
        </el-form-item>
      </el-form>
      <span slot="footer" class="dialog-footer">
        <el-button type="primary" @click="dialogTableVisible = false">确 定</el-button>
      </span>
    </el-dialog>
    <!-- 弹窗组件 -->
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
  </div>
</template>

<script>
export default {
  data() {
    return {
      tableData: [],
      curPage: 1,
      total: 1,
      pages: 1,
      dialogTableVisible: false, // 查看详情的弹窗默认不显示
      labelPosition: 'right',
      chosen: {
        viewer: '',
        addtime: '',
        subject: '',
        content: ''
      }
    }
  },
  mounted() {
    this.getMassageList()
  },
  methods: {
    handleCheck(index, row) {
      this.chosen.addtime = row.addtime;
      this.chosen.viewer = row.viewer;
      this.chosen.subject = row.subject;
      this.chosen.content = row.massage;
      this.dialogTableVisible = true;
    },
    handleDelete(index, row) {
      let ids = [];
      ids.push(row._id);
      this.$confirm('永久删除该条留言吗, 是否继续?', '提示', {
        confirmButtonText: '确定',
        cancelButtonText: '取消',
        type: 'warning'
      }).then(() => {
        this.$axios({
          url: "/admin/massage/del",
          data: { ids: ids },
          method: "post"
        }).then(res => {
          if (res.data.code == 1) {
            this.$message({ type: 'success', message: res.data.msg });
          } else {
            this.$message({ type: 'warning', message: res.data.msg });
          }
        }).then(_ => this.getMassageList());
      });
    },
    setCell(row, column, rowIndex, columnIndex) { // 设置类名来更改样式
      if (row.column.label === '内容') {
        return 'cell_nowrap'
      }
    },
    getMassageList() {
      this.$axios({
        url: "/admin/massage",
        method: "get",
        params: { page: this.curPage }
      }).then(res => {
        this.tableData = res.data.massages;
        this.total = res.data.total;
        this.pages = res.data.pages;
      })
    },
    pageChange(currentPage) {
      this.curPage = currentPage;
      this.getMassageList();
    }
  },
  computed: {
    fixedTime: {
      get(val) {
        let date = new Date(val.chosen.addtime);
        return `${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours() >= 10 ? date.getHours() : '0' + date.getHours()}:${date.getMinutes() >= 10 ? date.getMinutes() : '0' + date.getMinutes()}:${date.getSeconds() >= 10 ? date.getSeconds() : '0' + date.getSeconds()}`
      }
    }
  }
}
</script>

<style lang="less" scoped>
#massage_list {
  padding: 15px;
}
.chosen_content {
  border: 1px solid #e4e7ed;
  background-color: #f5f7fa;
  border-radius: 4px;
  padding: 0 15px;
}
</style>