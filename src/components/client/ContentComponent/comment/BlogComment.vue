<template>
    <div class="comment" id="log_comment">
        <form class="form-inline" @submit.prevent="dontSubmit">
            <div class="form-group">
                <span class="input input--isao">
                    <div class="textArea">
                        <!-- 改用文本域 -->
                        <textarea
                            id="input__field--isao"
                            class="form-control input__field input__field--isao"
                            rows="3"
                            :placeholder="$t('logContent.commentPlaceHolder')"
                            v-model="commentData.comment"
                        ></textarea>
                        <!-- 黑框修饰 -->
                        <label class="input__label input__label--isao" for="input-38">
                            <span class="input__label-content input__label-content--isao"></span>
                        </label>
                        <div class="emoji_box" ref="emoji_box" @click="showEmojiPanel">
                            <emoji-panel @emojiClick="appendEmoji" v-if="isShowEmojiPanel"></emoji-panel>
                        </div>
                    </div>

                    <label for="visitorEmail">
                        <span v-text="$t('logContent.name')" class="hidden-xs"></span>
                        <input
                            type="text"
                            class="form-control"
                            id="visitorEmail"
                            :placeholder="$t('logContent.namePlaceHolder')"
                            v-model="commentData.visitor"
                        />
                    </label>

                    <button
                        type="submit"
                        class="btn btn-default btn-lg"
                        @click="submitComment"
                        v-text="$t('logContent.sendButton')"
                    ></button>
                </span>
            </div>
        </form>
        <hr />
        <!-- 评论列表 -->
        <ul class="media-list">
            <li class="media" v-for="item in commentList" :key="item.t_id">
                <div class="media-left" v-if="false">
                    <!-- 头像 - 后面再做 -->
                    <a href="javascript:;">
                        <img class="media-object img-circle" src="../../../../../public/static/skull.png" width="50" />
                    </a>
                </div>
                <!-- 评论内容 -->
                <div class="media-body">
                    <h4 class="media-heading" v-if="item.user" style="font-size:18px;">
                        {{item.user}}
                        <span class="ip">|{{item.ip}}|🎈</span> 
                    </h4>
                    <h4 class="media-heading" v-else style="font-size:18px;">somebody</h4>

                    <p v-html="item.comment" class="comment_detail"></p>

                    <div class="ds-comment-footer">
                        <span
                            class="ds-time"
                            datetime="2016-01-28T20:13:29+08:00"
                            :title="item.time | date"
                        >{{item.time | date}}</span>
                        <!-- 先隐藏掉 后面再做这个功能 -->
                        <a v-if="false">
                            <span class="glyphicon glyphicon-comment" aria-hidden="true"></span> 回复
                        </a>
                    </div>
                    <hr />
                    <!-- 这里是回复 - - 还不懂怎么做 -->
                    <ul class="media-list" v-if="false">
                        <li class="media">
                            <div class="media-left">
                                <a href="#">
                                    <img class="media-object img-circle" src alt="牛逼" />
                                </a>
                            </div>
                            <div class="media-body">
                                <h4 class="media-heading">网名为空</h4>

                                <p>test. test. test. test. test. test. test. test.</p>

                                <div class="ds-comment-footer">
                                    <span
                                        class="ds-time"
                                        datetime="2016-01-28T20:13:29+08:00"
                                        title="2016年1月28日 下午8:13:29"
                                    >2016年2月8日</span>&nbsp;
                                    <a>
                                        <span
                                            class="glyphicon glyphicon-comment"
                                            aria-hidden="true"
                                        ></span> 回复
                                    </a>
                                </div>
                            </div>
                        </li>
                        <hr />
                        <li class="media">
                            <div class="media-left">
                                <a href="#">
                                    <img class="media-object img-circle" src alt="牛逼" />
                                </a>
                            </div>
                            <div class="media-body">
                                <h4 class="media-heading">网名为空</h4>

                                <p>test. test. test. test. test. test. test. test.</p>

                                <div class="ds-comment-footer">
                                    <span
                                        class="ds-time"
                                        datetime="2016-01-28T20:13:29+08:00"
                                        title="2016年1月28日 下午8:13:29"
                                    >2016年2月8日</span>&nbsp;
                                    <a>
                                        <span
                                            class="glyphicon glyphicon-comment"
                                            aria-hidden="true"
                                        ></span> 回复
                                    </a>
                                </div>
                            </div>
                        </li>
                    </ul>
                </div>
            </li>
        </ul>
        <!-- 评论列表 -->
    </div>
