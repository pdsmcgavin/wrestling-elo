const sortBy = key => {
  return (a, b) =>
    leaf(a, key) > leaf(b, key) ? 1 : leaf(b, key) > leaf(a, key) ? -1 : 0;
};

export default sortBy;

const leaf = (obj, path) =>
  path.split(".").reduce((value, el) => value[el], obj);
