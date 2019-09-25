<template>
  <div>
    <header>
      <nav ref="nav" class="navbar navbar-fixed-top navbar-inverse">
        <div class="container">
          <button
            type="button"
            class="navbar-toggle collapsed"
            data-toggle="collapse"
            data-target="#navbar-collapse"
            aria-expanded="false"
          >
            <span class="sr-only">Toggle navigation</span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
            <span class="icon-bar"></span>
          </button>

          <div class="collapse navbar-collapse" id="navbar-collapse">
            <ul class="nav navbar-nav">
              <li>
                <!-- <a href="./index.html" title>01 : Home</a> -->
                <router-link :to="{name:'home'}">01 : Home</router-link>
              </li>
              <li>
                <!-- <a href="./works.html" title>02 : Works</a> -->
                <router-link :to="{name:'log'}">02 : Logs</router-link>
              </li>
              <li>
                <!-- <a href="./about.html" title>03 : About me</a> -->
                <router-link :to="{name:'about'}">03 : About me</router-link>
              </li>
              <li>
                <!-- <a href="./contact.html" title>04 : Contact</a> -->
                <router-link :to="{name:'contact'}">04 : Contact</router-link>
              </li>
              <!-- <li>
                <a href="./components.html" title>05 : Components</a>
				<router-link :to="{name:'contact'}">04 : Contact</router-link>
              </li>-->
            </ul>
            <ul
              v-if="this.$route.name=='logcontent'"
              class="nav navbar-nav navbar-right navbar-small visible-md visible-lg"
            >
              <li v-for="(item,index) in currentArticles" :key="index">
                <a
                  href="javascript:;"
                  v-html="'00'+(index+1)"
                  :data-index="index"
                  v-active
                  @click="changePage(item,index)"
                ></a>
              </li>
            </ul>
          </div>
        </div>
      </nav>
    </header>
  </div>
</template>

<script>
export default {
  data() {
    return {
      currentArticles: [],
    }
  },
  directives: {
    'active': {
      inserted(el, binding, node) {
        let index = el.getAttribute('data-index'), contentIndex = node.context.$route.params.id, isActive = index == contentIndex;
        if (isActive) el.classList.add('active');
      },
      update(el, binding, node) {
		  let index = el.getAttribute('data-index'), contentIndex = node.context.$route.params.id
		  $("ul.navbar-right li a").eq(index).removeClass('active')
		  $("ul.navbar-right li a").eq(contentIndex).addClass('active')
      },
    }
  },
  mounted() {
    if (this.$route.name == 'home') {
      this.$refs.nav.classList.add('navbar-inverse')
      this.$refs.nav.classList.remove('navbar-default')
    } else {
      this.$refs.nav.classList.add('navbar-default')
      this.$refs.nav.classList.remove('navbar-inverse')
    }
    this.currentArticles = JSON.parse(sessionStorage.getItem('allArticles'))
  },
  methods: {
    changePage(item, index) {
      if (index == this.$route.params.id) return false;
      var _this = this,
        obj = JSON.parse(JSON.stringify(_this.$router.currentRoute.query)) // 这里我们需要的应该是值，因此必须转为深拷贝
      Object.assign(obj, { id: index, contentid: item._id })
      _this.$router.push({
        params: obj
      })
    },
    getRouteId() {
      return this.$route.params.id
    }
  }
}
</script>

<style lang="less" scoped>
#navbar-collapse {
  ul {
    li {
      a:hover,
      a:focus {
        color: #333;
        text-decoration: none;
      }
      a:focus {
        outline: 5px auto -webkit-focus-ring-color;
        outline-offset: -2px;
      }
    }
  }
}
.minimal {
  #navbar-collapse {
    ul {
      li {
        a:hover,
        a:focus {
          color: #fff;
          text-decoration: none;
        }
        a:focus {
          outline: 5px auto -webkit-focus-ring-color;
          outline-offset: -2px;
        }
      }
    }
  }
}
</style>