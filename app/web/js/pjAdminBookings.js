var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var validator, $frmBooking,
			$frmCreateBooking = $("#frmCreateBooking"),
			$frmUpdateBooking = $("#frmUpdateBooking"),
			$frmExportBookings = $('#frmExportBookings'),
			$modalAddItem = $("#modalAddItem"),
			$modalItemEmail = $("#modalItemEmail"),
			$modalItemSms = $("#modalItemSms"),
			validate = ($.fn.validate !== undefined),
			datagrid = ($.fn.datagrid !== undefined),
			datepicker = ($.fn.datepicker !== undefined);
		
		if (datepicker && myLabel.days !== undefined) {
			$.fn.datepicker.dates['en'] = {
	        	days: ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
	        	daysMin: myLabel.days.split("_"),
	        	daysShort: ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"],
	        	months: myLabel.months.split("_"),
	        	monthsShort: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]
    		}
		}
		
		function myTinyMceDestroy() {
			
			if (window.tinymce === undefined) {
				return;
			}
			
			var iCnt = tinymce.editors.length;
			
			if (!iCnt) {
				return;
			}
			
			for (var i = 0; i < iCnt; i++) {
				tinymce.remove(tinymce.editors[i]);
			}
		}
		
		function myTinyMceInit(pSelector) {
			
			if (window.tinymce === undefined) {
				return;
			}
			
			tinymce.init({
				relative_urls : false,
				remove_script_host : false,
				convert_urls : true,
				browser_spellcheck : true,
			    contextmenu: false,
			    selector: pSelector,
			    theme: "modern",
			    height: 250,
			    plugins: [
			         "advlist autolink link image lists charmap print preview hr anchor pagebreak",
			         "searchreplace wordcount visualblocks visualchars code fullscreen insertdatetime media nonbreaking",
			         "save table contextmenu directionality emoticons template paste textcolor"
			    ],
			    toolbar: "insertfile undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image | print preview media fullpage | forecolor backcolor emoticons",
			    image_advtab: true,
			    menubar: "file edit insert view table tools",
			    setup: function (editor) {
			    	editor.on('change', function (e) {
			    		editor.editorManager.triggerSave();
			    	});
			    }
			});
		}
		
		if($('.frm-filter-advanced .date').length > 0 && datepicker)
        {
            $('.frm-filter-advanced .date').datepicker();
        }
		
        if ($(".select-countries").length) {
            $(".select-countries").select2({
                placeholder: myLabel.choose,
                allowClear: true
            });
        }

		function getBookingItems(booking_id, tmp_hash) {
			if ($frmCreateBooking.length > 0) {
				var $form = $frmCreateBooking;
			} else {
				var $form = $frmUpdateBooking;
			}
			
			$.get("index.php?controller=pjAdminBookings&action=pjActionItemGet", {
				"booking_id": booking_id,
				"tmp_hash": tmp_hash
			}).done(function (data) {
				$("#boxBookingItems").html(data);
				if (data.indexOf("pj-table") >= 0)
				{
					$("#boxBookingItems").parent().find("em").remove();
				}
				$modalAddItem.modal('hide');
				
				$.post("index.php?controller=pjAdminBookings&action=pjActionGetPrice", $form.serialize()).done(function (data) {
					if (data.status == 'OK') {
						$form.find("#booking_price").val(data.data.price.toFixed(2));
						$form.find("#booking_deposit").val(data.data.deposit.toFixed(2));
						$form.find("#booking_tax").val(data.data.tax.toFixed(2));
						$form.find("#booking_total").val(data.data.total.toFixed(2));
						$("#price_format").html(data.data_format.price_format);
						$("#tax_format").html(data.data_format.tax_format);
						$("#total_format").html(data.data_format.total_format);
						$("#deposit_format").html(data.data_format.deposit_format);
					}
				});
			});
		}
		if ($frmCreateBooking.length > 0 && validate) {
			$frmCreateBooking.validate({
				rules: {
					"uuid": {
						remote: "index.php?controller=pjAdminBookings&action=pjActionCheckUID"
					},
					"booking_items":{
						required: function(e){
							if($('#boxBookingItems').find('.table').length > 0){
								return false;
							}else{
								return true;
							}
						}
					}
				},
				messages: {
					"uuid": {
						remote: myLabel.uuid_used
					},
					"booking_items":{
						required: myLabel.services_required
					}
				},
				errorPlacement: function (error, element) {
					if(element.attr('name') == 'booking_price')
					{
						error.insertAfter(element.parent());
					}else{
						error.insertAfter(element);
					}
				},
				onkeyup: false,
				ignore: ".ignore",
				invalidHandler: function (event, validator) {
					if (validator.numberOfInvalids()) {
				    	var index = $(validator.errorList[0].element, this).closest(".tab-pane").index();
				    	if (index !== -1) {
				    	    $('.nav-tabs li:nth-child(' + (index + 1) + ') a').tab('show');
				    	}
				    }
				}
			});
			$frmBooking = $frmCreateBooking;
			
			if($frmCreateBooking.find("input[name='bs_id']").length > 0)
			{
				getBookingItems.call(null, null, $frmCreateBooking.find("input[name='tmp_hash']").val());
			}
		}
		
		if ($frmUpdateBooking.length > 0) {
			
			$frmUpdateBooking.on("click", ".btnCreateInvoice", function () {
				$("#frmCreateInvoice").trigger("submit");
			});
			
			if (validate) {
				$frmUpdateBooking.validate({
					rules: {
						"uuid": {
							remote: "index.php?controller=pjAdminBookings&action=pjActionCheckUID&id=" + $frmUpdateBooking.find("input[name='id']").val()
						},
						"booking_items":{
							required: function(e){
								if($('#boxBookingItems').find('.table').length > 0){
									return false;
								}else{
									return true;
								}
							}
						}
					},
					messages: {
						"uuid": {
							remote: myLabel.uuid_used
						},
						"booking_items":{
							required: myLabel.services_required
						}
					},
					errorPlacement: function (error, element) {
						if(element.attr('name') == 'booking_price')
						{
							error.insertAfter(element.parent());
						}else{
							error.insertAfter(element);
						}
					},
					onkeyup: false,
					ignore: ".ignore",
					invalidHandler: function (event, validator) {
						if (validator.numberOfInvalids()) {
					    	var index = $(validator.errorList[0].element, this).closest(".tab-pane").index();
					    	if (index !== -1) {
					    	    $('.nav-tabs li:nth-child(' + (index + 1) + ') a').tab('show');
					    	}
					    }
					},
					submitHandler: function (form) {
						var ladda_buttons = $(form).find('.ladda-button');
					    if(ladda_buttons.length > 0)
	                    {
	                        var l = ladda_buttons.ladda();
	                        l.ladda('start');
	                    }
						$.post('index.php?controller=pjAdminBookings&action=pjActionCheckOverwrite', $(form).serialize()).done(function (data) {
		        			if(data.status == 'OK')
		    				{
		        				form.submit();
		    				}else{
		    					l.ladda('stop');
		    					swal({
		    		                title: myLabel.overwrite_title,
		    		                type: "warning",
		    		                text: myLabel.overwrite_body,
		    		                showCancelButton: false,
		    		                confirmButtonColor: "#11511a",
		    		                confirmButtonText: myLabel.btn_ok,
		    		                closeOnConfirm: true,
		    		            });
		    				}
		        		});
						return false;
					}
				});
			}
			$frmBooking = $frmUpdateBooking;
			
			getBookingItems.call(null, $frmUpdateBooking.find("input[name='id']").val());
		}
		
		function formatDateTime(str) {
			if (str === null || str.length === 0) {
				return myLabel.empty_datetime;
			}
			
			if (str === '0000-00-00 00:00:00') {
				return myLabel.invalid_datetime;
			}
			
			if (str.match(/\d{4}-\d{2}-\d{2}\s\d{2}:\d{2}:\d{2}/) !== null) {
				var x = str.split(" "),
					date = x[0],
					time = x[1],
					dx = date.split("-"),
					tx = time.split(":"),
					y = dx[0],
					m = parseInt(dx[1], 10) - 1,
					d = dx[2],
					hh = tx[0],
					mm = tx[1],
					ss = tx[2];
				return $.datagrid.formatDate(new Date(y, m, d, hh, mm, ss), pjGrid.jsDateFormat + ", hh:mm");
			}
		}
		
		function formatServices(str, obj) {
			var tmp,
				arr = [];
			for (var i = 0, iCnt = obj.items.length; i < iCnt; i++) {
				tmp = obj.items[i].split("~.~");
				arr.push([tmp[2], '<a href="index.php?controller=pjAdminBookings&action=pjActionUpdate&id='+obj.id+'">'+tmp[1] + '</a>'].join("<br/>"));
			}
			
			return arr.join("<br />");
		}
		
		function formatClient (str, obj) {
			return [obj.c_name, 
			        (obj.c_email && obj.c_email.length > 0 ? ['<br><a href="mailto:', obj.c_email, '">', obj.c_email, '</a>'].join('') : ''), 
			        (obj.c_phone && obj.c_phone.length > 0 ? ['<br>', obj.c_phone].join('') : '')
			        ].join("");
		}
		
		function formatDefault (str) {
			return myLabel[str] || str;
		}
		
		function formatId (str) {
			return ['<a href="index.php?controller=pjInvoice&action=pjActionUpdate&id=', str, '">#', str, '</a>'].join("");
		}
		
		function formatTotal(val, obj) {
			return obj.total_formated;
		}
		
		function formatStatus (str, obj) {
			switch (obj.booking_status)
            {
                case 'confirmed':
                    return '<i class="fa fa-check"></i> ' + str;
                    break;
                case 'pending':
                    return '<i class="fa fa-exclamation-triangle"></i> ' + str;
                    break;
                case 'cancelled':
                    return '<i class="fa fa-times"></i> ' + str;
                    break;
            }

			return str;
		}
		
		if ($("#grid").length > 0 && datagrid) {
			
			var buttons = [];
			if (myLabel.has_update) {
				buttons.push({type: "edit", url: "index.php?controller=pjAdminBookings&action=pjActionUpdate&id={:id}"});
			}
			if (myLabel.has_delete) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBooking&id={:id}"});
			}
		
			var actions = [];
			if (myLabel.has_delete_bulk) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminBookings&action=pjActionDeleteBookingBulk", render: true, confirmation: myLabel.delete_confirmation});
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
				columns: [{text: myLabel.services, type: "text", sortable: true, editable: false, renderer: formatServices},
				          {text: myLabel.customer, type: "text", sortable: true, editable: false, renderer: formatClient},
				          {text: myLabel.total, type: "text", sortable: true, editable: false, renderer: formatTotal},
				          {text: myLabel.status, type: "text", sortable: true, editable: false, renderer: formatStatus, applyClass: "btn btn-xs no-margin bg"}],
				dataUrl: "index.php?controller=pjAdminBookings&action=pjActionGetBooking" + pjGrid.queryString,
				dataType: "json",
				fields: ['id', 'c_name', 'booking_total', 'booking_status'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminBookings&action=pjActionSaveBooking&id={:id}",
				select: select
			};
			
			var cache = {},
				m1 = window.location.href.match(/&booking_status=(\w+)/),
				m2 = window.location.href.match(/&employee_id=(\d+)/);
			if (m1 !== null) {
				options.cache = $.extend(cache, {"booking_status" : m1[1]});
			}
			if (m2 !== null) {
				options.cache = $.extend(cache, {"employee_id" : m2[1]});
			}
			
			var $grid = $("#grid").datagrid(options);
		}
		
		if ($("#grid_invoices").length > 0 && datagrid) {
			var $grid_invoices = $("#grid_invoices").datagrid({
				buttons: [{type: "edit", url: "index.php?controller=pjInvoice&action=pjActionUpdate&id={:id}", title: "Edit"},
				          {type: "delete", url: "index.php?controller=pjInvoice&action=pjActionDelete&id={:id}", title: "Delete"}],
				columns: [
				    {text: myLabel.num, type: "text", sortable: true, editable: false, renderer: formatId},
				    {text: myLabel.order_id, type: "text", sortable: true, editable: false},
				    {text: myLabel.issue_date, type: "date", sortable: true, editable: false, renderer: $.datagrid._formatDate, dateFormat: pjGrid.jsDateFormat},
				    {text: myLabel.due_date, type: "date", sortable: true, editable: false, renderer: $.datagrid._formatDate, dateFormat: pjGrid.jsDateFormat},
				    {text: myLabel.created, type: "text", sortable: true, editable: false, renderer: formatDateTime},
				    {text: myLabel.status, type: "text", sortable: true, editable: false, renderer: formatDefault},	
				    {text: myLabel.total, type: "text", sortable: true, editable: false, align: "right", renderer: formatTotal}
				],
				dataUrl: "index.php?controller=pjInvoice&action=pjActionGetInvoices&q=" + $frmUpdateBooking.find("input[name='uuid']").val(),
				dataType: "json",
				fields: ['id', 'order_id', 'issue_date', 'due_date', 'created', 'status', 'total'],
				paginator: {
					actions: [
					   {text: myLabel.delete_title, url: "index.php?controller=pjInvoice&action=pjActionDeleteBulk", render: true, confirmation: myLabel.delete_body}
					],
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				select: {
					field: "id",
					name: "record[]"
				}
			});
		}
		
		$(document).on("click", ".item-add", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionItemAdd", $frmBooking.find("input[name='id'], input[name='tmp_hash'], #date_from, #hour_from, #minute_from, #date_to, #hour_to, #minute_to").serialize()).done(function (data) {
				$modalAddItem.find(".modal-content").html(data);
				validator = $modalAddItem.find("form").validate(aiOpts);
				
				if (datepicker) {
					$modalAddItem.find(".input-group.date").datepicker().on("changeDate", function () {
		        		onChange();
		        	});
		        }
			});
			return false;
		}).on("click", ".item-delete", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var id = $(this).data("id");
			swal({
                title: myLabel.service_delete_title,
                text: myLabel.service_delete_body,
                type: "warning",
                showCancelButton: true,
                confirmButtonText: myLabel.btn_delete,
                cancelButtonText: myLabel.btn_cancel,
                closeOnConfirm: false,
                showLoaderOnConfirm: true
            }, function () {
            	$.post("index.php?controller=pjAdminBookings&action=pjActionItemDelete", {
					"id": id
				}).done(function (data) {
					getBookingItems.call(null, $frmBooking.find("input[name='id']").val(), $frmBooking.find("input[name='tmp_hash']").val());
					if (!(data && data.status)) {
                        swal("Error!", '', "error");
                    }
                    switch (data.status) {
                        case "OK":
                            $('#btnDeleteMap').remove();
                            swal("Deleted!", data.text, "success");
                            break;
                        case "ERR":
                            swal("Error!", data.text, "error");
                            break;
                    }
				});
            });
		}).on("click", ".item-email", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionItemEmail", {
				"id": $(this).data("id")
			}).done(function (data) {
				$modalItemEmail.find(".modal-content").html(data);
				$modalItemEmail.modal('show');
				
				if ($('.mceEditor').length > 0) {
					myTinyMceDestroy.call(null);
					myTinyMceInit.call(null, 'textarea.mceEditor');
		        }
				
				validator = $modalItemEmail.find("form").validate({
					errorPlacement: function (error, element) {
						error.insertAfter(element.parent());
					},
					errorClass: "error_clean"
				});
			});
		}).on("click", ".btnItemEmail", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.post("index.php?controller=pjAdminBookings&action=pjActionItemEmail", $modalItemEmail.find("form").serialize()).done(function (data) {
				$modalItemEmail.modal('hide');
			});
		}).on("click", ".item-sms", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.get("index.php?controller=pjAdminBookings&action=pjActionItemSms", {
				"id": $(this).data("id")
			}).done(function (data) {
				$modalItemSms.find(".modal-content").html(data);
				$modalItemSms.modal('show');
				validator = $modalItemSms.find("form").validate({
					errorPlacement: function (error, element) {
						error.insertAfter(element.parent());
					},
					errorClass: "error_clean"
				});
			});
		}).on("click", ".btnItemSms", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.post("index.php?controller=pjAdminBookings&action=pjActionItemSms", $modalItemSms.find("form").serialize()).done(function (data) {
				$modalItemSms.modal('hide');
			});
		}).on("change", "#payment_method", function () {
			if ($("option:selected", this).val() == 'creditcard') {
				$(".erCC").show();
			} else {
				$(".erCC").hide();
			}
		}).on("change", "#export_period", function (e) {
			var period = $(this).val();
			if(period == 'last')
			{
				$('#last_label').show();
				$('#next_label').hide();
			}else{
				$('#last_label').hide();
				$('#next_label').show();
			}
		}).on("click", "#file", function (e) {
			$('#tsSubmitButton').html(myLabel.btn_export);
			$('.tsFeedContainer').hide();
			$('.tsPassowrdContainer').hide();
		}).on("click", "#feed", function (e) {
			$('.tsPassowrdContainer').show();
			$('#tsSubmitButton').html(myLabel.btn_get_url);
		}).on("focus", "#bookings_feed", function (e) {
			$(this).select();
		}).on("change", ".btn-filter", function () {
			
			var $this = $(this),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache"),
				obj = {};
			
			obj.booking_status = $this.val();
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", "id", "DESC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", "id", "DESC", content.page, content.rowCount);
			return false;
		}).on("submit", ".frm-filter-advanced", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var obj = {},
				$this = $(this),
				arr = $this.serializeArray(),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			for (var i = 0, iCnt = arr.length; i < iCnt; i++) {
				obj[arr[i].name] = arr[i].value;
			}
			cache.q = "";
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", "id", "DESC", content.page, content.rowCount);
			return false;
		}).on("reset", ".frm-filter-advanced", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(".pj-button-detailed").trigger("click");
			$('#q').val('');
			$('#booking_status').val('');
			$('#service_id').val('');
			$('#employee_id').val('');
			$('#date_from').val('');
			$('#date_to').val('');
			var obj = {},
				$this = $(this),
				arr = $this.serializeArray(),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			for (var i = 0, iCnt = arr.length; i < iCnt; i++) {
				obj[arr[i].name] = arr[i].value;
			}
			cache.q = "";
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", "index.php?controller=pjAdminBookings&action=pjActionGetBooking", "id", "DESC", content.page, content.rowCount);
			return false;
		}).on("click.as", ".asSlotAvailable", function (e) {	
			
			var $this = $(this),
				$form = $this.closest("form");
			
			if ($this.hasClass("asSlotSelected")) {
				$this.removeClass("asSlotSelected");
				
				$form.find("input[name='employee_id']").val("");
				$form.find("input[name='start_ts']").val("");
				$form.find("input[name='end_ts']").val("");
				
				$form.find(".data").text("---");
			} else {
				$form.find(".asSlotBlock").removeClass("asSlotSelected");
				$this.addClass("asSlotSelected");
				
				$form.find("input[name='employee_id']").val($this.data("employee_id"));
				$form.find("input[name='start_ts']").val($this.data("start_ts"));
				$form.find("input[name='end_ts']").val($this.data("end_ts"));
				
				$form.find(".bStartTime .data").text($this.data("start"));
				$form.find(".bEndTime .data").text($this.data("end"));
				$form.find(".bEmployee .data").text($this.closest(".asElement").find(".asEmployeeName").text());
			}
		}).on("click", ".apClientName", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$tabs.tabs().tabs("option", "active", 1);
			return false;
		}).on("change", "select[name='service_id']", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			onChange();
		}).on("click", ".btnAddItem", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			if (validator.form()) {
				$.post("index.php?controller=pjAdminBookings&action=pjActionItemAdd", $(".frm-item-add").serialize()).done(function (data) {
					if (data.status == "OK") {
						if ($("#booking_items-error").length > 0) {
							$("#booking_items-error").hide();
						}
					}
					getBookingItems.call(null, $frmBooking.find("input[name='id']").val(), $frmBooking.find("input[name='tmp_hash']").val());
				});
			}
		}).on("change", "#booking_status", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$(".bg-status").hide();
			$(".bg-" + $(this).val()).show();
		});
		
		function onChange() {
			var $form = $(".frm-item-add"),
				service_id = $form.find("select[name='service_id']").find("option:selected").val(),
				selector = "input[name='employee_id'], input[name='start_ts'], input[name='end_ts']",
				$details = $form.find(".item_details");
			
			if (!service_id.length) {
				$details.empty();
				return;
			}
			
			$.get("index.php?controller=pjAdminBookings&action=pjActionGetService", {
				"id": service_id,
				"date": $form.find("input[name='date']").val()
			}).done(function (data) {
				if (data.code == undefined || data.status == undefined) 
				{
					if (parseInt(service_id, 10) > 0) {
						$form.find(selector).removeClass("ignore");
						$form.find(".bStartTime, .bEndTime, .bEmployee").show();
					} else {
						$form.find(selector).addClass("ignore");
						$form.find(".bStartTime, .bEndTime, .bEmployee").hide();
					}
					$form.find(selector).val("");
					$form.find(".data").text("---");
					$details.html(data).show();
				}
			});
		}

		var aiOpts = {
			rules: {
				"date": "required",
				"service_id": {
					required: true,
					digits: true
				},
				"employee_id": {
					required: true,
					digits: true
				},
				"start_ts": {
					required: true,
					digits: true
				},
				"end_ts": {
					required: true,
					digits: true
				}
			},
			ignore: ".ignore"
		};
	});
})(jQuery_1_8_2);