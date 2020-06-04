var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var datagrid = ($.fn.datagrid !== undefined),
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
		
		if($('.frm-filter-advanced').length > 0)
        {
			$('.frm-filter-advanced').validate({
				rules: {
					"validate_date": {
					    remote: {
                            param: {
					            url: "index.php?controller=pjAdminReports&action=pjActionCheckDate",
                                type: "post",
                                data: {
                                    date_from: function() {
                                        return $( "#date_from" ).val();
                                    },
                                    date_to: function() {
                                        return $( "#date_to" ).val();
                                    }
                                }
                            }
                        }
                    }
				},
				errorPlacement: function (error, element) {
					error.insertAfter(element);
				},
				onkeyup: false,
				ignore: ""
			});
        }
		
		function formatBookingsTotal(str, obj) {
			return obj.total_amount_format;
		}
		function formatConfirmedTotal(str, obj) {
			return obj.confirmed_amount_format;
		}
		function formatPendingTotal(str, obj) {
			return obj.pending_amount_format;
		}
		function formatCancelledTotal(str, obj) {
			return obj.cancelled_amount_format;
		}

		function Employee() {
			
			this.cnt = {
				buttons: [],
				columns: [{text: myLabel.name, type: "text", sortable: true, editable: false},
				          {text: myLabel.total_bookings, type: "text", sortable: true, editable: false},
				          {text: myLabel.confirmed_bookings, type: "text", sortable: true, editable: false},
				          {text: myLabel.pending_bookings, type: "text", sortable: true, editable: false},
				          {text: myLabel.cancelled_bookings, type: "text", sortable: true, editable: false}
				],
				dataUrl: "index.php?controller=pjAdminReports&action=pjActionGetEmployee",
				dataType: "json",
				fields: ['name', 'total_bookings', 'confirmed_bookings', 'pending_bookings', 'cancelled_bookings'],
				paginator: {
					actions: [],
					gotoPage: false,
					paginate: false,
					total: true,
					rowCount: false
				}
			};
			
			this.amount = {
				buttons: [],
				columns: [{text: myLabel.name, type: "text", sortable: true, editable: true},
				          {text: myLabel.total_bookings, type: "text", sortable: true, editable: false, renderer: formatBookingsTotal},
				          {text: myLabel.confirmed_bookings, type: "text", sortable: true, editable: false, renderer: formatConfirmedTotal},
				          {text: myLabel.pending_bookings, type: "text", sortable: true, editable: false, renderer: formatPendingTotal},
				          {text: myLabel.cancelled_bookings, type: "text", sortable: true, editable: false, renderer: formatCancelledTotal}
				],
				dataUrl: "index.php?controller=pjAdminReports&action=pjActionGetEmployee",
				dataType: "json",
				fields: ['name', 'total_amount', 'confirmed_amount', 'pending_amount', 'cancelled_amount'],
				paginator: {
					actions: [],
					gotoPage: false,
					paginate: false,
					total: true,
					rowCount: false
				}
			};
			
			return this;
		}
		
		function Service() {
			
			this.cnt = {
				buttons: [],
				columns: [{text: myLabel.name, type: "text", sortable: true, editable: true},
				          {text: myLabel.total_bookings, type: "text", sortable: true, editable: false},
				          {text: myLabel.confirmed_bookings, type: "text", sortable: true, editable: false},
				          {text: myLabel.pending_bookings, type: "text", sortable: true, editable: false},
				          {text: myLabel.cancelled_bookings, type: "text", sortable: true, editable: false}
				],
				dataUrl: "index.php?controller=pjAdminReports&action=pjActionGetService",
				dataType: "json",
				fields: ['name', 'total_bookings', 'confirmed_bookings', 'pending_bookings', 'cancelled_bookings'],
				paginator: {
					actions: [],
					gotoPage: false,
					paginate: false,
					total: true,
					rowCount: false
				}
			};
			
			this.amount = {
				buttons: [],
				columns: [{text: myLabel.name, type: "text", sortable: true, editable: true},
				          {text: myLabel.total_bookings, type: "text", sortable: true, editable: false, renderer: formatBookingsTotal},
				          {text: myLabel.confirmed_bookings, type: "text", sortable: true, editable: false, renderer: formatConfirmedTotal},
				          {text: myLabel.pending_bookings, type: "text", sortable: true, editable: false, renderer: formatPendingTotal},
				          {text: myLabel.cancelled_bookings, type: "text", sortable: true, editable: false, renderer: formatCancelledTotal}
				],
				dataUrl: "index.php?controller=pjAdminReports&action=pjActionGetService",
				dataType: "json",
				fields: ['name', 'total_amount', 'confirmed_amount', 'pending_amount', 'cancelled_amount'],
				paginator: {
					actions: [],
					gotoPage: false,
					paginate: false,
					total: true,
					rowCount: false
				}
			};
			
			return this;
		}
		
		$(document).on("submit", ".frm-filter-advanced", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var url, nObj,
				obj = {},
				pattern = /^(.*)(\[)(\])$/,
				match = null,
				$this = $(this),
				arr = $this.serializeArray(),
				content = $grid.datagrid("option", "content"),
				cache = $grid.datagrid("option", "cache");
			for (var i = 0, iCnt = arr.length; i < iCnt; i++) {
				match = arr[i].name.match(pattern);
				if (match === null) {
					obj[arr[i].name] = arr[i].value;
				} else {
					if (!obj.hasOwnProperty(match[1])) {
						obj[match[1]] = [];
					}
					obj[match[1]].push(arr[i].value);
				}
			}
			cache.q = "";
			$.extend(cache, obj);
			$grid.datagrid("option", "cache", cache);
			
			switch ($this.data("view")) {
			case 'services':
				url = 'index.php?controller=pjAdminReports&action=pjActionGetService';
				nObj = new Service();
				break;
			case 'employees':
				url = 'index.php?controller=pjAdminReports&action=pjActionGetEmployee';
				nObj = new Employee();
				break;
			}
			
			var new_columns = nObj[cache.index].columns,
				new_fields = nObj[cache.index].fields;
			
			$grid.datagrid("option", "columns", new_columns);
			$grid.datagrid("option", "fields", new_fields);
			$grid.datagrid("option", "cache", cache);
			$grid.datagrid("load", url, "name", "ASC", content.page, content.rowCount);
			
			return false;
		}).on("click", ".btn-print", function (e) {
			var $frm = $(".frm-filter-advanced");
			var cache = $grid.datagrid("option", "cache"), 
				column = cache.column ? cache.column : 'name', 
				direction = cache.direction ? cache.direction : 'ASC';
			
			window.open('index.php?controller=pjAdminReports&action=pjActionPrint&type=' + $frm.data("view") 
									+ ($frm.data("view") == 'services' ? ("&employee_id=" + $frm.find("select[name='employee_id']").val()) : ("&service_id=" + $frm.find("select[name='service_id']").val()))
									+ "&index=" + $frm.find("select[name='index']").val()
									+ "&date_from=" + $frm.find("input[name='date_from']").val()
									+ "&date_to=" + $frm.find("input[name='date_to']").val()
									+ "&column=" + column
									+ "&direction=" + direction);
		});
		
		if ($("#grid_employees").length > 0 && datagrid) {
			var o = new Employee(),
				$grid = $("#grid_employees").datagrid(o.cnt);
		}
		
		if ($("#grid_services").length > 0 && datagrid) {
			var o = new Service(),
				$grid = $("#grid_services").datagrid(o.cnt);
		}
	});
})(jQuery_1_8_2);