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
    backgroundColor: theme => ({
      ...theme("colors"),
      primary: "#E66D15",
      secondary: "#43A422",
    }),
    textColor: theme => ({
      ...theme("colors"),
      primary: "#E66D15",
      secondary: "#43A422",
    }),
    borderColor: theme => ({
      ...theme("colors"),
      primary: "#E66D15",
      secondary: "#43A422",
    }),
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
      },
      colors: {
        primary: {
          default: "#E66D15"
        },
        secondary: {
          default: "#43A422"
        }
      },
      zIndex: {
        "1": "1",
        "2": "2"
      },
      inset: {
        "1/2": "50%",
        "3.5": "0.875rem",
        "8": "2rem",
        "12": "3rem"
      },
      spacing: {
        "1/6": "16.666667%"
      },
      maxHeight: {
        "32": "8rem"
      }
    }
  }
}