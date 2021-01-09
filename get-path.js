const fs = require('fs');
const fullId = process.argv.slice(2)[0];
const tilePattern = fullId.split('_')[5].slice(1);
const UDM = tilePattern.slice(0,2)
const latZone = tilePattern[2]
const grid = tilePattern.slice(3,5)
console.log(`gsutil -m cp -n gs://gcp-public-data-sentinel-2/tiles/${UDM}/${latZone}/${grid}/${fullId}.SAFE/GRANULE/**/*TCI.jp2 .`);

/*
const fullDate = fullId.split('_')[2].split('T')[0];
const year = fullDate.slice(0,4)
const month = fullDate.slice(4,6) * 1
const date = fullDate.slice(6,8)
console.log(`aws s3 cp s3://sentinel-s2-l1c/tiles/${UDM}/${latZone}/${grid}/${year}/${month}/${date}/0/TCI.jp2 . --request-payer`);
*/
