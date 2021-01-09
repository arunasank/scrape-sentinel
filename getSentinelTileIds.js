const geojson = require(`${process.argv.slice(2)[0]}`)
geojson.features
.forEach((feature) => {
  console.log(feature.properties.title)
})
