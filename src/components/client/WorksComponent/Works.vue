<template>
  <div>
    <header-com></header-com>
    <div class="section-container">
      <div class="container worklist">
            <div class="main">
                <!-- 列表样式 -->
                <div class="content">
                    <div class="grid">
                        <!-- 循环体: 根据不同样式, 渲染不同的样式组合 -->
                        <a class="grid__item" v-for="(item,index) in worklist" :key="index" :href="'#preview-'+item.id">
                            <div class="box" v-if="item.style_type=='1'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text"><span class="box__text-inner" v-html="item.tag"></span></h4>
                                <div class="box__deco" v-html="item.symbol"></div>
                                <p class="box__content" v-html='`"${item.description}"`'></p>
                            </div>
                            
                            <div class="box" v-else-if="item.style_type=='2'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title box__title--straight box__title--bottom"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--bottom"><span class="box__text-inner box__text-inner--rotated1" v-html="item.tag"></span></h4>
                                <div class="box__deco box__deco--top" v-html="item.symbol"></div>
                            </div>

                            <div class="box" v-else-if="item.style_type=='3'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--topcloser"><span class="box__text-inner" v-html="item.tag"></span></h4>
                                <div class="box__deco" v-html="item.symbol"></div>
                            </div>

                            <div class="box" v-else-if="item.style_type=='4'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--bottom box__text--right"><span class="box__text-inner box__text-inner--rotated3" v-html="item.tag"></span></h4>
                            </div>

                            <div class="box" v-else-if="item.style_type=='5'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--bottomcloser"><span class="box__text-inner" v-html="item.tag"></span></h4>
                            </div>

                            <div class="box" v-else-if="item.style_type=='6'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text"><span class="box__text-inner" v-html="item.tag"></span></h4>
                                <p class="box__content" v-html="item.description"></p>
                            </div>

                            <div class="box" v-else-if="item.style_type=='7'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title box__title--straight box__title--bottom"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__title--bottom"><span class="box__text-inner box__text-inner--rotated1" v-html="item.tag"></span></h4>
                            </div>

                            <div class="box" v-else-if="item.style_type=='8'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--bottom"><span class="box__text-inner" v-html="item.tag"></span></h4>
                                <div class="box__deco" v-html="item.symbol"></div>
                            </div>

                            <div class="box" v-else-if="item.style_type=='9'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--bottom"><span class="box__text-inner" v-html="item.tag"></span></h4>
                            </div>

                            <div class="box" v-else-if="item.style_type=='10'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title box__title--bottom"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text"><span class="box__text-inner box__text-inner--rotated2" v-html="item.tag"></span></h4>
                                <p class="box__content" v-html="item.description"></p>
                            </div>

                            <div class="box" v-else-if="item.style_type=='11'">
                                <div class="box__shadow"></div>
                                <img class="box__img" :src="item.img" :alt="item.name"/>
                                <h3 class="box__title box__title--straight box__title--left"><span class="box__title-inner" :data-hover="item.name" v-html="item.name"></span></h3>
                                <h4 class="box__text box__text--bottom box__text--right"><span class="box__text-inner box__text-inner--rotated3" v-html="item.tag"></span></h4>
                                <div class="box__deco box__deco--top" v-html="item.symbol"></div>
                            </div>
                        </a>
                    </div>
                </div>
                <!-- 展开样式 -->
                <div class="overlay">
                    <div class="overlay__reveal"></div>
                    <!-- 循环体: 根据不同样式, 渲染不同的样式组合 -->
                    <div class="overlay__item" v-for="(item,index) in worklist" :key="index*Math.random()" :id="'preview-'+item.id">
                        <div class="box" v-if="item.style_type=='1'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text"><span class="box__text-inner" v-html="item.tag"></span></h4>
                            <div class="box__deco" v-html="item.symbol"></div>
                        </div>

                        <div class="box" v-else-if="item.style_type=='2'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title box__title--straight box__title--bottom"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--bottom"><span class="box__text-inner box__text-inner--rotated1" v-html="item.tag"></span></h4>
                            <div class="box__deco box__deco--top" v-html="item.symbol"></div>
                        </div>

                        <div class="box" v-else-if="item.style_type=='3'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--topcloser"><span class="box__text-inner" v-html="item.tag"></span></h4>
                            <div class="box__deco" v-html="item.symbol"></div>
                        </div>

                        <div class="box" v-else-if="item.style_type=='4'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--bottom box__text--right"><span class="box__text-inner box__text-inner--rotated3" v-html="item.tag"></span></h4>
                        </div>

                        <div class="box" v-else-if="item.style_type=='5'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--bottomcloser"><span class="box__text-inner" v-html="item.tag"></span></h4>
                        </div>

                        <div class="box" v-else-if="item.style_type=='6'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text"><span class="box__text-inner" v-html="item.tag"></span></h4>
                        </div>

                        <div class="box" v-else-if="item.style_type=='7'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title box__title--straight box__title--bottom"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__title--bottom"><span class="box__text-inner box__text-inner--rotated1" v-html="item.tag"></span></h4>
                        </div>

                        <div class="box" v-else-if="item.style_type=='8'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--bottom"><span class="box__text-inner" v-html="item.tag"></span></h4>
                            <div class="box__deco" v-html="item.symbol"></div>
                        </div>

                        <div class="box" v-else-if="item.style_type=='9'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--bottom"><span class="box__text-inner" v-html="item.tag"></span></h4>
                        </div>

                        <div class="box" v-else-if="item.style_type=='10'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title box__title--bottom"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text"><span class="box__text-inner box__text-inner--rotated2" v-html="item.tag"></span></h4>
                        </div>

                        <div class="box" v-else-if="item.style_type=='11'">
                            <div class="box__shadow"></div>
                            <img class="box__img box__img--original" :src="item.img" :alt="item.name"/>
                            <h3 class="box__title box__title--straight box__title--left"><span class="box__title-inner" v-html="item.name"></span></h3>
                            <h4 class="box__text box__text--bottom box__text--right"><span class="box__text-inner box__text-inner--rotated3" v-html="item.tag"></span></h4>
                            <div class="box__deco box__deco--top" v-html="item.symbol"></div>
                        </div>
                        
                        <p class="overlay__content" v-html="item.description+`\n<a href='${item.link}' target='_blank'>🔗LINK</a>`"></p>
                    </div>

                    <button class="overlay__close">
                        <svg class="icon icon--cross">
                            <svg id="icon-cross" viewBox="0 0 24 23">
                                <path d="M23.865 3.677c.197-.383.164-.818-.008-1.18.048-.41-.06-.827-.448-1.147L22.323.457c-.636-.524-1.632-.689-2.25 0a155.348 155.348 0 0 1-8.797 9.001C9.011 7.342 6.72 5.255 4.443 3.165c-.8-.734-1.956-.503-2.458.37C1.253 3.9.659 4.374.168 5.182c-.233.386-.215.872 0 1.258 1.47 2.635 4.31 4.951 6.646 7.083-.313.28-.623.562-.942.836-3.146 2.702-5.268 4.416-1.331 7.187.053.037.107.029.161.05.076.036.148.06.232.074.026 0 .05.005.075.003.082.007.16.027.243.011 2.117-.415 4.085-2.074 5.872-3.9 1.74 1.715 3.592 3.353 5.63 4.325.485.232 1.063.097 1.436-.227.626.047 1.197-.342 1.484-.901.042-.026.07-.041.116-.07.91-.569.993-1.701.32-2.482-1.522-1.762-3.138-3.438-4.787-5.084 2.968-2.9 6.674-6.027 8.542-9.667z"></path>
                            </svg>
                        </svg>
                    </button>
                </div>
            </div>
      </div>
    </div>
    <footer-com></footer-com>
  </div>
