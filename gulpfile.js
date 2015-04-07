require('mandragora-bucket')(require('gulp'), {
  paths: {
    bower: [
      'bower_components/purescript-*/src/**/*.purs',
      'bower_components/purescript-*/purescript-*/src/**/*.purs'
    ],
    src: ['src/**/*.purs'],
    test: ['test/**/*.purs'],
    docs: {
      dest: 'MODULES.md'
    }
  },
  tmpDir: 'dist'
});
