<template>
    <div>
        <header-com></header-com>
        <div class="section-container">
            <div class="container">
                <div class="row">
                    <div class="col-xs-12">
                        <div class="section-container-spacer text-center">
                            <h1 class="h2" v-text="$t('navbar.Contact')"></h1>
                        </div>

                        <div class="row">
                            <div class="col-md-10 col-md-offset-1">
                                <!-- 留言表单 -->
                                <form action class="reveal-content" @submit.prevent="submit">
                                    <div class="row">
                                        <div class="col-md-7">
                                            <div class="form-group">
                                                <input type="text" class="form-control" id="email" :placeholder="$t('contact.placeholder.one')" v-model="viewer" />
                                            </div>
                                            <!-- 留言框 -->
                                            <div class="form-group msg_textarea">
                                                <textarea
                                                    id="msg_textarea"
                                                    class="form-control"
                                                    rows="5"
                                                    :placeholder="$t('contact.placeholder.three')"
                                                    v-model="message"
                                                ></textarea>
                                                <!-- emoji按钮 -->
                                                <div class="emoji_btn" ref="contact_emoji_btn" @click="showEmojiPanel">
                                                    <emoji-panel @emojiClick="appendEmoji" v-if="isShowEmojiPanel"></emoji-panel>
                                                </div>
                                            </div>
                                            <button type="submit" class="btn btn-default btn-lg" v-text="$t('contact.placeholder.four')" ></button>
                                        </div>
                                        <!-- 个人信息展示 -->
                                        <div class="col-md-5 address-container">
                                            <ul class="list-unstyled">
                                                <li>
                                                    <span class="fa-icon">
                                                        <i class="fa fa-phone" aria-hidden="true"></i>
                                                    </span> +86 131 4335 2449
                                                </li>
                                                <li>
                                                    <span class="fa-icon">
                                                        <i class="fa fa-at" aria-hidden="true"></i>
                                                    </span>
                                                    <!-- rollercompanion@163.com -->
                                                    {{ $t('contact.mail')}}
                                                </li>
                                                <li>
                                                    <span class="fa-icon">
                                                        <i
                                                            class="fa fa fa-map-marker"
                                                            aria-hidden="true"
                                                        ></i>
                                                    </span>
                                                    <!-- GuangZhou MingPu-Garden China -->
                                                    {{ $t('contact.addr')}}
                                                </li>
                                            </ul>
                                            <h3 v-text="$t('contact.social')">
                                                <!-- Follow me on social networks -->
                                            </h3>
                                            <a
                                                href="https://www.facebook.com/profile.php?id=100025250295698"
                                                title="facebook"
                                                class="fa-icon"
                                            >
                                                <i class="fa fa-facebook"></i>
                                            </a>
                                            <a
                                                href="https://twitter.com/KK_slide"
                                                title="twitter"
                                                class="fa-icon"
                                            >
                                                <i class="fa fa-twitter"></i>
                                            </a>
                                            <a
                                                href="https://www.instagram.com/kangkang1105_/"
                                                title="instagram"
                                                class="fa-icon"
                                            >
                                                <i class="fa fa-instagram"></i>
                                            </a>
                                            <a
                                                href="https://weibo.com/kkslide"
                                                title="weibo"
                                                class="fa-icon"
                                            >
                                                <i class="fa fa-weibo"></i>
                                            </a>
                                        </div>
                                    </div>
                                </form>
                                <hr />
                                <!-- 留言列表 -->
                                <ul class="media-list" id="msg_list">
                                    <li class="media" v-for="(item,index) in totalData.slice(0,a)" :key="index" >
                                        <!-- 评论内容 -->
                                        <div class="media-body">
                                            <h4
                                                class="media-heading"
                                                v-if="item.viewer"
                                                v-html="item.viewer+':'"
                                                style="font-size:18px;"
                                            ></h4>

                                            <div class="commentText">
                                                <input type="checkbox" :id="'expended'+item.id" />
                                                <p v-html="item.message" :ref="item.id"></p>
                                                <label :for="'expended'+item.id" role="button" v-showbtn >show more</label>
                                            </div>
                                            <div class="ds-comment-footer">
                                                <span
                                                    class="ds-time"
                                                    datetime="2019-01-28T20:13:29+08:00"
                                                    :title="item.addtime | date"
                                                >{{item.addtime | date}}</span>&nbsp;
                                                <!-- 先隐藏掉 后面再做这个功能 -->
                                                <a v-if="false">
                                                    <span class="glyphicon glyphicon-comment" aria-hidden="true" ></span> 回复
                                                </a>
                                            </div>
                                            <hr />
                                        </div>
                                    </li>
                                    <li style="list-style:none;">
                                        <a
                                            href="javascript:;"
                                            v-if="totalData.length==0"
                                            style="text-decoration:none;cursor:default;"
                                            v-text="$t('contact.first')"
                                        ></a>
                                        <a
                                            href="javascript:;"
                                            v-else-if="a<totalData.length"
                                            @click="loadmore"
                                            style="text-decoration:none;"
                                            v-text="$t('contact.loadmore')"
                                        ></a>
                                        <!-- there is no more -->
                                        <span
                                            v-else
                                            style="text-decoration:none;"
                                            v-text="$t('contact.nomore')"
                                        ></span>
                                    </li>
                                    <hr />
                                </ul>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <footer-com></footer-com>
    </div>