</template>

<script>
import Header from '../public/Header'
import Footer from '../public/Footer'
import {Grid} from './Grid'
export default {
    data(){
        return{
            worklist:[],
            curLink: "",
            animateDom:null
        }
    },
    components: {
        'header-com': Header,
        'footer-com': Footer
    },
  methods:{
    getWorkList(){ // 获取作品列表页面
        this.$axios({
            url:"/index/getworklist",
            method:"post",
            data:{
                list_type:'work'
            }
        }).then(res=>{
            this.worklist = res.data
        })
    },
  },
  created(){
    document.querySelector("body").classList.add("loading")
    this.getWorkList()
  },
  mounted(){
      this.$nextTick(_=>{
        imagesLoaded(document.querySelectorAll('.box__img'), () => {
            document.body.classList.remove('loading');
            setTimeout(() => {
                this.animateDom = new Grid(document.querySelector('.grid'))
            }, 300);
        });
    })
  },
  beforeDestroy(){
      this.animateDom = null;
  }
}
</script>
<style lang="less">
.container.worklist {
	--color-text: #000;
	--color-bg: #ececec;
	--color-link: #000;
	--color-link-hover: #000;
	--color-info: #000;
	font-family: 'Buenard', serif;
	min-height: 100vh;
	color: #57585c;
	color: var(--color-text);
	background-color: #fff;
	background-color: var(--color-bg);
	-webkit-font-smoothing: antialiased;
	-moz-osx-font-smoothing: grayscale;
}

.preview-open {
	overflow: hidden;
}

