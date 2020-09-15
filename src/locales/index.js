// import Vue from 'vue'
// import VueI18n from 'vue-i18n'

Vue.use(VueI18n)

const DEFAULT_LANG = 'en' // 默认语言为英文
const LOCALE_KEY = 'localeLanguage'

const locales = {
    'zh': require('./zh.json'),
    'en': require('./en.json'),
}

const i18n = new VueI18n({
    locale: DEFAULT_LANG,
    messages: locales,
})

export const setup = lang => { // 中英切换函数
    if (lang === undefined) {
        lang = window.localStorage.getItem(LOCALE_KEY)
        if (locales[lang] === undefined) {
            lang = DEFAULT_LANG
        }
    }
    window.localStorage.setItem(LOCALE_KEY, lang)

    Object.keys(locales).forEach(lang => {
        document.body.classList.remove(`lang-${lang}`)
    })
    document.body.classList.add(`lang-${lang}`)
    document.body.setAttribute('lang', lang)

    Vue.config.lang = lang
    i18n.locale = lang
}

setup()
window.i18n = i18n // 将插件挂载在window对象下以便全局引用
window.setup = setup
export default i18n