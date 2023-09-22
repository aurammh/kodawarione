import moment from 'moment';

export const DateUtils = {
  /**
   *
   * @param {Date} date
   * @param {String} language
   */
  formatDateLocalization(date = new Date(), language = 'jp') {
    if (language == 'jp') {
      var tempDate = moment(new Date(date));
      if (tempDate.isValid()) {
        return tempDate.format('YYYY年MM月DD日');
      }

      return date;
    } else {
      return moment(new Date(date)).format('D MMMM YYYY');
    }
  },

  /**
   *
   * @param {*} date
   * @param {Boolean} isTimeRequired
   */
  toLocalISOString(date, isTimeRequired) {
    isTimeRequired = isTimeRequired ? isTimeRequired : false;
    var tzoffset = new Date().getTimezoneOffset() * 60000; //offset in milliseconds
    if (isTimeRequired) {
      return new Date(date - tzoffset).toISOString().slice(0, -1);
    } else {
      return (
        new Date(date - tzoffset).toISOString().slice(0, -1).substring(0, 11) +
        '00:00:00.000Z'
      );
    }
  },

  /**
   *
   * @param {*} date
   * @param {String} language
   */
  onlyMonthAndYear(date, language) {
    if (language == 'jp') {
      return moment(date).subtract(1, 'months').format('MM月 YYYY年');
    } else {
      return moment(date).subtract(1, 'months').format('MMMM - YYYY');
    }
  },

  getAge(date, language) {
    if (language == 'jp') {
      return moment().diff(date, 'years', false) + '歳';
    } else {
      return moment().diff(date, 'years', false);
    }
  },

  calculateTimeFromTimestamp(start, end) {
    let time = ((end - start) / 1000).toFixed(1);
    let minutes, seconds;
    if (time > 60) {
      minutes = Math.floor(time / 60);
      seconds = (time - minutes * 60).toFixed(1);
      // time = `${minutes}M : ${seconds}S`;
    } else {
      time = `${time}`;
    }

    return time;
  },
};
