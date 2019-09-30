export default function (Vue) {
    Vue.filter('date', tplDate => {
        let date = new Date(tplDate + '');
        return ` ${date.getFullYear()}-${date.getMonth() + 1}-${date.getDate()} ${date.getHours() >= 10 ? date.getHours() : '0' + date.getHours()}:${date.getMinutes() >= 10 ? date.getMinutes() : '0' + date.getMinutes()}:${date.getSeconds() >= 10 ? date.getSeconds() : '0' + date.getSeconds()} `;
    });
};