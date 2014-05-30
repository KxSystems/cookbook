// Smart Meter Usage Report 

// Helper functions 
// Format json data into HTML table
function jsonTable(data){ 
  var table,prop,key,row;
  if(data.length === 0){ return false; }
  
  table = '<table class="table table-striped table-hover">';
  table+= '<thead>';
  for(prop in data[0]){ // Column Headers
    if (data[0].hasOwnProperty(prop)) {
      table+= '<th>' + prop + '</th>';
    }
  }
  table+= '</thead><tbody>';
  for(key in data){ // Each row
    if (data.hasOwnProperty(key)) {
      table+= '<tr>';
      row = data[key];
      for(prop in row){ 
        if (row.hasOwnProperty(prop)) {
          table+= '<td>' + row[prop] + '</td>';
        }
      }
      table+= '</tr>';
    }
  }
  table+= '</tbody></table>';
  return table;
}
// Returns array of checkbox values depending on if "All" option is checked
function checkboxVals(selector){
  var array = [], $parent = $(selector), $inputs = $parent.find('input');
  // If all is not checked, grab the values that are checked, otherwise return empty array
  // Includes the optimization, if all inputs are checked (except "All"), this is the same as if
  // "All" was selected, therefore return empty array
  if($parent.find('input[value="all"]:checked').length === 0){
    if($parent.find('input[value!="all"]:checked').length < $inputs.length - 1){
      $parent.find('input[value!="all"]:checked').each(function(a,b){array.push($(b).val());});
    }
  } 
  return array;
}
// Returns an object of all inputs used for the query
function getInputs() {
  var startdate = $('#startdate input').val(),
      enddate   = $('#enddate input').val(),
      pivotvals    = $('.radio input:checked').val(),
      groupingvals = [],
      regionvals = [],
      custtypevals = [];      

  // Add values from grouping,region & custtype filter to their respective array
  $('#grouping .checklist input:checked').each(function(a,b){groupingvals.push($(b).val());});

  // Add checkbox values to appropriate array depending on whether "All" option is checked
  regionvals = checkboxVals('#region-filter');
  custtypevals = checkboxVals('#custtype-filter');

  return {
    start_date: startdate,
    end_date: enddate,
    grouping: groupingvals,
    pivot: pivotvals,
    region_filter: regionvals,
    custtype_filter: custtypevals
  }
}

// WEBSOCKETS CONNECTING TO KDB+
var ws = new WebSocket("ws://localhost:5600");
ws.binaryType = 'arraybuffer'; // Required by c.js 
// WebSocket event handlers
ws.onopen = function () {
  ws.send(serialize(JSON.stringify({init:1})));
  $('#connecting').hide();
};
ws.onclose = function () {
  // Disable submit button 
  $(this).attr("disabled",true);
  // Disable export button
  $('#export').addClass("disabled");  
};
ws.onmessage = function (event) {
  if(event.data){
    var edata = JSON.parse(deserialize(event.data)),
        name  = edata.name,
        data  = edata.data;

    // Enable submit button 
    $('#submit').attr("disabled",false);
    
    // Data handling functionality
    // Print database and table stats, and output table. Display error.
    if(edata.hasOwnProperty('data')){

      // Initial data about the database
      if(name === 'init'){
        // stylise field val into field: val
        data.forEach(function(a){
          $('#dbstats').append('<li>' + a.field + ': ' + a.val + '</li>');
        });
      }

      // Output table data
      if(name === 'table'){

        // Build html table with data and fill in stats
        $('#tableoutput').html(jsonTable(data.data));
        $('#tblstats').html("").append('<li>Date Range: ' + getInputs().start_date + " to " + getInputs().end_date +'</li>' +
          '<li>Generated in: ' + (data.time/1000).toFixed(1) + "s" +'</li>' +
          '<li>Rows: ' + data.rows +'</li>');

        // Show stats bar
        $('.stats').show();
        
        // Enable export link
        $('#export').removeClass("disabled");

        // Resize table cells
        //$('#tableoutput tbody td, #tableoutput thead th').width($('#tableoutput').width()/$('#tableoutput thead th').length-10);
      }
    } else {
      $('#error-msg').html(edata.error);
      // Show modal popup
      $('#error-modal').modal();
    }
  }
};
ws.error = function (error) {
  // Enable submit button 
  $('#submit').attr("disabled",false);
  // Write error message
  $('#error-msg').html(error.data);
  // Show modal popup
  $('#error-modal').modal();
}

// jQuery used for UI
$(function() {

  // Add calendar for start,end date
  $('#startdate').datepicker();
  $('#enddate').datepicker();

  // Filter options
  // This is a UI design pattern for when there is a list of multiple options for when atleast one option is required.
  // The "All" option is checked by default, when another option is selected the "All" option is unchecked.
  // If the "All" option is checked, then all other options will be unchecked
  $('.multi-select-checkbox').each( function () {
    $(this).find('input[value!="all"]').click( function () {
      var $parent = $(this).closest('.multi-select-checkbox');
      if($parent.find('input[value!="all"]:checked').length){
        $parent.find('input[value="all"]').prop('checked', false);
      } else {
        $parent.find('input[value="all"]').prop('checked', true)
      }
    })
  });
  $('.multi-select-checkbox').each( function () {
    $(this).find('input[value="all"]').click( function () {
      $(this).closest('.multi-select-checkbox').find('input[value!="all"]').prop('checked', false);
    });
  });

  // When submit button is clicked, disabled buttons and send data over WebSocket
  $('#submit').click(function(){
    // Disable submit button on submit
    $(this).attr("disabled",true);
    // Disable export on submit
    $('#export').addClass("disabled");  
    // Send to kdb+ over websockets  
    ws.send(serialize(JSON.stringify(getInputs())));
  });
});
