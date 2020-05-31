const baseWidth = 5

module.exports = {
  purge: [
    "../**/*.html.eex",
    "../**/*.html.leex",
    "../**/views/**/*.ex",
    "../**/live/**/*.ex",
    "./js/**/*.js"
  ],
  theme: {
    extend: {
      width: {
        '1/20': `${baseWidth * 1}%`,
        '2/20': `${baseWidth * 2}%`,
        '3/20': `${baseWidth * 3}%`,
        '4/20': `${baseWidth * 4}%`,
        '5/20': `${baseWidth * 5}%`,
        '6/20': `${baseWidth * 6}%`,
        '7/20': `${baseWidth * 7}%`,
        '8/20': `${baseWidth * 8}%`,
        '9/20': `${baseWidth * 9}%`,
        '10/20': `${baseWidth * 10}%`,
        '11/20': `${baseWidth * 11}%`,
        '12/20': `${baseWidth * 12}%`,
        '13/20': `${baseWidth * 13}%`,
        '14/20': `${baseWidth * 14}%`,
        '15/20': `${baseWidth * 15}%`,
        '16/20': `${baseWidth * 16}%`,
        '17/20': `${baseWidth * 17}%`,
        '18/20': `${baseWidth * 18}%`,
        '19/20': `${baseWidth * 19}%`,
      }
    }
  }
}