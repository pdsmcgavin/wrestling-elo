const groupBy = (array, key) => {
  const groupedArray = array.reduce((acc, element) => {
    const groupKey = element[key];

    if (acc[groupKey]) {
      acc[groupKey].push(element);
    } else {
      acc[groupKey] = [element];
    }

    return acc;
  }, {});

  return groupedArray;
};

export default groupBy;