</template>

<script>
import EmojiPanel from "../../public/emoji/EmojiPanel";
export default {
    props: ['commentDataProp'],
    data() {
        return {
            isShowEmojiPanel: false,
            commentList: [],
            commentData: { // 评论列表
                contentid: '',
                comment: '',
                visitor: ''
            },
        }
    },
    components: {
        EmojiPanel
    },
    methods: {
        // 阻止默认提交
        dontSubmit() { return false },
        submitComment() { // 提交评论
            if (!this.commentData.comment) { // 评论内容为空
                this.$message({ type: "warning", message: this.$t('logContent.emptyCommentTip') })
                return false;
            }
            // if (!this.commentData.visitor) { // 不留名
            //     this.$message({ type: "warning", message: this.$t('logContent.emptyVisitor') })
            //     return false;
            // }
            this.commentData.comment = this.commentData.comment.replace(/:.*?:/g, this.emoji);
            this.commentData.contentid = this.$route.params.contentid;
            this.$axios({
                url: '/index/comment',
                method: "post",
                data: this.commentData
            }).then(res => {
                if (res.data.code == 1) { // 评论成功提示
                    this.$message({ type: "success", message: res.data.msg });
                    this.commentData.comment = '';
                    this.commentData.visitor = '';
                }
                this.$emit('refresh') // 刷新评论
            })
        },
        showEmojiPanel() { // 展示和隐藏表情面板
            this.isShowEmojiPanel = !this.isShowEmojiPanel;
        },
        emoji(word) { // 生成html
            const type = word.substring(1, word.length - 1);
            return `<span class="emoji-item-common emoji-${type} emoji-size-small" ></span>`;
        },
        appendEmoji(text) {
            const el = document.getElementById("input__field--isao");
            // this.content = el.value + ":" + text + ":";
            this.commentData.comment = el.value + ":" + text + ":";
        }
    },
    watch: {
        commentDataProp(nv, ov) {
            this.commentList = nv;
        }
    },
    created() {
        // 添加 click 事件句柄  判断点击事件是否发生在某元素上
        document.addEventListener('click', event => {
            const e = event || window.event
            if (this.$refs.emoji_box && !this.$refs.emoji_box.contains(e.target)) {
                this.isShowEmojiPanel = false;
            }
        })
    }
}
</script>

