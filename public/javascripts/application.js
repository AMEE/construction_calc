/* Updates the units drop down according to the type of data selected */
function updateUnits(object_name) {
    $('#' + object_name + '_units').html(units[$('#' + object_name + '_' + object_name + '_type').val()]);
}

function selectUnits(object_name, unit_name) {
    $('#' + object_name + '_units').val(unit_name);
}

function udpateProjectOwnerFormAction() {
    new_action = $('#project_owner_form').attr('action').replace(/\d+/, $('#user_id').val());
    $('#project_owner_form').attr('action', new_action);
}