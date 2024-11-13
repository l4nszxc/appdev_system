<<<<<<< HEAD
// const { defineConfig } = require('@vue/cli-service')
// module.exports = defineConfig({
//   transpileDependencies: true
// })

const { defineConfig } = require('@vue/cli-service');

module.exports = defineConfig({
  configureWebpack: {
    resolve: {
      alias: {
        vue$: 'vue/dist/vue.esm-bundler.js',
      },
    },
  },
  chainWebpack: (config) => {
    config.plugin('define').tap(args => {
      args[0]['__VUE_PROD_HYDRATION_MISMATCH_DETAILS__'] = JSON.stringify(true);
      return args;
    });
  },
});
=======
const { defineConfig } = require('@vue/cli-service') 
module.exports = defineConfig({ transpileDependencies: true })
>>>>>>> 0f2941a0bc1337b7083106f0e75ce9460af8ff9e
