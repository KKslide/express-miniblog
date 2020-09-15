<template>
    <div id="pieChart"></div>
</template>

<script>
import echarts from 'echarts'
export default {
    data() {
        return { chartEle: null }
    },
    methods: {
        getChart() {
            this.chartEle = echarts.init(document.getElementById("pieChart"))
            let option = {
                title: {
                    text: '文章分类概览',
                    x: 'left',
                    y: 'top',
                    textStyle: {
                        color: "#FFF",
                        fontWeight: "bold"
                    }
                },
                color: ['#e38980', '#f7db88', '#85b6b2', '#6d4f8d', '#cd5e7e'],
                tooltip: {
                    trigger: 'item',
                    formatter: "{a}[{b}] <br/>数量: {c}<br/>占比: {d}%"
                },
                calculable: true,
                series: [
                    {
                        name: '分类',
                        type: 'pie',
                        radius: ['15%', '60%'],
                        roseType: 'area',
                        // data: [
                        //     { value: 10, name: 'rose1' },
                        //     { value: 5, name: 'rose2' },
                        //     { value: 15, name: 'rose3' },
                        //     { value: 25, name: 'rose4' },
                        //     { value: 20, name: 'rose5' },
                        // ],
                        data: this.propData,
                        itemStyle: {
                            normal: {
                                shadowBlur: 30,
                                shadowColor: 'rgba(40, 40, 40, 0.5)',
                            }
                        },
                        label: {
                            fontSize: '16',
                            borderWidth: '1',
                            borderColor: '#fff',
                            borderRadius: 5,
                            padding: [4, 10]
                        },
                        labelLine: {
                            length: 8,
                            length2: 4
                        }
                    }
                ]
            };
            this.chartEle.setOption(option)
        },
        chartResize() {
            this.chartEle.resize()
        }
    },
    props: ['propData'],
    watch: {
        propData(val) {
            this.getChart()
        }
    },
    beforeDestroy() {
        this.chartEle.dispose()
    },
}
</script>

<style lang="less" scoped>
#pieChart {
    width: 100%;
    height: 100%;
}
</style>