/* Page Loader */
.loading::before {
	content: '';
	position: fixed;
	z-index: 1030;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
	background:  #ececec;
}

.loading::after {
	content: '';
	position: fixed;
	z-index: 100000;
	top: 50%;
	left: 50%;
	width: 60px;
	height: 60px;
	margin: -30px 0 0 -30px;
	pointer-events: none;
	border-radius: 50%;
	opacity: 0.4;
	background: #000;
	animation: loaderAnim 0.7s linear infinite alternate forwards;
}

@keyframes loaderAnim {
	to {
		opacity: 1;
		transform: scale3d(0.5,0.5,1);
	}
}

a {
	text-decoration: none;
	color: var(--color-link);
	outline: none;
}

a:hover,
a:focus {
	color: var(--color-link-hover);
	outline: none;
}

.hidden {
	position: absolute;
	overflow: hidden;
	width: 0;
	height: 0;
	pointer-events: none;
}

/* Icons */
.icon {
	display: block;
	width: 1.5em;
	height: 1.5em;
	margin: 0 auto;
	fill: currentColor;
}

.main {
	position: relative;
}

.content {
	position: relative;
}

/* Header */
.codrops-header {
	position: relative;
	z-index: 100;
	display: flex;
	flex-direction: row;
	align-items: flex-start;
	align-items: center;
	padding: 2rem;
}

.codrops-header__title {
	font-size: 1em;
	font-weight: bold;
	margin: 0;
	padding: 0;
}

.info {
	margin: 0 0 0 1.25em;
	color: var(--color-info);
}

.github {
	display: block;
	margin: 0 0 0 auto;
}

/* Top Navigation Style */
.codrops-links {
	position: relative;
	display: flex;
	justify-content: center;
	margin: 0 1em 0 0;
	text-align: center;
	white-space: nowrap;
}

.codrops-icon {
	display: inline-block;
	margin: 0.15em;
	padding: 0.25em;
}

.grid {
	width: 100%;
	max-width: 1440px;
	margin: 0 auto;
	padding-bottom: 10rem;
}

.grid__item {
	display: flex;
	justify-content: center;
	margin: 0 0 10rem 0;
	cursor: pointer;
}

.box {
	position: relative;
	margin: 2rem;
}

.box__title {
	margin: 0;
	line-height: 1;
	position: absolute;
	z-index: 100;
}

.box__title-inner {
	display: block;
	position: relative;
	font-weight: normal;
	text-transform: uppercase;
	font-size: 4.15rem;
	letter-spacing: 0.15rem;
	line-height: 1.25;
	font-family: 'Anton', sans-serif;
}

.box__title-inner[data-hover] {
	-webkit-text-stroke: 2px #000;
	text-stroke: 2px #000;
	-webkit-text-fill-color: transparent;
	text-fill-color: transparent;
	color: transparent;
}

.box__title-inner::before {
	content: attr(data-hover);
	position: absolute;
	top: 0;
	left: 0;
	height: 0;
	overflow: hidden;
	white-space: nowrap;
	-webkit-text-stroke: 0;
	text-stroke: 0;
	-webkit-text-fill-color: #000;
	text-fill-color: #000;
	color: #000;
	transition: all 0.3s;
}

.grid__item:hover .box__title-inner::before {
	height: 100%;
	width: 100%;
}

.box__text {
	margin: 0;
	position: absolute;
	top: -6rem;
	font-weight: normal;
	text-transform: uppercase;
	letter-spacing: 0.15rem;
	font-size: 1.75rem;
	margin: 0.5rem 1rem;
	font-family: 'Anton', sans-serif;
}

.box__text-inner {
	position: relative;
	display: block;
	border: 6px solid var(--color-text);
	padding: 0.25rem 1.25rem;
}

.box__text-inner--reverse {
	background: var(--color-text);
	color: var(--color-bg);
}

.box__img {
	display: block;
	flex: none;
	margin: 0 auto;
	max-width: 100%;
	filter: grayscale(1);
	transition: filter 0.3s;
	pointer-events: none;
}

.grid__item:hover .box__img:not(.box__img--original) {
	filter: grayscale(0);
}

.box__shadow {
	position: absolute;
	width: 100%;
	height: 100%;
	top: -1rem;
	left: -1rem;
	background: url(data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAoAAAAKCAYAAACNMs+9AAAAOklEQVQoU43MSwoAMAgD0eT+h7ZYaOlHo7N+DNHL2HAGgBWcyGcKbqTghTL4oQiG6IUpOqFEC5bI4QD8PAoKd9j4XwAAAABJRU5ErkJggg==);
}

