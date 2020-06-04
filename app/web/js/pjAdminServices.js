var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		var $frmCreateService = $("#frmCreateService"),
			$frmUpdateService = $("#frmUpdateService"),
			$gallery = $("#gallery"),
			dialog = ($.fn.dialog !== undefined),
			gallery = ($.fn.gallery !== undefined),
			multilang = ($.fn.multilang !== undefined),
			datagrid = ($.fn.datagrid !== undefined);
		
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
                placeholder: myLabel.choose ,
                allowClear: true
            });
        };
        
		if ($frmCreateService.length > 0) {
			$frmCreateService.validate({
				rules:{
					"price":{
						positiveNumber: true
					},
					"length":{
						positiveNumber: true
					},
					"before":{
						positiveNumber: true
					},
					"after":{
						positiveNumber: true
					}
				},
				errorPlacement: function (error, element) {
					var name = element.attr('name');
					error.insertAfter(element.parent());
				},
				onkeyup: false
			});
			$.validator.addMethod('positiveNumber',
			    function (value) { 
			        return Number(value) >= 0;
			    }, 
			    myLabel.positiveNumber
			);
			$('[data-toggle="tooltip"]').tooltip(); 
		}
		if ($frmUpdateService.length > 0) {
			$frmUpdateService.validate({
				rules:{
					"price":{
						positiveNumber: true
					},
					"length":{
						positiveNumber: true
					},
					"before":{
						positiveNumber: true
					},
					"after":{
						positiveNumber: true
					}
				},
				errorPlacement: function (error, element) {
					var name = element.attr('name');
					error.insertAfter(element.parent());
				},
				onkeyup: false
			});
			$.validator.addMethod('positiveNumber',
			    function (value) { 
			        return Number(value) >= 0;
			    }, 
			    myLabel.positiveNumber
			);
			$('[data-toggle="tooltip"]').tooltip(); 
		}
		
		if($(".touchspin3").length > 0)
		{
			$(".touchspin3").TouchSpin({
				min: 0,
				max: 1000000000,
				step: 1,
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white'
	        });
		}

		if($(".touchspinLength").length > 0)
		{
			$(".touchspinLength").TouchSpin({
				min: 1,
				max: 1000000000,
				step: 1,
				verticalbuttons: true,
	            buttondown_class: 'btn btn-white',
	            buttonup_class: 'btn btn-white'
	        });
		}
		
		if ($gallery.length > 0 && gallery) {
			$gallery.gallery({
				compressUrl: "index.php?controller=pjGallery&action=pjActionCompressGallery&foreign_id=" + myGallery.foreign_id,
				getUrl: "index.php?controller=pjGallery&action=pjActionGetGallery&foreign_id=" + myGallery.foreign_id,
				deleteUrl: "index.php?controller=pjGallery&action=pjActionDeleteGallery",
				emptyUrl: "index.php?controller=pjGallery&action=pjActionEmptyGallery&foreign_id=" + myGallery.foreign_id,
				rebuildUrl: "index.php?controller=pjGallery&action=pjActionRebuildGallery&foreign_id=" + myGallery.foreign_id,
				resizeUrl: "index.php?controller=pjGallery&action=pjActionCrop&model=pjService&id={:id}&foreign_id=" + myGallery.foreign_id + "&hash=" + myGallery.hash + ($frmUpdateService.length > 0 ? "&query_string=" + encodeURIComponent("controller=pjAdminServices&action=pjActionUpdate&id=" + myGallery.foreign_id + "&tab_id=tabs-2") : ""),
				rotateUrl: "index.php?controller=pjGallery&action=pjActionRotateGallery",
				sortUrl: "index.php?controller=pjGallery&action=pjActionSortGallery",
				updateUrl: "index.php?controller=pjGallery&action=pjActionUpdateGallery",
				uploadUrl: "index.php?controller=pjGallery&action=pjActionUploadGallery&foreign_id=" + myGallery.foreign_id,
				watermarkUrl: "index.php?controller=pjGallery&action=pjActionWatermarkGallery&foreign_id=" + myGallery.foreign_id
			});
		}
		
		function formatPrice(str, obj) {
			return obj.price_format;
		}
		
		if ($("#grid").length > 0 && datagrid) {
			function formatEmployees (str, obj) 
			{
				if(parseInt(str, 10) > 0)
				{
					return '<span class="pj-number-cell"><a href="index.php?controller=pjAdminEmployees&action=pjActionIndex&service_id='+obj.id+'">'+str+'</a></span>';
				}else{
					return '<span class="pj-number-cell">'+str+'</span>';
				}
			}
			function formatLen (str, obj) 
			{
				return '<span class="pj-number-cell">'+str+'</span>';
			}
			function formatTotal (str, obj) 
			{
				return '<span class="pj-number-cell">'+str+'</span>';
			}
			var editable = false;
			var buttons = [];
			if (myLabel.has_update) {
				editable = true;
				buttons.push({type: "edit", url: "index.php?controller=pjAdminServices&action=pjActionUpdate&id={:id}"});
			}
			if (myLabel.has_delete) {
				buttons.push({type: "delete", url: "index.php?controller=pjAdminServices&action=pjActionDeleteService&id={:id}"});
			}
			var actions = [];
			if (myLabel.has_delete_bulk) {
				actions.push({text: myLabel.delete_selected, url: "index.php?controller=pjAdminServices&action=pjActionDeleteServiceBulk", render: true, confirmation: myLabel.delete_confirmation});
			}
			
			var select = false;
			if (actions.length) {
				select = {
					field: "id",
					name: "record[]"
				};
			}
			
			var $grid = $("#grid").datagrid({
				buttons: buttons,
				columns: [{text: myLabel.name, type: "text", sortable: true, editable: editable, editableWidth: 250},
				          {text: myLabel.employees, type: "text", sortable: true, editable: false, renderer: formatEmployees},
				          {text: myLabel.price, type: "text", sortable: true, editable: editable, editableWidth: 100, renderer: formatPrice},
				          {text: myLabel.len, type: "text", sortable: true, editable: false, renderer: formatLen},
				          {text: myLabel.total, type: "text", sortable: true, editable: false, renderer: formatTotal},
				          {text: myLabel.status, type: "toggle", sortable: true, editable: editable, positiveLabel: myLabel.active, positiveValue: "1", negativeLabel: myLabel.inactive, negativeValue: "0"}],
				dataUrl: "index.php?controller=pjAdminServices&action=pjActionGetService",
				dataType: "json",
				fields: ['name', 'employees', 'price', 'length', 'total', 'is_active'],
				paginator: {
					actions: actions,
					gotoPage: true,
					paginate: true,
					total: true,
					rowCount: true
				},
				saveUrl: "index.php?controller=pjAdminServices&action=pjActionSaveService&id={:id}",
				select: select
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
			$grid.datagrid("load", "index.php?controller=pjAdminServices&action=pjActionGetService", "name", "ASC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminServices&action=pjActionGetService", "name", "ASC", content.page, content.rowCount);
			
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
			$grid.datagrid("load", "index.php?controller=pjAdminServices&action=pjActionGetService", "id", "ASC", content.page, content.rowCount);
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
		});
	});
})(jQuery_1_8_2);