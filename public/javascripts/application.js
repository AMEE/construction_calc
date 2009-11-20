/* Updates the units drop down according to the type of data selected */
function updateUnits(object_name) {
    $('#' + object_name + '_units').html(units[$('#' + object_name + '_' + object_name + '_type').val()]);
}