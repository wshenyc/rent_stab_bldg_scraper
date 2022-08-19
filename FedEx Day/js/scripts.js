

mapboxgl.accessToken = 'pk.eyJ1Ijoid3NoZW55YyIsImEiOiJja2w3YjNvd3YxZnc1Mm5wZWp1MnVqZGh2In0.-wG4LWFGN76Nf-AEigxu2A';

//loading map
var map = new mapboxgl.Map({
  container: 'mapContainer', // container ID
  style: 'mapbox://styles/mapbox/light-v9', // style URL
  center: [-73.92013728138733, 40.71401732482218], // starting position [lng, lat]
  zoom: 10.5 // starting zoom
});

// disable map zoom when using scroll
map.scrollZoom.disable();

// add navigation control in top left
var nav = new mapboxgl.NavigationControl();
map.addControl(nav, 'top-left');

//search bar

// var geocoder = new MapboxGeocoder({
//   accessToken: mapboxgl.accessToken,
//   mapboxgl: mapboxgl
// });
//
// map.addControl(geocoder);

map.on('load', function() {

  // adding in layer of NTAs
  map.addSource('nta', {
    type: 'geojson',
    data: './Data/NTA map.geojson'
  });

  //adding line outlines
    map.addLayer({
      'id': 'lots-lines',
      'type': 'line',
      'source': 'nta',
      'paint': {
        'line-color': '#1a1a1a',
        'line-width': 0.3
      }
    });

//adding fill in
  map.addLayer({
    'id': 'lots-fill',
    'type': 'fill',
    'source': 'nta',
    'paint': {
      'fill-color': 'gray',
      'fill-opacity': 0.3
    }
  });

//adding in RS bldgs
map.addSource('rs-bldgs', {
  type: 'geojson',
  data: './Data/rs_bldgs_pls.geojson'
})

//adding fill in
  map.addLayer({
    'id': 'rs-fill',
    'type': 'fill',
    'source': 'rs-bldgs',
    'paint': {
      'fill-color': 'red',
      'fill-opacity': 0.3
    }
  });


}); //loading closer


// map.on('click', (event) => {
//   const zips = map.queryRenderedFeatures(event.point, {
//     layers: ['total-filings']
//   });
//   document.getElementById('pd').innerHTML = zips.length
//     ? `<h4>Zip Code: ${zips[0].properties.postalcode}</h4><p>
//     <strong><em>${zips[0].properties.oca_sum_zips_total_filings}</strong> total filings</em></p>
//     <strong><em>${zips[0].properties.oca_sum_zips_pct_resp_rep}</strong>% of respondents had representation</em></p>
//     <strong><em>${zips[0].properties.oca_sum_zips_pct_resp_app}</strong>% of respondents appeared in court</em></p>
//     <strong><em>${zips[0].oca_sum_zips_total_execution}</strong> total number of warrants executed</em></p>
//     `
//     : `<p>Click a zip code!</p>`
//     map.getSource('highlight-feature').setData(zips[0].geometry);
//     map.setLayoutProperty('highlight-outline', 'visibility', 'visible');
//
// });
