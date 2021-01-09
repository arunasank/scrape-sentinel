const tbox = require('@turf/bbox');
const sqGr = require('@turf/square-grid');
const th = require('@turf/helpers');
const fs = require('fs');
const geojsonFile = process.env.BBOX_GEOJSON_FILE
const imageSize = process.env.IMG_SIZE
const squareForBBox = require(geojsonFile);
const bbox = tbox.default(squareForBBox);
const cellSide = imageSize/100;
const grid = sqGr.default(bbox, cellSide);

fs.writeFileSync('grids.json', JSON.stringify(grid));

const start = async () => {
  await Promise.all( grid.features.map( async (feature, iterator) => {
    fs.mkdirSync(`sources/${iterator}`)
    const path = `sources/${iterator}/${iterator}.json`
    fs.writeFileSync(path, JSON.stringify(th.featureCollection([feature])));
  }));
}

start();

/*
Promise.all(grid.features.map(feature, iterator) => {
  const path = `${geojsonFile.split('/')[1]}-tiles/${geojsonFile.split('/')[2].split('.json')[0]}/${iterator}.geojson`
  console.log(path)
  fs.writeFileSync(path, JSON.stringify(th.featureCollection([feature])));
});*/
