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

function switchProject() {
    if ($('#project_switch_id').val() == "0") {
        return;
    }
    
    new_action = $('#switch_project_form').attr('action').replace(/\d+/, $('#project_switch_id').val());
    $('#switch_project_form').attr('action', new_action);
    $('#switch_project_form').submit();
}

function showTabBorder(type) {
    if (type == "delivery") {
        resetSideBorders();
        resetBottomBorders();
        addBottomBorder('deliveries-bottom-border', '#delivery-type');
        $('#delivery-type').addClass('deliveries-side-border');
    } else if (type == "material") {
        resetSideBorders();
        resetBottomBorders();
        addBottomBorder('materials-bottom-border', '#material-type');
        $('#material-type').addClass('materials-side-border');
    } else if (type == "waste") {
        resetSideBorders();
        resetBottomBorders();
        addBottomBorder('waste-bottom-border', '#waste-type');
        $('#waste-type').addClass('waste-side-border');
    } else if (type == "energy") {
        resetSideBorders();
        resetBottomBorders();
        addBottomBorder('energy-bottom-border', '#energy-type');
        $('#energy-type').addClass('energy-side-border');
    } else if (type == "commuting") {
        resetSideBorders();
        resetBottomBorders();
        addBottomBorder('commuting-bottom-border', '#commuting-type');
        $('#commute-type').addClass('commuting-side-border');
    }
}

function resetSideBorders() {
    $('#delivery-type').removeClass('deliveries-side-border');
    $('#material-type').removeClass('materials-side-border');
    $('#waste-type').removeClass('waste-side-border');
    $('#energy-type').removeClass('energy-side-border');
    $('#commute-type').removeClass('commuting-side-border');
}

function resetBottomBorders() {
    removeBottomBorderClass("deliveries-bottom-border");
    removeBottomBorderClass("materials-bottom-border");
    removeBottomBorderClass("waste-bottom-border");
    removeBottomBorderClass("energy-bottom-border");
    removeBottomBorderClass("commuting-bottom-border");
}

function removeBottomBorderClass(name) {
    $('#delivery-type').removeClass(name);
    $('#material-type').removeClass(name);
    $('#waste-type').removeClass(name);
    $('#energy-type').removeClass(name);
    $('#commute-type').removeClass(name);
}

function addBottomBorder(className, toSkip) {
    if (toSkip != '#delivery-type') {
        $("#delivery-type").addClass(className);
    }
    if (toSkip != '#material-type') {
        $("#material-type").addClass(className);
    }
    if (toSkip != '#waste-type') {
        $("#waste-type").addClass(className);
    }
    if (toSkip != '#energy-type') {
        $("#energy-type").addClass(className);
    }
    if (toSkip != '#commute-type') {
        $("#commute-type").addClass(className);
    }
}

function enableAjaxPagination() {
    $('.pagination a').click(function() {
        $.ajax({url:this.href, dataType:'script', type:'get'});
        return false;
    })
}