<template>
    <div id="admin_home">
        <div class="admin_top_list">
            <a
                class="admin_top_list_item"
                v-for="(item,index) in tag_data"
                :key="index"
                :style="{'background':bg_colors[index]}"
                @click="jump(item.href)"
            >
                <div class="admin_top_list_item_L">
                    <p>{{item.tag}}</p>
                    <p>{{item.value}}</p>
                </div>
                <div class="admin_top_list_item_R">
                    <i :class="item.icon"></i>
                </div>
            </a>
        </div>
        <div class="admin_mid_chart">
            <div class="line_chart">
                <line-chart :propData="line_chart_data" ref="lineChart"></line-chart>
            </div>
            <div class="pie_chart">
                <pie-chart :propData="pie_chart_data" ref="pieChart"></pie-chart>
            </div>
        </div>
        <div class="admin_bottom_clock">
            <clock></clock>
        </div>
    </div>
</template>

<script>
import LineChart from './LineChart'; // 折线图
import PieChart from './PieChart'; // 饼图
import Clock from "./Clock"; // 时钟
export default {
    data() {
        return {
            bg_colors: ['#64b0f2', '#f1b53d', '#3db9dc', '#ff5d48'],
            tag_data: [
                { icon: 'el-icon-document' },
                { icon: 'el-icon-data-line' },
                { icon: 'el-icon-user' },
                { icon: 'el-icon-notebook-1', href: 'article' },
            ],
            line_chart_data: [],
            pie_chart_data: []
        }
    },
    components: {
        'line-chart': LineChart,
        'pie-chart': PieChart,
        'clock': Clock
    },
    methods: {
        jump(href) {
            if (href) {
                this.$router.push({ name: href })
            } else {
                return
            }
        },
        getData() {
            this.$axios({
                url: '/admin/getgeneral',
                method: 'get'
            }).then(res => {
                this.tag_data = this.tag_data.map((v, i) => {
                    return v = Object.assign(res.data.tag_list[i], v)
                })
                this.line_chart_data = this.fixedObj(res.data.line_chart_data)
                this.pie_chart_data = res.data.pie_chart_data
            })
        },
        fixedObj(data) {
            let obj = {}, keys = [];
            data.forEach(e => keys = keys.concat(Object.keys(e))); // 先拿到所有的keys, 去重
            Array.from(new Set([...keys])).forEach(ele => {
                obj[ele] = data.map(val => val[ele])
            });
            return obj;
        }
    },
    mounted() {
        document.querySelector("body").style.background = "#131417";
        this.getData();
        window.onresize = _ => {
            this.$refs.lineChart && this.$refs.lineChart.chartResize();
            this.$refs.pieChart && this.$refs.pieChart.chartResize();
        }
    },
    beforeDestroy() {
        document.querySelector("body").style.background = ""
    }
}
</script>

<style lang="less" scoped>
#admin_home {
    padding: 5px;
    .admin_top_list {
        display: flex;
        justify-content: space-around;
        .admin_top_list_item {
            width: 25%;
            margin: 3px 10px;
            padding: 15px;
            display: flex;
            justify-content: space-between;
            cursor: pointer;
            text-decoration: none;
            transition: all 0.3s;
            border-radius: 15px;
            div {
                width: 50%;
                display: flex;
                justify-content: space-around; //x轴排列
                align-items: center; //y轴排列
            }
            .admin_top_list_item_L {
                flex-direction: column;
                p {
                    font-size: 15px;
                    margin: 0;
                    color: #fff;
                }
                p:last-child {
                    font-size: 20px;
                }
            }
            .admin_top_list_item_R {
                // justify-content: center; //x轴排列
                // align-items: center; //y轴排列
                i {
                    font-size: 50px;
                    // font-weight: bold;
                    color: #fff;
                }
            }
        }
        .admin_top_list_item:nth-child(1):hover {
            background: #6ebafd;
            box-shadow: 0 0 3px #75cdf6, 0 0 5px #75cdf6, 0 0 10px #75cdf6,
                0 0 15px #75cdf6, 0 0 30px #1194ff, 0 0 5px #45bbff,
                0 0 40px #1194ff;
        }
        .admin_top_list_item:nth-child(2):hover {
            background: #ffc043;
            box-shadow: 0 0 3px #f1b53d, 0 0 5px #f1b53d, 0 0 10px #f1b53d,
                0 0 15px #f1b53d, 0 0 20px #ff9823, 0 0 5px #ffac3f,
                0 0 40px #ff9823;
        }
        .admin_top_list_item:nth-child(3):hover {
            background: #3db9dc;
            box-shadow: 0 0 3px #3db9dc, 0 0 5px #3db9dc, 0 0 10px #3db9dc,
                0 0 15px #3db9dc, 0 0 20px #28a9ff, 0 0 5px #22cbff,
                0 0 40px #28a9ff;
        }
        .admin_top_list_item:nth-child(4):hover {
            background: #ff5d48;
            box-shadow: 0 0 3px #ff5d48, 0 0 5px #ff5d48, 0 0 10px #ff5d48,
                0 0 15px #ff5d48, 0 0 20px #ff491b, 0 0 5px #22cbff,
                0 0 40px #ff4e22;
        }
    }
    .admin_mid_chart {
        display: flex;
        justify-content: space-around;
        div {
            height: 40vh;
            margin: 8px;
        }
        .line_chart {
            width: 60%;
        }
        .pie_chart {
            width: 40%;
        }
    }
    .admin_bottom_clock {
        height: 35vh;
        // position: relative;
        display: flex;
        justify-content: center;
        align-items: center;
    }
}
</style>