.box__deco {
	font-size: 6rem;
	line-height: 1;
	font-weight: bold;
	position: absolute;
	bottom: -4rem;
	right: -4rem;
    display: none;
    color: #000;
}

.box__content {
	position: absolute;
	max-width: 195px;
	font-size: 0.9rem;
	text-align: right;
    display: none;
    color:#000;
}

.box__content strong {
	white-space: nowrap;
}

.overlay {
	pointer-events: none;
	width: 100%;
	height: 100vh;
	position: fixed;
	top: 0;
	left: 0;
	z-index: 1000;
	overflow: hidden;
}

.overlay--open {
	pointer-events: auto;
}

.overlay__reveal {
	width: 100%;
	height: 100%;
	top: 0;
	left: 0;
	background: #000;
	position: absolute;
	z-index: 100;
	transform: translate3d(100%,0,0);
}

.overlay__item {
	width: 100%;
	height: 100vh;
	position: absolute;
	top: 0;
	left: 0;
	background: #ececec;
	opacity: 0;
	display: flex;
	flex-direction: column;
    align-items: center;
    padding: 5rem 5vw;
    justify-content: center;
}

.overlay__item .box {
	max-width: 600px;
	max-height: 100%;
	margin: 0;
}

.overlay__item .box__title {
	bottom: 0;
}

.box__img--original {
	max-height: calc(100vh - 10rem);
	filter: none;
}

.overlay__close {
	position: absolute;
	top: 90px;
    right: 10px;
    z-index: 999;
	background: none;
	border: 0;
	margin: 1rem;
	padding: 1rem;
	opacity: 0;
}

.overlay__close:focus {
	outline: none;
}

.overlay__content {
	font-size: 1rem;
	line-height: 1.5;
	max-width: 25rem;
    margin: 1rem 0 0 10vw;
    a{
        text-decoration: none !important;
    }
}

@media screen and (min-width: 55em) {
	.grid {
		display: grid;
		align-items: center;
		padding: 10rem 3rem 15rem 3rem;
		grid-row-gap: 2rem;
		grid-template-columns: repeat(3,calc(100% / 3));
	}
	.grid__item {
		margin: 0;
	}
	.box {
		margin: 4rem;
	}
	.box__title {
		top: -4rem;
		right: -4.5rem;
		-webkit-writing-mode: vertical-rl;
		writing-mode: vertical-rl;
	}
	.box__title--straight {
		-webkit-writing-mode: horizontal-tb;
		writing-mode: horizontal-tb;
	}
	.box__title--straight .box__title-inner::before {
		width: 0;
		height: auto;
	}
	.box__title--bottom {
		bottom: -5rem;
		top: auto;
	}
	.box__title--left {
		left: -2rem;
		right: auto;
	}
	.box__text--topcloser {
		top: -5rem;
	}
	.box__text--bottom {
		bottom: -5rem;
		top: auto;
	}
	.box__text--bottomcloser {
		bottom: -5rem;
		top: auto;
	}
	.box__text--right {
		right: 0;
		left: auto;
	}
	.box__text-inner--rotated1 {
		transform: rotate(4deg);
	}
	.box__text-inner--rotated2 {
		transform: rotate(-3deg);
	}
	.box__text-inner--rotated3 {
		transform: rotate(-15deg);
	}
	.box__deco {
		display: block;
	}
	.box__deco--left {
		right: auto;
		left: -3rem;
	}
	.box__deco--top {
		top: 0;
		bottom: auto;
	}
	.overlay__item {
		flex-direction: row;
	}
	.overlay__content {
		font-size: 2.25rem;
		margin-top: 0;
	}
	.overlay__item .box__title--bottom {
		bottom: 0;
	}
}

@media screen and (min-width: 80em) {
	.grid {
		grid-template-columns: repeat(4,25%);
	}
	.grid__item:nth-child(4n-2) {
		margin-top: -8rem;
		margin-bottom: 8rem;
	}
	.grid__item:nth-child(4n) {
		margin-top: -5rem;
	}
	.box {
		margin: 6rem 4.5rem;
	}
	.box__content {
		display: block;
	}
}

@media screen and (max-width: 55em) {
	.content {
		flex-direction: column;
		height: auto;
		min-height: 0;
	}
	.content--fixed {
		position: relative;
		z-index: 1000;
		display: block;
		padding: 0.85em;
	}
	.codrops-header {
		flex-direction: column;
		align-items: center;
		padding-bottom: 5rem;
	}
	.codrops-header__title {
		font-weight: bold;
		padding-bottom: 0.25em;
		text-align: center;
	}
	.info {
		margin: 0;
	}
	.github {
		display: block;
		margin: 1em auto;
	}
	.codrops-links {
		margin: 0;
	}
}
</style>