</template>

<script>
import Header from '../public/Header'
import Footer from "../public/Footer";
import EmojiPanel from "./emoji/EmojiPanel.vue";
export default {
    components: {
        'header-com': Header,
        'footer-com': Footer,
        'emoji-panel':EmojiPanel
    },
    data() {
        return {
            viewer: '', // 用户昵称或邮箱
            subject: '', 
            message: '', // 留言内容
            a: 5, // 显示留言的数量
            totalData: [], // 留言的列表数据
            isShowEmojiPanel: false,
        }
    },
    directives: {
        showbtn: {
            inserted(el, bindings) {
                let rowNum = Math.round($(el).prev().height()) / parseFloat($(el).prev().css('line-height'))
                if (rowNum != 3) {
                    el.style.display = 'none'
                } else {
                    $(el).prev().addClass('block')
                }
            }
        }
    },
    methods: {
        submit() { // 留言
            if (!this.viewer || !this.message) {
                this.$message({ type: 'warning', message: this.$i18n.t('contact.warning') })
                return;
            }
            this.message = this.message.replace(/:.*?:/g, this.emoji);
            this.$axios({
                url: '/index/message/add',
                method: 'post',
                data: {
                    viewer: this.viewer,
                    subject: this.subject,
                    message: this.message
                }
            }).then(res => {
                let msgType={type:'',message:this.$t('contact.responsemsg')};
                msgType.type=res.data.code == 1?'success':'warning';
                this.$message(msgType);
                this.getData();
                $(".reveal-content")[0].reset(); // 我也不晓得为啥这个不成功
                this.resetForm();
            })
        },
        // 重置留言板
        resetForm() { this.viewer = ''; this.subject = ''; this.message = ''; },
        getData() { // 获取留言
            this.$axios({
                url: "/index/message/get"
            }).then(res => {
                this.totalData = res.data.reverse()
            })
        },
        loadmore() { // 加载更多
            this.a += 5;
        },
        showEmojiPanel() { // 展示和隐藏表情面板
            this.isShowEmojiPanel = !this.isShowEmojiPanel;
        },
        emoji(word) { // 生成html
            const type = word.substring(1, word.length - 1);
            return `<span class="emoji-item-common emoji-${type} emoji-size-small" ></span>`;
        },
        appendEmoji(text) { // 添加emoji到留言板中
            const el = document.getElementById("msg_textarea");
            this.message = el.value + ":" + text + ":";
        }
    },
    mounted() {
        this.getData()
    },
    created() {
        // 添加 click 事件句柄  判断点击事件是否发生在某元素上
        document.addEventListener('click', event => {
            const e = event || window.event
            if (this.$refs.contact_emoji_btn && !this.$refs.contact_emoji_btn.contains(e.target)) {
                this.isShowEmojiPanel = false;
            }
        })
    }
}
</script>

<style lang="less">
#msg_list{
    // 用来隐藏长文本
    .commentText {
        input {
            opacity: 0;
            position: absolute;
            pointer-events: none;
        }
        p {
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
            overflow: hidden;
            margin: 0;
            position: relative;
            .emoji-item-common {
                background: url("../../../assets/images/emoji_sprite.png");
                display: inline-block;
                &:hover {
                    cursor: default;
                }
            }
            .emoji-size-small {
                // 表情大小
                zoom: 0.3;
            }
            .emoji-size-large {
                zoom: 0.5; // emojipanel表情大小
                margin: 4px;
            }
        }
        p.block::after {
            content: "";
            position: absolute;
            left: 0;
            bottom: 0;
            width: 100%;
            height: 15px;
            background: linear-gradient(
                to bottom,
                rgba(255, 255, 255, 0.3),
                rgba(255, 255, 255, 1)
            );
        }
        input:focus ~ label {
            outline: -webkit-focus-ring-color auto 5px;
        }
        input:checked + p {
            -webkit-line-clamp: unset;
        }
        input:checked + p::after {
            opacity: 0;
        }
        input:checked ~ label {
            display: none;
        }
    }
}
// emoji按钮
.msg_textarea{
    position: relative;
    .emoji_btn {
        width: 20px;
        height: 20px;
        position: absolute;
        bottom: 3px;
        left: 3px;
        border-radius: 50%;
        z-index: 99;
        cursor: pointer;
    }
    .emoji_btn::after {
        content: "";
        width: 20px;
        height: 20px;
        background-image: url("../../../assets/images/face_logo.png");
        background-size: contain;
        position: absolute;
        left: 0;
        top: 0;
        z-index: -1;
        opacity: 0.5;
        transition: opacity 0.2s;
    }
    .emoji_btn:hover::after {
        opacity: 0.8;
    }
    // ------------------------------
    .emoji-item-common {
        background: url("../../../assets/images/emoji_sprite.png");
        display: inline-block;
        &:hover {
            cursor: pointer;
        }
    }
    .emoji-size-small {
        // 表情大小
        zoom: 0.3;
    }
    .emoji-size-large {
        zoom: 0.5; // emojipanel表情大小
        margin: 4px;
    }
}
// *****************************************************
@import url("../../../assets/css/emoji.css");
</style>
