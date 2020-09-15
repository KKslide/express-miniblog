<template>
    <div id="lineChart"></div>
</template>

<script>
import echarts from "echarts";
export default {
    data() {
        return { chartEle: null }
    },
    props: [],
    methods: {
        getChart() {
            this.chartEle = echarts.init(document.getElementById("lineChart"))
            let option = {
                title: {
                    text: '24小时访客记录概览',
                    x: 'left',
                    y: 'top',
                    textStyle: {
                        color: "#FFF",
                        fontWeight: "bold"
                    }
                },
                tooltip: {
                    trigger: 'axis',
                    formatter: function (params) {
                        return `<div>
                        <span style="display:inline-block;width:8px;height:8px;background:#3db9dc;border-radius:50%;"></span>
                        时间：${params[0].axisValue}:00</div>
                        <div><span style="display:inline-block;width:8px;height:8px;background:#f1b53d;border-radius:50%;"></span>
                        ${params[0].seriesName + ": " + params[0].value}
                        </div>`;
                    }
                },
                legend: {
                    show: false,
                    // color: ["#F58080", "#47D8BE", "#F9A589"],
                    // data: ['新报', '流失', '续费'],
                    // left: 'center',
                    // bottom: 'bottom',
                },
                grid: {
                    top: '15%',
                    left: '3%',
                    right: '4%',
                    bottom: '3%',
                    height: '80%',
                    containLabel: true
                },
                xAxis: {
                    type: 'category',
                    // data: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23],
                    data: this.propData.time,
                    axisLine: {
                        lineStyle: {
                            color: "#999"
                        }
                    },
                    axisLabel: {
                        color: "#FFF"
                    }
                },
                yAxis: {
                    type: 'value',
                    splitLine: {
                        lineStyle: {
                            type: 'dashed',
                            color: '#DDD'
                        }
                    },
                    axisLine: {
                        show: false,
                        lineStyle: {
                            color: "#333"
                        },
                    },
                    nameTextStyle: {
                        color: "#999"
                    },
                    splitArea: {
                        show: false
                    },
                    axisLabel: {
                        color: "#FFF"
                    },
                    interval: 1
                },
                series: [
                    {
                        name: '访客数',
                        type: 'line',
                        // data: Array.from({ length: 24 }, (v, k) => v = parseInt(Math.random() * 1000)),
                        data: this.propData.value,
                        color: "#F58080",
                        lineStyle: {
                            normal: {
                                width: 5,
                                color: {
                                    type: 'linear',

                                    colorStops: [{
                                        offset: 0,
                                        color: '#FFCAD4' // 0% 处的颜色
                                    }, {
                                        offset: 0.4,
                                        color: '#F58080' // 100% 处的颜色
                                    }, {
                                        offset: 1,
                                        color: '#F58080' // 100% 处的颜色
                                    }],
                                    globalCoord: false // 缺省为 false
                                },
                                shadowColor: 'rgba(245,128,128, 0.5)',
                                shadowBlur: 10,
                                shadowOffsetY: 7
                            }
                        },
                        itemStyle: {
                            normal: {
                                color: '#F58080',
                                borderWidth: 10,
                                /*shadowColor: 'rgba(72,216,191, 0.3)',
                                 shadowBlur: 100,*/
                                borderColor: "#F58080"
                            }
                        },
                        smooth: true,
                    },
                    // {
                    //     name: '流失',
                    //     type: 'line',
                    //     data: [123, 568, 111, 222, 123, 56],
                    //     lineStyle: {
                    //         normal: {
                    //             width: 5,
                    //             color: {
                    //                 type: 'linear',

                    //                 colorStops: [{
                    //                     offset: 0,
                    //                     color: '#AAF487' // 0% 处的颜色
                    //                 },
                    //                 {
                    //                     offset: 0.4,
                    //                     color: '#47D8BE' // 100% 处的颜色
                    //                 }, {
                    //                     offset: 1,
                    //                     color: '#47D8BE' // 100% 处的颜色
                    //                 }
                    //                 ],
                    //                 globalCoord: false // 缺省为 false
                    //             },
                    //             shadowColor: 'rgba(71,216,190, 0.5)',
                    //             shadowBlur: 10,
                    //             shadowOffsetY: 7
                    //         }
                    //     },
                    //     itemStyle: {
                    //         normal: {
                    //             color: '#AAF487',
                    //             borderWidth: 10,
                    //             /*shadowColor: 'rgba(72,216,191, 0.3)',
                    //              shadowBlur: 100,*/
                    //             borderColor: "#AAF487"
                    //         }
                    //     },
                    //     smooth: true
                    // },
                    // {
                    //     name: '续费',
                    //     type: 'line',
                    //     data: [125, 568, 25, 36, 784, 56],
                    //     lineStyle: {
                    //         normal: {
                    //             width: 5,
                    //             color: {
                    //                 type: 'linear',

                    //                 colorStops: [{
                    //                     offset: 0,
                    //                     color: '#F6D06F' // 0% 处的颜色
                    //                 },
                    //                 {
                    //                     offset: 0.4,
                    //                     color: '#F9A589' // 100% 处的颜色
                    //                 }, {
                    //                     offset: 1,
                    //                     color: '#F9A589' // 100% 处的颜色
                    //                 }
                    //                 ],
                    //                 globalCoord: false // 缺省为 false
                    //             },
                    //             shadowColor: 'rgba(249,165,137, 0.5)',
                    //             shadowBlur: 10,
                    //             shadowOffsetY: 7
                    //         }
                    //     },
                    //     itemStyle: {
                    //         normal: {
                    //             color: '#F6D06F',
                    //             borderWidth: 10,
                    //             /*shadowColor: 'rgba(72,216,191, 0.3)',
                    //              shadowBlur: 100,*/
                    //             borderColor: "#F6D06F"
                    //         }
                    //     },
                    //     smooth: true
                    // }
                ]
            };
            this.chartEle.setOption(option)
        },
        chartResize(){
            this.chartEle.resize()
        }
    },
    props: ['propData'],
    watch: {
        propData(val) {
            this.getChart()
        }
    },
    beforeDestroy(){
        this.chartEle.dispose()
    }
}
</script>

<style lang="less" scoped>
#lineChart {
    width: 100%;
    height: 100%;
}
</style>