var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var validate = ($.fn.validate !== undefined),
			multilang = ($.fn.multilang !== undefined),
			$frmDefaultWTime = $('#frmDefaultWTime'),
			$frmSetWTime = $('#frmSetWTime'),
			$frmSetDayOff = $('#frmSetDayOff'),
			$grid,
			datagrid = ($.fn.datagrid !== undefined),
			datepicker = ($.fn.datepicker !== undefined);
		
		if (datepicker) {
			$.fn.datepicker.dates['en'] = {
	        	days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
	        	daysMin: myLabel.days.split("_"),
	        	daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
	        	months: myLabel.months.split("_"),
	        	monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    		}
		}
		
		if ($('#choosen_week_day').length) {
			$('#choosen_week_day').chosen({
                width: "100%",
                placeholder_text_multiple: "-- " + myLabel.placeholder_text + " --",
                disable_search: true
            });
        };
        
        if ($('.clockpicker').length) {
        	$('.clockpicker').clockpicker({
                twelvehour: myLabel.showperiod,
                autoclose: true
            });
        };
        
        function setDayOff($frmSetDayOff) {
        	$.post("index.php?controller=pjAdminTime&action=pjActionSetDayOff", $frmSetDayOff.serialize()).done(function (data) {
				var url = "index.php?controller=pjAdminTime&action=pjActionIndex";
				if (pjGrid.type != "") {
					url += "&type=" + pjGrid.type;
				}
				if (pjGrid.foreign_id != "") {
					url += "&foreign_id=" + pjGrid.foreign_id;
				}
				url += "&tab=3";
				window.location.href = url;
			});
		}

        function saveTime($frmDefaultWTime) {
	        $.post("index.php?controller=pjAdminTime&action=pjActionSaveTime", $frmDefaultWTime.serialize()).done(function (data) {
				var url = "index.php?controller=pjAdminTime&action=pjActionIndex";
				if (pjGrid.type != "") {
					url += "&type=" + pjGrid.type;
				}
				if (pjGrid.foreign_id != "") {
					url += "&foreign_id=" + pjGrid.foreign_id;
				}
				url += "&tab=2";
				window.location.href = url;
			});
        }
        if($frmDefaultWTime.length > 0)
        {
        	$frmDefaultWTime.validate({});
        }
        if($frmSetWTime.length > 0)
        {
        	$frmSetWTime.validate({
				onkeyup: false,
				ignore: "",
				submitHandler: function (form) {
					var l = Ladda.create( $(form).find(":submit").get(0) );
					l.start();
					var from = $(form).find('input[name="from_time"]').val(),
						to = $(form).find('input[name="to_time"]').val(),
						lunch_from = $(form).find('input[name="lunch_from_time"]').val(),
						lunch_to = $(form).find('input[name="lunch_to_time"]').val();
					$.post("index.php?controller=pjAdminTime&action=pjActionSetTime", $('#frmDefaultWTime, #frmSetWTime').serialize()).done(function (data) {
						l.stop();
						if(data.status == 'OK')
						{
							$.map( data.week_days, function( item, key ) {
								var $td = $('#week_day_' + key);
								var index = $td.find('span').length + 1;
								var span = '<span class="label label-primary"><input type="hidden" name="from['+key+']['+index+']" value="'+from+'" /><input type="hidden" name="to['+key+']['+index+']" value="'+to+'" />'+from+' - '+to+' <a href="#" class="text-primary remove-time"><i class="fa fa-times m-l-xs"></i></a></span>&nbsp;';
								$td.html(span);
								
								$td = $('#lunch_break_' + key);
								index = $td.find('span').length + 1;
								span = '<span class="label label-secondary"><input type="hidden" name="lunch_from['+key+']['+index+']" value="'+lunch_from+'" /><input type="hidden" name="lunch_to['+key+']['+index+']" value="'+lunch_to+'" />'+lunch_from+' - '+lunch_to+' <a href="#" class="text-primary remove-time"><i class="fa fa-times m-l-xs"></i></a></span>&nbsp;';
								$td.html(span);
							});
							$(form).find('input[name="from"]').val("");
							$(form).find('input[name="to"]').val("");
							
							if (data.code == '201') {
								swal({
					                title: myLabel.dialog_title_over,
					                text: myLabel.dialog_body_over,
					                type: "warning",
					                showCancelButton: true,
					                confirmButtonText: myLabel.dialog_btn_save,
					                cancelButtonText: myLabel.dialog_btn_cancel,
					                closeOnConfirm: false,
					                showLoaderOnConfirm: true
					            }, function (isConfirm) {
					            	if (isConfirm) {
										$('#setWTimeModal').modal('hide');
										saveTime($('#frmDefaultWTime'));
					            	}
					            });
							} else {
								saveTime($('#frmDefaultWTime'));
							}
						}else{
							$('#time-error-msg').html(data.text).parent().show();
							setTimeout(function() { $('#time-error-msg').html("").parent().hide(); }, 2000);
						}
					});
					return false;
				}
			});
        }
        
        if ($("#grid").length > 0 && datagrid) 
        {
			$grid = $("#grid").datagrid({
				buttons: [{type: "edit", url: "index.php?controller=pjAdminTime&action=pjActionGetUpdate&id={:id}"},
				          {type: "delete", url: "index.php?controller=pjAdminTime&action=pjActionDeleteDayOff&id={:id}"}],
				columns: [{text: myLabel.dates, type: "text", sortable: true, editable: false},
				          {text: myLabel.is_dayoff, type: "text", sortable: true, editable: false},
						  {text: myLabel.hour, type: "text", sortable: false, editable: false},
						  {text: myLabel.lunch, type: "text", sortable: false, editable: false}],
				dataUrl: "index.php?controller=pjAdminTime&action=pjActionGetDayOff&id=" + pjGrid.id + "&foreign_id=" + pjGrid.foreign_id + "&type=" + pjGrid.type,
				dataType: "json",
				fields: ['dates', 'is_dayoff', 'hour', 'lunch'],
				paginator: {
					actions: [
					   {text: myLabel.delete_selected, url: "index.php?controller=pjAdminTime&action=pjActionDeleteDayOffBulk", render: true, confirmation: myLabel.delete_confirmation},
					],
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminTime&action=pjActionSaveDayOff&id={:id}",
				select: {
					field: "id",
					name: "record[]",
					cellClass: 'cell-width-2'
				}
			});
		}

        if($frmSetDayOff.length > 0)
        {
        	$frmSetDayOff.validate({
				onkeyup: false,
				ignore: "",
				submitHandler: function (form) {
					var l = Ladda.create( $(form).find(":submit").get(0) );
					l.start();
					$.post("index.php?controller=pjAdminTime&action=pjActionCheckDayOff", $frmSetDayOff.serialize()).done(function (data) {
						l.stop();
						if(data.status == 'OK')
						{
							if (data.code == '200') {
								setDayOff($frmSetDayOff);
							} else {
								swal({
					                title: myLabel.dialog_title_over,
					                text: myLabel.dialog_body_over,
					                type: "warning",
					                showCancelButton: true,
					                confirmButtonText: myLabel.dialog_btn_save,
					                cancelButtonText: myLabel.dialog_btn_cancel,
					                closeOnConfirm: false,
					                showLoaderOnConfirm: true
					            }, function (isConfirm) {
					            	if (isConfirm) {
										setDayOff($frmSetDayOff);
										swal.close();
					            	}
					            });
							}
						}else{
							$('#dayoff-error-msg').html(data.text).parent().show();
							setTimeout(function() { $('#dayoff-error-msg').html("").parent().hide(); }, 5000);
						}
					});
					return false;
				}
			});
        }
        
		$(document).on('click', '.remove-time', function(e){
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $td = $(this).parent().parent();
			$(this).parent().remove();
			if($td.find('span').length <= 0)
			{
				if ($(this).attr("rev") == 'day')
				{
					$td.html(myLabel.day_off);
				} else {
					$td.html(myLabel.lunch_off);
				}
			}
			saveTime($('#frmDefaultWTime'));
		}).on("click", ".btn-outline", function (e) {
			var ajax_url = $(this).attr('href');
			if($(this).find('.fa-pencil').length > 0){
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				$.get(ajax_url).done(function (data) {
					$('#btn-dialog-submit').html(myLabel.dialog_btn_save);
					$('#dialog-title').html(myLabel.dialog_title_save);
					$frmSetDayOff.find('input[name="id"]').val(data.id);
					$frmSetDayOff.find('input[name="from_date"]').val(data.from_date);
					$frmSetDayOff.find('input[name="to_date"]').val(data.to_date);
					$frmSetDayOff.find('input[name="start_time"]').val(data.start_time);
					$frmSetDayOff.find('input[name="end_time"]').val(data.end_time);
					$frmSetDayOff.find('input[name="start_lunch"]').val(data.start_lunch);
					$frmSetDayOff.find('input[name="end_lunch"]').val(data.end_lunch);
					if (data.is_dayoff == "T") {
						$frmSetDayOff.find('input[name="is_dayoff"]').attr("checked", true);
						$frmSetDayOff.find('.box-time').hide();
						$frmSetDayOff.find("#start_time").removeClass("required");
						$frmSetDayOff.find("#end_time").removeClass("required");
					} else {
						$frmSetDayOff.find('input[name="is_dayoff"]').attr("checked", false);
						$frmSetDayOff.find('.box-time').show();
						$frmSetDayOff.find("#start_time").addClass("required");
						$frmSetDayOff.find("#end_time").addClass("required");
					}
					$('#dayOffModal').modal('show');
				});
			}
		}).on('hidden.bs.modal', '#dayOffModal', function(e){
			$('#btn-dialog-submit').html(myLabel.dialog_btn_save);
			$('#dialog-title').html(myLabel.dialog_title_add);
			$frmSetDayOff.find('input[name="id"]').val("");
			$frmSetDayOff.find('input[name="from_date"]').val(myLabel.current_date);
			$frmSetDayOff.find('input[name="to_date"]').val(myLabel.current_date);
			$frmSetDayOff.find('input[name="is_dayoff"]').attr("checked", false);
			$frmSetDayOff.find('input[name="start_time"]').val("");
			$frmSetDayOff.find('input[name="end_time"]').val("");
			$frmSetDayOff.find('input[name="start_lunch"]').val("");
			$frmSetDayOff.find('input[name="end_lunch"]').val("");
			$(".box-time").show();
		}).on("click", "#is_dayoff", function (e) {
			if ($(this).is(":checked") == true) {
				$(".box-time").hide();
				$("#start_time").removeClass("required");
				$("#end_time").removeClass("required");
			} else {
				$(".box-time").show();
				$("#start_time").addClass("required");
				$("#end_time").addClass("required");
			}
		});
		
		$('#setWTimeModal').on('hidden.bs.modal', function () {
			var url = "index.php?controller=pjAdminTime&action=pjActionIndex";
			if (pjGrid.type != "") {
				url += "&type=" + pjGrid.type;
			}
			if (pjGrid.foreign_id != "") {
				url += "&foreign_id=" + pjGrid.foreign_id;
			}
			url += "&tab=2";
			window.location.href = url;
		});
	});
})(jQuery_1_8_2);