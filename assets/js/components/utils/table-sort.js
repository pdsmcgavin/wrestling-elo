import moment from "moment";

export const floatStringSort = (a, b) => {
  return parseFloat(a) > parseFloat(b) ? 1 : -1;
};

export const dateStringSort = (a, b) => {
  return moment(a, "Do MMM YYYY").format() > moment(b, "Do MMM YYYY").format()
    ? 1
    : -1;
};
