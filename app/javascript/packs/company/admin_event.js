$(function(){
    $('#event-join-list').hide();
    $('#btn-save-event').prop('disabled', true);
    $("#admin-event-btn").on("click", function(e) {
        var re = /^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$/;
        var err_flag = false;
        $('#event-modal-form *').filter(':input.errors').not("input[type='hidden']").each(function() {
            if ($(this).val() == "") {
                err_flag = true;
                $(".error_" + $(this).attr("id")).addClass("field_with_errors");
                $(".err_" + $(this).attr("id")).removeClass("d-none");
            } else {
                $(".error_" + $(this).attr("id")).removeClass("field_with_errors");
                $(".err_" + $(this).attr("id")).addClass("d-none");
            }
        });                
        
        if (!re.test($("#email").val())) {
            $(".error_email").addClass("field_with_errors");
            $(".err_email").removeClass("d-none");
            return false;
        }

        if (err_flag) {
            return false;
        } else {
            //append into table if field with no errors
            if ($('#event-participant-modal').length){
                $('#event-join-list').show();
                if(!this.slNo) this.slNo = 1;
                var name = $('#name').val(),
                email = $('#email').val(),
                position = $('#position').val(),
                department = $('#department').val(),
                desc = $('#description').val();
                
                $('#event-join-list').append(
                    "<tr><td class='col-2 text-break'>"+name+"</td>"+
                    "<td class='col-2 text-break'>"+email+"</td>"+
                    "<td class='col-2 text-break'>"+position+"</td>"+
                    "<td class='col-2 text-break'>"+department+"</td>"+
                    "<td class='col-2 text-break'>"+desc+"</td>"+
                    '<td class="col-2 text-break"><button type="button" class="mx-auto icon-container com_communication_icon dlt-join-rd-btn" data-toggle="modal" data-target="#removeUser" data-id="'+ this.slNo +'"><i class="fa fa-trash-alt"></i></button></td></tr>'
                )
                this.slNo += 1;
                $("#name").val('');
                $("#email").val('');
                $("#position").val('');
                $("#department").val('');
                $("#description").val('');
            }
            $('#btn-save-event').prop('disabled', false);
            return true;
        }
    });
    
    //show confirm dialo to delete table record
    $('#removeUser').on('show.bs.modal', function(e) {
	    delid = $(e.relatedTarget).data('id');
	});

    //click delete btn to delete record
    $('#remove-button').click(function() {
        var rowCount = $('#event-join-list tr:gt(0)').length;
        $('[data-id=' + delid + ']').parents('tr').remove();
        //hide table header when there is no record
        if( rowCount <= 1 ){
            $('#event-join-list').hide();
        }else{
            $('#event-join-list').show();
        }
    });      

    // click join btn for save data into db
    $("#btn-save-event").on("click", function(e) {
        var myRows = [];
        var headerArr = ['name','email','position','department','description']
        var $rows = $("#event-join-list tbody tr").each(function(index) {
                $cells = $(this).find('td').slice(0,6);
                myRows[index] = {};
                $cells.each(function(cellIndex) {
                myRows[index][headerArr[cellIndex]] = $(this).html();
                });    
        });

        // Let's put this in the object like you want and convert to JSON (Note: jQuery will also do this for you on the Ajax request)
        var myObj = {};
        myObj = myRows;

        $.ajax({
            url: '/company/admin_events',
            type: 'POST',
            data: {admin_event_participant: JSON.stringify(myObj),admin_event_id: $('#id').val()},
            success: function(data) {
                if(data.status == 'ok'){
                    $('#event-participant-modal').modal('hide');
                    $("#join-admin-event-icon").addClass("active").removeClass("inactive");
                }
            },
            failure: function() {
                alert("Unsuccessful");
            }
        });
    }); 
   
    //join_participant modal table row click check chebox
    $('.participant').css('cursor', 'pointer').on("click",function() {
        var checkBoxes = $(this).parent('tr').find('input:checkbox')
        checkBoxes.prop("checked", !checkBoxes.prop("checked"));
    });         
});