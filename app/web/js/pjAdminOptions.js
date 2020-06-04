var jQuery_1_8_2 = jQuery_1_8_2 || $.noConflict();
(function ($, undefined) {
	$(function () {
		"use strict";
		var validate = ($.fn.validate !== undefined),
        	multilang = ($.fn.multilang !== undefined),
        	$document = $(document),
        	$frmOptConfirmation = $("#frmOptConfirmation"),
			$frmUpdateOptions = $('#frmUpdateOptions'),
			$frmNotifications = $('#frmNotifications'),
			$frmReminder = $('#frmReminder'),
			$tabs = $("#tabs"),
			tabs = ($.fn.tabs !== undefined);

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
			    height: 480,
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
		
		if ($('.mceEditor').length > 0) {
			myTinyMceDestroy.call(null);
			myTinyMceInit.call(null, 'textarea.mceEditor');
        }

        if (multilang && 'pjCmsLocale' in window) {
			$(".multilang").multilang({
				langs: pjCmsLocale.langs,
				flagPath: pjCmsLocale.flagPath,
				tooltip: "",
				select: function (event, ui) {
					$("input[name='locale_id']").val(ui.index);
				}
			});
		}
		
		if($(".field-int").length > 0)
        {
            $(".field-int").TouchSpin({
                verticalbuttons: true,
                buttondown_class: 'btn btn-white',
                buttonup_class: 'btn btn-white',
                max: 4294967295
            });
        }
		if ($frmUpdateOptions.length > 0) {
			$frmUpdateOptions.validate({
				
			});
		}
		// ---------------------------------------------------------------------
		function notificationsGetMetaData() {
			var $box = $("#boxNotificationsMetaData");
			if (!$box.length) {
				return;
			}
			
			// show preloader
			$box.empty().addClass("ibox-content-notification");
			
			$('<div class="ibox-content-overlay"></div> \
				<div class="sk-spinner sk-spinner-double-bounce"> \
					<div class="sk-double-bounce1"></div> \
					<div class="sk-double-bounce2"></div> \
				</div>').appendTo($box);
			
			$box.find(".ibox-content-overlay, .sk-spinner").show();

			var search = window.location.search,
				variant = search.match(/&?variant=(\w+)/),
				transport = search.match(/&?transport=(\w+)/),
				params = {
					recipient: $('input[name="recipient"]:checked').val()
				};
			
			if (variant !== null && transport !== null) {
				params.variant = variant[1];
				params.transport = transport[1];
			}
			
			$.get("index.php?controller=pjAdminOptions&action=pjActionNotificationsGetMetaData", params).done(function (data) {
				
				$box.html(data);
				
				if (variant !== null && transport !== null) {
					$box.find(['#variant', transport[1], variant[1]].join("_")).trigger("change");
				} else {
					$box.find('input[name="variant"]:first').trigger("change");
				}
				
			});
		}
		
		function notificationsGetContent() {
			var $box = $("#boxNotificationsContent");
			if (!$box.length) {
				return;
			}
			
			// show preloader
			$box.empty().addClass("ibox-content-notification");
			
			$('<div class="ibox-content-overlay"></div> \
				<div class="sk-spinner sk-spinner-double-bounce"> \
					<div class="sk-double-bounce1"></div> \
					<div class="sk-double-bounce2"></div> \
				</div>').appendTo($box);
			
			$box.find(".ibox-content-overlay, .sk-spinner").show();
			
			var $checked = $('input[name="variant"]:checked');
			
			$.get("index.php?controller=pjAdminOptions&action=pjActionNotificationsGetContent", {
				recipient: $('input[name="recipient"]:checked').val(),
				variant: $checked.val(),
				transport: $checked.data("transport")
			}).done(function (data) {
				
				$box.html(data);
				
				myTinyMceDestroy.call(null);
				myTinyMceInit.call(null, 'textarea.mceEditor');
				
				var index = $(".pj-form-langbar-item.btn-primary").data("index");
				if (index !== undefined) {
					$box.find('.pj-multilang-wrap[data-index!="' + index + '"]').hide();
					$box.find('.pj-multilang-wrap[data-index="' + index + '"]').show();
				}
			});
		}
		
		function notificationsSetContent(toggle) {
			
			var $box = $("#boxNotificationsContent");
			if (!$box.length) {
				return;
			}
			
			// show preloader
			$box.addClass("notification-box");
			
			$('<div class="ibox-content-overlay"></div> \
				<div class="sk-spinner sk-spinner-double-bounce"> \
					<div class="sk-double-bounce1"></div> \
					<div class="sk-double-bounce2"></div> \
				</div>').appendTo($box);
			
			$box.find(".ibox-content-overlay, .sk-spinner").show();
			
			var postData,
				$form = $box.find("form");
			
			if (toggle) {
				postData = $.param({
					is_active: ($form.find("#is_active").is(":checked") ? 1 : 0),
					id: $form.find('input[name="id"]').val()
				});
			} else {
				postData = $form.serialize();
				postData = postData.replace(/&?is_active=(\w+)?/, "");
				
				var l = Ladda.create($form.find(":submit").get(0));
				l.start();
			}
			
			$.post("index.php?controller=pjAdminOptions&action=pjActionNotificationsSetContent", postData).done(function (data) {
				
				if (data && data.status && data.status === "OK") {
					
					notificationsGetMetaData.call(null);
					
				}
				
			});
		}
		
		$("#boxNotificationsWrapper").on("change", 'input[name="recipient"]', function () {
			
			var search = window.location.search,
				recipient = search.match(/&?recipient=(\w+)/),
				variant = search.match(/&?variant=(\w+)/),
				transport = search.match(/&?transport=(\w+)/);
			
			var arr = [];
			arr.push("index.php?controller=pjAdminOptions&action=pjActionNotifications&recipient=");
			arr.push(this.value);
			
			if (recipient !== null && recipient[1] === this.value) {
				if (variant !== null && transport !== null) {
					arr.push("&transport=");
					arr.push(transport[1]);
					arr.push("&variant=");
					arr.push(variant[1]);
				}
			}
			
			var url = arr.join("");
			history.pushState({
				url: url,
				title: null
			}, null, url);
			
			notificationsGetMetaData.call(null);
			
		}).on("change", 'input[name="variant"]', function () {
			
			var $this = $(this);
			
			var url = ["index.php?controller=pjAdminOptions&action=pjActionNotifications&recipient=", $('input[name="recipient"]:checked').val(), "&transport=", $this.data("transport"), "&variant=", $this.val()].join("");
			history.pushState({
				url: url,
				title: null
			}, null, url);
			
			notificationsGetContent.call(null);
			
		}).on("change", '#is_active', function () {
			
			notificationsSetContent.call(null, true);
			
			var $this = $(this),
				$hidden = $this.closest("form").find(".notification-area");
			
			if ($this.is(":checked")) {
				$hidden.removeClass("hidden");
			} else {
				$hidden.addClass("hidden");
			}
			
		}).on("submit", "form", function (e) {
			e.preventDefault();
			
			notificationsSetContent.call(null, false);
			
			return false;
		});
		
		$('input[name="recipient"]:checked').trigger("change");
		
		$(window).on("popstate", function (e) {
			var state = e.originalEvent.state;
			if (state !== null) {
				//load
			} else {
				//empty
			}
		});
		// ---------------------------------------------------------------------

		if ($frmNotifications.length && validate) {
			$frmNotifications.validate();

			changeEmailBox();
		}

		if ($frmReminder.length && validate) {
			$frmReminder.validate();

			changeReminderBox();
		}
		
        function changeEmailBox()
		{
		    var tab_id = $('.nav-tabs .active a').attr('href').substring(1),
                id = $('#' + tab_id + '_email_notify').val();
			$('#' + tab_id).find('.boxEmail').hide();
			var activeSwitch = $('#switch_' + id);
			if(activeSwitch.length)
            {
                if(activeSwitch.is(':checked'))
                {
                    $('.boxEmail-' + id).show();
                }
                else
                {
                    activeSwitch.closest('.boxEmail-' + id).show();
                }
            }
		}
		
		function changeReminderBox()
		{
		    var activeSwitch = $('#switch_o_reminder_email_enable');
			$('.boxReminder').toggle(activeSwitch.length && activeSwitch.is(':checked'));
			
			var smsSwitch = $('#switch_o_reminder_sms_enable');
			$('.boxReminderSms').toggle(smsSwitch.length && smsSwitch.is(':checked'));
		}

		function reDrawCode() {
			var code = $("#hidden_code").text(),
				locale = $("select[name='install_locale']").length ? $("select[name='install_locale']").find("option:selected").val() : '',
				hide = $("input[name='install_hide']").is(":checked") ? "&hide=1" : "",
				opt = $("select[name='install_option']").find("option:selected").val(),
				tab = opt != 'both' ? "&tab=" + opt : "";
			locale = parseInt(locale.length, 10) > 0 ? "&locale=" + locale : "";
						
			$("#install_code").val(code.replace(/&action=pjActionLoadJS/g, function(match) {
	            return ["&action=pjActionLoad", tab, locale, hide].join("");
	        }));
		}
		
		$document.on("focus", ".textarea_install", function (e) {
			var $this = $(this);
			$this.select();
			$this.mouseup(function() {
				$this.unbind("mouseup");
				return false;
			});
		}).on("keyup", "#uri_page", function (e) {
			var tmpl = $("#hidden_htaccess").text(),
				tmpl_remote = $("#hidden_htaccess_remote").text(),
				index = this.value.indexOf("?");
			$("#install_htaccess").text(tmpl.replace('::URI_PAGE::', index >= 0 ? this.value.substring(0, index) : this.value));
			$("#install_htaccess_remote").text(tmpl_remote.replace('::URI_PAGE::', index >= 0 ? this.value.substring(0, index) : this.value));
		}).on("change", "select[name='value-enum-o_send_email']", function (e) {
			switch ($("option:selected", this).val()) {
			case 'mail|smtp::mail':
				$(".boxSmtp").hide();
				break;
			case 'mail|smtp::smtp':
				$(".boxSmtp").show();
				break;
			}
		}).on("change", "#email_notify", function (e) {
			var value = $(this).val();
			$('.notifyBox').hide();
			$('#' + value + 'Box').show();
		}).on("change", "select[name='install_option']", function (e) {
			reDrawCode.call(null);
		}).on("click", ".pj-use-theme", function (e) {
			var theme = $(this).attr('data-theme');
			$('.pj-loader').css('display', 'block');
			$.ajax({
				type: "GET",
				async: false,
				url: 'index.php?controller=pjAdminOptions&action=pjActionUpdateTheme&theme=' + theme,
				success: function (data) {
					$('.theme-holder').html(data);
					$('.pj-loader').css('display', 'none');
				}
			});
		}).on( 'change', '.onoffswitch-checkbox', function (e) {
			var name = $(this).attr('name');
			if($(this).is(':checked'))
			{
				$('input[name="value-enum-'+name+'"]').val('1|0::1');
			}else{
				$('input[name="value-enum-'+name+'"]').val('1|0::0');
			}
			if($frmNotifications.length > 0) {
                changeEmailBox();
            } else if($frmReminder.length > 0) {
                changeReminderBox();
            }
		}).on("change", "select[name='install_locale'], input[name='install_hide']", function(e) {
            reDrawCode.call(null);
		}).on("click", ".paymentLink", function (e) {
			console.log(this);
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			var select_locale_id = null;
			var payment_method = $(this).attr('data-method');
			$('.pj-form-langbar-item').each(function(){
				if($(this).hasClass('btn-primary'))
				{
					select_locale_id = $(this).attr('data-index');
				}
			});
			$.get("index.php?controller=pjAdminOptions&action=pjActionPaymentOptions", {
				"payment_method": payment_method
			}).done(function (data) {
				$('#modalContent').html(data);
				if (multilang && typeof pjCmsLocale != "undefined")
				{
					var $multilangWrap = $('#modalContent').find('.pj-multilang-wrap');
					$multilangWrap.each(function(e){
						var locale_id = $(this).attr('data-index');
						if(locale_id == select_locale_id)
						{
							$(this).show();
						}else{
							$(this).hide();
						}
					})
				}
				$('#paymentModal').modal('show');
			});
			
		}).on("click", "#btnSavePaymentOptions", function (e) {
			if (e && e.preventDefault) {
				e.preventDefault();
			}
			$.post("index.php?controller=pjAdminOptions&action=pjActionPaymentOptions", $('#frmPaymentOptions').serialize()).done(function (data) {
				$('#paymentModal').modal('hide');
				window.location.href = "index.php?controller=pjAdminOptions&action=pjActionPayments";
			});
			return false;
		}).on( 'change', '#enablePayment', function (e) {
			if ($(this).prop('checked')) {
                $('.hidden-area').show();
                $('#payment_is_active').val(1);
            }else {
                $('.hidden-area').hide();
                $('#payment_is_active').val(0);
            }
		});
		
		var $topMenu = $("#page-wrapper").children(".row.border-bottom"),
			$iframe = $("#iframeEditor"),
			$body = $("body"),
			$window = $(window);
	
		function resizeIframe() {
			if (!$iframe.length) {
				return;
			}
	
			$iframe.height($window.height() - $topMenu.outerHeight());
		}
	
		if ($iframe.length) {
	
			$iframe.on('load', function () {
			    var body = this.contentWindow.document.body;
			    if (body.getAttribute('data-editor'))
	            {
	                var script = document.createElement('script');
	                script.type = 'text/javascript';
	                script.async = true;
	                script.src = body.getAttribute('data-editor');
	                window.setTimeout(function () {
	                    body.appendChild(script);
	                }, 1200);
	            }
	
				var head = this.contentWindow.document.getElementsByTagName('head')[0],
					style = document.createElement('link');
				style.rel = 'stylesheet';
				style.href = 'third-party/font_awesome/4.7.0/css/font-awesome.min.css';
				head.appendChild(style);
			});
	
			$body.addClass("page-editor");
			resizeIframe.call(null);
	
			$window.on("resize", function () {
				resizeIframe.call(null);
			});
		}
	
		$(document).on('click', '.device-view', function (e) {
			e.preventDefault();
	
			var $this = $(this),
				device = $this.data('device'),
				orientation = $this.data('orientation'),
				$device = $('#iframeDevice'),
				$holder = $('#iframeHolder');
	
			$this.closest('.row').find('.device-view.active').removeClass('active').end().end().addClass('active');
	
			switch (device) {
			case 'desktop':
				$device.addClass('hidden');
				$iframe.insertBefore($device);
				$body.addClass('page-editor');
				$window.trigger('resize');
				break;
			case 'tablet':
			case 'phone':
				$iframe.appendTo($holder);
				$holder.removeClass().addClass(device + '-view-' + orientation);
				$device.removeClass('hidden');
				$body.removeClass('page-editor');
				$('#device_title').html($(['#', device, '_', orientation].join('')).html());
				$('#device_info').html($(['#', device, '_', orientation, '_info'].join('')).html());
				break;
			}
	
			return false;
		}).on('click', '[data-theme]', function (e) {
		    e.preventDefault();
		    
		    var $this = $(this);
		    
		    $.post("index.php?controller=pjAdminOptions&action=pjActionUpdateTheme", {
		    	theme: $this.data("index")
		    }).done(function (data) {
		    	if (data && data.status && data.status === "OK") {
		    		$this.closest(".dropdown-menu").find(".thumbnail").removeClass("active");
		    		$this.addClass("active");
		    	}
		    });
	
		    var $link = $(".open-new-window");
		    if ($link.length) {
		    	$link.attr("href", $link.attr("href").replace(/(&?theme=)theme\d+/, '$1' + $this.data("index")));
		    }
			$iframe.attr('src', $this.attr('href'));
			//$('.device-view.active').trigger('click');
		});
	});
})(jQuery_1_8_2);