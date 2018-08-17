import moment from "moment";

const ISODateFormat = "YYYY-MM-DD";

export const todaysDateISO = () => {
  return moment().format(ISODateFormat);
};

export const previousDateISO = daysPrevious => {
  return moment()
    .subtract(daysPrevious, "days")
    .format(ISODateFormat);
};
