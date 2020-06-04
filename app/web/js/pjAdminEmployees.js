var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var $frmCreateEmployee = $("#frmCreateEmployee"),
			$frmUpdateEmployee = $("#frmUpdateEmployee"),
			$gallery = $("#gallery"),
			$frmSetWTime = $('#frmSetWTime'),
			$frmSetDayOff = $('#frmSetDayOff'),
			$grid_time,
			datepicker = ($.fn.datepicker !== undefined),
			gallery = ($.fn.gallery !== undefined),
			dialog = ($.fn.dialog !== undefined),
			multilang = ($.fn.multilang !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			vOpts;
		
		if (multilang && myLabel.isFlagReady == 1) {
			$(".multilang").multilang({
				langs: pjLocale.langs,
				flagPath: pjLocale.flagPath,
				tooltip: "",
				select: function (event, ui) {
					$("input[name='locale_id']").val(ui.index);					
				}
			});
		}
		
		if ($(".select-item").length) {
            $(".select-item").select2({
                placeholder: myLabel.choose,
                allowClear: true
            });
        };
        
		vOpts = {
			rules: {
				email: {
					required: true,
					email: true,
					remote: "index.php?controller=pjBaseUsers&action=pjActionCheckEmail"
				}
			},
			messages: {
				email: {
					remote: myLabel.email_taken
				}
			},
			errorPlacement: function (error, element) {
				error.insertAfter(element.parent());
			},
			onkeyup: false,
			submitHandler: function (form) {
				var ladda_buttons = $(form).find('.ladda-button');
			    if(ladda_buttons.length > 0)
                {
                    var l = ladda_buttons.ladda();
                    l.ladda('start');
                }
				$.post('index.php?controller=pjBaseUsers&action=pjActionCheckPassword', $(form).serialize()).done(function (data) {
        			if(data.status == 'OK')
    				{
        				form.submit();
    				}else{
    					l.ladda('stop');
    					swal({
    		                title: myLabel.invalid_password_title,
    		                type: "warning",
    		                text: data.text,
    		                showCancelButton: false,
    		                confirmButtonColor: "#11511a",
    		                confirmButtonText: myLabel.btn_ok,
    		                closeOnConfirm: true,
    		            });
    				}
        		});
				return false;
			}
		};
		
		if ($frmCreateEmployee.length > 0) {
			$frmCreateEmployee.validate(vOpts);
		}
		if ($frmUpdateEmployee.length > 0) {
			vOpts.rules.email.remote = vOpts.rules.email.remote + "&id=" + $frmUpdateEmployee.find("input[name='id']").val();
			$frmUpdateEmployee.validate(vOpts);
		}
		
		function formatAvatar(path, obj) {
			var src = 'app/web/img/backend/professional.gif';
			if (path !== null && path.length > 0) {
				src = path;
			}
			return ['<a href="index.php?controller=pjAdminEmployees&action=pjActionUpdate&id=', obj.id, '"><img src="', src, '" alt="" class="as-avatar" /></a>'].join('');
		}
		function formatEmail(email, obj) {
			return email + '<br/>' + (obj.phone != null ? obj.phone : "");
		}
		if ($("#grid").length > 0 && datagrid) {
			
			var editable = false;
			var buttons = [];
			if (myLabel.has_update) {
				editable = true;
				buttons.push({type: "edit", url: "index.php?controller=pjAdminEmployees&action=pjActionUpdate&id={:id}"});
			}
			if (myLabel.has_delete) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminEmployees&action=pjActionDeleteEmployee&id={:id}"});
			}
			buttons.push({type: "menu", url: "#", text: myLabel.menu, items: [
                {text: myLabel.view_bookings, url: "index.php?controller=pjAdminBookings&action=pjActionIndex&employee_id={:id}"}, 
                {text: myLabel.working_time, url: "index.php?controller=pjAdminEmployees&action=pjActionTime&type=employee&foreign_id={:id}"}
            ]});
		
			var actions = [];
			if (myLabel.has_delete_bulk) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminEmployees&action=pjActionDeleteEmployeeBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			
			var select = false;
			if (actions.length) {
				select = {
					field: "id",
					name: "record[]"
				};
			}
			
			var options = {
				buttons: buttons,
				columns: [{text: myLabel.avatar, type: "text", sortable: true, editable: false, renderer: formatAvatar},
				          {text: myLabel.name, type: "text", sortable: true, editable: editable},
				          {text: myLabel.emailphone, type: "text", sortable: true, editable: false, renderer: formatEmail},
				          {text: myLabel.services, type: "text", sortable: true, editable: false},
				          {text: myLabel.status, type: "toggle", sortable: true, editable: editable, positiveLabel: myLabel.active, positiveValue: "T", negativeLabel: myLabel.inactive, negativeValue: "F"}],
				dataUrl: "index.php?controller=pjAdminEmployees&action=pjActionGetEmployee" + pjGrid.queryString,
				dataType: "json",
				fields: ['avatar', 'name', 'email', 'services', 'is_active'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminEmployees&action=pjActionSaveEmployee&id={:id}",
				select: select
			};
			
			var m = window.location.href.match(/&is_active=(\d+)/);
			if (m !== null) {
				options.cache = {"is_active" : m[1]};
			}
			
			var $grid = $("#grid").datagrid(options);
		}
		
		if ($frmSetWTime.length > 0 && datepicker) {
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
        	$.post("index.php?controller=pjAdminEmployees&action=pjActionSetDayOff", $frmSetDayOff.serialize()).done(function (data) {
				var url = "index.php?controller=pjAdminEmployees&action=pjActionTime";
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
	        $.post("index.php?controller=pjAdminEmployees&action=pjActionSaveTime", $frmDefaultWTime.serialize()).done(function (data) {
				var url = "index.php?controller=pjAdminEmployees&action=pjActionTime";
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
					$.post("index.php?controller=pjAdminEmployees&action=pjActionSetTime", $('#frmDefaultWTime, #frmSetWTime').serialize()).done(function (data) {
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
        
        if ($("#grid_time").length > 0 && datagrid) 
        {
			$grid_time = $("#grid_time").datagrid({
				buttons: [{type: "edit", url: "index.php?controller=pjAdminEmployees&action=pjActionGetUpdate&id={:id}"},
				          {type: "delete", url: "index.php?controller=pjAdminEmployees&action=pjActionDeleteDayOff&id={:id}"}],
				columns: [{text: myLabel.dates, type: "text", sortable: true, editable: false},
				          {text: myLabel.is_dayoff, type: "text", sortable: true, editable: false},
						  {text: myLabel.hour, type: "text", sortable: false, editable: false},
						  {text: myLabel.lunch, type: "text", sortable: false, editable: false}],
				dataUrl: "index.php?controller=pjAdminEmployees&action=pjActionGetDayOff&id=" + pjGrid.id + "&foreign_id=" + pjGrid.foreign_id + "&type=" + pjGrid.type,
				dataType: "json",
				fields: ['dates', 'is_dayoff', 'hour', 'lunch'],
				paginator: {
					actions: [
					   {text: myLabel.delete_selected, url: "index.php?controller=pjAdminEmployees&action=pjActionDeleteDayOffBulk", render: true, confirmation: myLabel.delete_confirmation},
					],
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminEmployees&action=pjActionSaveDayOff&id={:id}",
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
					$.post("index.php?controller=pjAdminEmployees&action=pjActionCheckDayOff", $frmSetDayOff.serialize()).done(function (data) {
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
        
		$(document).on("click", ".btn-all", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(this).addClass("btn-primary active").removeClass("btn-default")
				.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			var content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				is_active: "",
				q: ""
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminEmployees&action=pjActionGetEmployee", "name", "ASC", content.page, content.rowCount);
			
		}).on("click", ".btn-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache"),
				obj = {};
			$this.addClass("btn-primary active").removeClass("btn-default")
				.siblings(".btn").removeClass("btn-primary active").addClass("btn-default");
			obj.is_active = "";
			obj[$this.data("column")] = $this.data("value");
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminEmployees&action=pjActionGetEmployee", "name", "ASC", content.page, content.rowCount);
			
		}).on("submit", ".frm-filter", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			$.extend(cache, {
				q: $this.find("input[name='q']").val()
			});
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminEmployees&action=pjActionGetEmployee", "id", "ASC", content.page, content.rowCount);
			return false;
		}).on("click", ".pj-delete-thumb", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			
			var id = $(this).attr('rev');
			var $this = $(this);
			swal({
				title: myLabel.alert_title,
				text: myLabel.alert_text,
				type: "warning",
				showCancelButton: true,
				confirmButtonColor: "#DD6B55",
				confirmButtonText: myLabel.btn_delete,
				cancelButtonText: myLabel.btn_cancel,
				closeOnConfirm: false,
				showLoaderOnConfirm: true
			}, function () {
				$.post($this.attr("href"), {id: id}).done(function (data) {
					if (!(data && data.status)) {
						
					}
					switch (data.status) {
					case "OK":
						swal.close();
						$('.pj-user-thumb').remove();
						break;
					}
				});
			});
		}).on('click', '.remove-time', function(e){
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
			if ($frmSetWTime.length > 0) {
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
			var url = "index.php?controller=pjAdminEmployees&action=pjActionTime";
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