<style lang="scss">
#log_comment {
    .form-inline {
        // 评论表单
        .form-group {
            width: 100%;
            .input {
                position: relative;
                z-index: 1;
                display: inline-block;
                margin: 1em;
                width: calc(100% - 2em);
                vertical-align: top;
                .textArea {
                    position: relative;

                    .input__field:focus {
                        outline: none;
                    }

                    /* Isao */
                    .input__field {
                        position: relative;
                        display: block;
                        padding: 0.8em;
                        width: 60%;
                        border-radius: 0;
                        background: #f0f0f0;
                        color: #aaa;
                        font-weight: bold;
                        font-family: "Helvetica Neue", Helvetica, Arial,
                            sans-serif;
                        -webkit-appearance: none; /* for box shadows to show on iOS */
                    }

                    .input__field--isao {
                        z-index: 10;
                        padding: 0.75em 0.2em 0.25em;
                        width: 100%;
                        background: transparent;
                        color: #afb3b8;
                    }

                    .input__label--isao {
                        position: relative;
                        overflow: hidden;
                        padding: 0;
                        width: 100%;
                        color: #dadada;
                        text-align: left;
                    }

                    .input__label--isao::before {
                        content: "";
                        position: absolute;
                        top: 0;
                        width: 100%;
                        height: 7px;
                        background: #dadada;
                        -webkit-transform: scale3d(1, 0.4, 1);
                        transform: scale3d(1, 0.4, 1);
                        -webkit-transform-origin: 50% 100%;
                        transform-origin: 50% 100%;
                        -webkit-transition: -webkit-transform 0.3s,
                            background-color 0.3s;
                        transition: transform 0.3s, background-color 0.3s;
                        -webkit-transition-timing-function: cubic-bezier(
                            0.2,
                            1,
                            0.3,
                            1
                        );
                        transition-timing-function: cubic-bezier(
                            0.2,
                            1,
                            0.3,
                            1
                        );
                    }

                    .input__label--isao::after {
                        content: attr(data-content);
                        position: absolute;
                        top: 0;
                        left: 0;
                        padding: 0.75em 0.15em;
                        //   color: #da7071; // 改为映衬一点的色调
                        color: #333;
                        opacity: 0;
                        -webkit-transform: translate3d(0, 50%, 0);
                        transform: translate3d(0, 50%, 0);
                        -webkit-transition: opacity 0.3s, -webkit-transform 0.3s;
                        transition: opacity 0.3s, transform 0.3s;
                        -webkit-transition-timing-function: cubic-bezier(
                            0.2,
                            1,
                            0.3,
                            1
                        );
                        transition-timing-function: cubic-bezier(
                            0.2,
                            1,
                            0.3,
                            1
                        );
                        pointer-events: none;
                    }

                    .input__field--isao:focus + .input__label--isao::before {
                        //   background-color: #da7071;
                        background-color: #333;
                        -webkit-transform: scale3d(1, 1, 1);
                        transform: scale3d(1, 1, 1);
                    }

                    .input__field--isao:focus + .input__label--isao {
                        pointer-events: none;
                    }

                    .input__field--isao:focus + .input__label--isao::after {
                        opacity: 1;
                        -webkit-transform: translate3d(0, 0, 0);
                        transform: translate3d(0, 0, 0);
                    }

                    .input__label-content--isao {
                        padding: 0.55em 0.15em;
                        -webkit-transition: opacity 0.3s, -webkit-transform 0.3s;
                        transition: opacity 0.3s, transform 0.3s;
                        -webkit-transition-timing-function: cubic-bezier(
                            0.2,
                            1,
                            0.3,
                            1
                        );
                        transition-timing-function: cubic-bezier(
                            0.2,
                            1,
                            0.3,
                            1
                        );
                    }

                    .input__field--isao:focus
                        + .input__label--isao
                        .input__label-content--isao {
                        opacity: 0;
                        -webkit-transform: translate3d(0, -50%, 0);
                        transform: translate3d(0, -50%, 0);
                    }

                    .emoji_box {
                        width: 20px;
                        height: 20px;
                        position: absolute;
                        bottom: 42px;
                        left: 3px;
                        border-radius: 50%;
                        z-index: 99;
                        cursor: pointer;
                    }
                    .emoji_box::after {
                        content: "";
                        width: 20px;
                        height: 20px;
                        background-image: url("../../../../assets/images/face_logo.png");
                        background-size: contain;
                        position: absolute;
                        left: 0;
                        top: 0;
                        z-index: -1;
                        opacity: 0.5;
                        transition: opacity 0.2s;
                    }
                    .emoji_box:hover::after {
                        opacity: 0.8;
                    }
                    // ------------------------------
                    .emoji-item-common {
                        background: url("../../../../assets/images/emoji_sprite.png");
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
            }
            /* BlogComment.vue中的央视覆盖 */
            // 转移到vue-cli4后 新的样式很怪异, 补右侧边距
            label[for='visitorEmail']{
                margin-right: 10px;
                span{
                    margin-right: 10px;
                }
            }
        }
    }
    .media-list {
        // 评论列表
        a {
            text-decoration: none;
            color: #5f5f5f;
            cursor: pointer;
        }
        a:link {
            text-decoration: none;
        }
        a:visited {
            text-decoration: none;
        }
        a:hover {
            text-decoration: none;
            color: #e5e1ea;
        }
        a:active {
            text-decoration: none;
        }

        p.comment_detail {
            margin: 0 0 10px;
            word-wrap: break-word;
            .emoji-item-common {
                background: url("../../../../assets/images/emoji_sprite.png");
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
        .ds-comment-footer {
            line-height: 1.5em;
        }
        .ip {
            font-size: 15px;
            font-weight: normal;
        }
    }
}
</style>