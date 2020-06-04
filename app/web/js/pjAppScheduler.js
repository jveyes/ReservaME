/*!
 * Appointment Scheduler v2.2
 * https://phpjabbers.com/appointment-scheduler/
 * 
 * Copyright 2014-2015, StivaSoft Ltd.
 * 
 * Date: Mon April 27 10:39:28 2015 +0200
 */
(function (window, undefined){
	"use strict";
	
	pjQ.$.ajaxSetup({
		xhrFields: {
			withCredentials: true
		}
	});
	
	var document = window.document,
		validate = (pjQ.$.fn.validate !== undefined),
		datepicker = (pjQ.$.fn.datepicker !== undefined),
		dialog = (pjQ.$.fn.dialog !== undefined),
		spinner = (pjQ.$.fn.spinner !== undefined),
		$dialogTerms,
		routes = [
		          
		          {pattern: /^#!\/Service\/((?:19|20)\d\d)\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])\/.*-(\d+)\/.*-(\d+)\.html$/, eventName: "loadService"},
		          {pattern: /^#!\/Service\/((?:19|20)\d\d)\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])\/.*-(\d+)\.html$/, eventName: "loadService"},
		          
		          {pattern: /^#!\/Service\/date:([\d\-\.\/]+)\/service_id:(\d+)\/employee_id:(\d+)$/, eventName: "loadService"},
		          {pattern: /^#!\/Service\/date:([\d\-\.\/]+)\/service_id:(\d+)$/, eventName: "loadService"},
		          
		          {pattern: /^#!\/Services$/, eventName: "loadServices"},
		          {pattern: /^#!\/Services\/date:([\d\-\.\/]+)?\/page:(\d+)?$/, eventName: "loadServices"},
		          {pattern: /^#!\/Services\/((?:19|20)\d\d)\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])\/(\d+)?$/, eventName: "loadServices"},
		          
		          
		          {pattern: /^#!\/Employee\/((?:19|20)\d\d)\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])\/.*-(\d+)\/.*-(\d+)\.html$/, eventName: "loadEmployee"},
		          {pattern: /^#!\/Employee\/((?:19|20)\d\d)\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])\/.*-(\d+)\.html$/, eventName: "loadEmployee"},
		          
		          {pattern: /^#!\/Employee\/date:([\d\-\.\/]+)\/employee_id:(\d+)\/service_id:(\d+)$/, eventName: "loadEmployee"},
		          {pattern: /^#!\/Employee\/date:([\d\-\.\/]+)\/employee_id:(\d+)$/, eventName: "loadEmployee"},
		          		          
		          {pattern: /^#!\/Employees$/, eventName: "loadEmployees"},
		          {pattern: /^#!\/Employees\/date:([\d\-\.\/]+)?\/page:(\d+)?$/, eventName: "loadEmployees"},
		          {pattern: /^#!\/Employees\/((?:19|20)\d\d)\/(0[1-9]|1[012])\/(0[1-9]|[12][0-9]|3[01])\/(\d+)?$/, eventName: "loadEmployees"},
		         
		          {pattern: /^#!\/Checkout$/, eventName: "loadCheckout"},
		          {pattern: /^#!\/Preview$/, eventName: "loadPreview"},
		          {pattern: /^#!\/Booking\/([A-Z]{2}\d{10})$/, eventName: "loadBooking"},
		          {pattern: /^#!\/Cart$/, eventName: "loadCart"}
		];
	
	function log() {
		if (window.console && window.console.log) {
			for (var x in arguments) {
				if (arguments.hasOwnProperty(x)) {
					window.console.log(arguments[x]);
				}
			}
		}
	}
	
	function assert() {
		if (window && window.console && window.console.assert) {
			window.console.assert.apply(window.console, arguments);
		}
	}
	
	function hashBang(value) {
		if (value !== undefined && value.match(/^#!\//) !== null) {
			if (window.location.hash == value) {
				return false;
			}
			window.location.hash = value;
			return true;
		}
		
		return false;
	}
	
	function onHashChange() {
		var i, iCnt, m;
		for (i = 0, iCnt = routes.length; i < iCnt; i++) {
			m = unescape(window.location.hash).match(routes[i].pattern);
			if (m !== null) {
				pjQ.$(window).trigger(routes[i].eventName, m.slice(1));
				break;
			}
		}
		if (m === null) {
			pjQ.$(window).trigger("loadServices");
		}
	}
	function res() {
		var _td = pjQ.$(".pjIcCalendarTable td");
		var td_width = _td.width();
		_td.height(td_width);
    }
	pjQ.$(window).on("hashchange", function (e) {
    	onHashChange.call(null);
    });
	
	function AppScheduler(options) {
		if (!(this instanceof AppScheduler)) {
			return new AppScheduler(options);
		}
				
		this.reset.call(this);
		this.date = options.firstDate;
		this.init.call(this, options);
		
		return this;
	}
	
	AppScheduler.prototype = {
		reset: function () {
			this.$container = null;
			this.container = null;
			this.$responsive = null;
			this.view = null;
			this.page = 1;
			this.date = null;
			this.start_ts = null;
			this.end_ts = null;
			this.service_id = null;
			this.employee_id = null;
			this.booking_uuid = null;
			this.layout = 2;
			this.scroll = false;
			this.hash_arr = new Array();
			this.options = {};
			
			return this;
		},
		disableButtons: function () {
			this.$container.find(".btn").addClass('pjAsBtnDisabled').attr("disabled", "disabled");
		},
		enableButtons: function () {
			this.$container.find(".btn").removeClass('pjAsBtnDisabled').removeAttr("disabled");
		},
		_addToCart: function (arr) {
			var xhr = pjQ.$.post([this.options.folder, "index.php?controller=pjFrontEnd&action=pjActionAddToCart&cid=", this.options.cid, "&session_id=", this.options.session_id].join(""), pjQ.$.param(arr));
			
			return xhr;
		},
		_removeFromCart: function (opts) {
			var xhr = pjQ.$.post([this.options.folder, "index.php?controller=pjFrontEnd&action=pjActionRemoveFromCart&cid=", this.options.cid, "&session_id=", this.options.session_id].join(""), {
				"date": opts.date,
				"service_id": opts.service_id,
				"start_ts": opts.start_ts,
				"end_ts": opts.end_ts,
				"employee_id": opts.employee_id
			});
			
			return xhr;
		},
		addToCart: function (arr) {
			var that = this;
			this.disableButtons.call(this);
			this._addToCart.call(this, arr).done(function (data) {
				
				var result = pjQ.$.grep(arr, function (item) {
					return item.name == 'employee_id';
				});
				hashBang("#!/Checkout");
			}).fail(function () {
				that.enableButtons.call(that);
			});
			
			return this;
		},
		removeFromCart: function (opts) {
			var that = this;
			this.disableButtons.call(this);
			this._removeFromCart.call(this, opts).done(function (data) {
				if(data.status == 'OK')
				{
					if(data.cnt == '0')
					{
						hashBang("#!/Services");
					}else{
						pjQ.$(window).trigger("loadCheckout");
					}
				}
				
			}).fail(function () {
				that.enableButtons.call(that);
			});
			
			return this;
		},
		getCart: function () {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontEnd&action=pjActionGetCart"].join(""), {
				"cid": this.options.cid,
				"layout": that.layout,
				"theme": this.options.theme,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.find(".asSelectorCartWrap").html(data);
			});
		},
		getCalendar: function (year, month) {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontEnd&action=pjActionGetCalendar"].join(""), {
				"cid": this.options.cid,
				"layout": that.layout,
				"theme": this.options.theme,
				"date": that.date,
				"year": year,
				"month": month,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.find(".pjAsCalendarInline").html(data);
			});
		},
		getEmployees: function () {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontEnd&action=pjActionGetEmployees"].join(""), {
				"cid": this.options.cid,
				"layout": that.layout,
				"theme": this.options.theme,
				"date": this.date,
				"service_id": this.service_id,
				"start_ts": this.start_ts,
				"end_ts": this.end_ts,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.find(".asSelectorSingleEmployee").html(data).show();
			});
		},
		getTime: function () {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontEnd&action=pjActionGetTime"].join(""), {
				"cid": this.options.cid,
				"layout": that.layout,
				"theme": this.options.theme,
				"service_id": this.service_id,
				"date": this.date,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.find(".asSelectorSingleTimeBox").html(data)
					.end()
					.find(".asSelectorSingleTime").trigger("change");
			});
		},
		init: function (opts) {
			var that = this;
			this.options = opts;
			
			this.container = document.getElementById("asContainer_" + this.options.cid);
			this.$container = pjQ.$(this.container);
			
			this.layout = this.options.layout;
			
			this.$container.on("click.as", ".asSelectorLocale", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this),
					locale = pjQ.$(this).data("id");
				that.options.locale = locale;
				pjQ.$(this).addClass("asLocaleFocus").parent().parent().find("a.asSelectorLocale").not(this).removeClass("asLocaleFocus");
				
				pjQ.$.get([that.options.folder, "index.php?controller=pjFront&action=pjActionLocale", "&session_id=", that.options.session_id].join(""), {
					"locale_id": locale
				}).done(function (data) {
					that.layout = $this.attr('data-layout');
					if(that.layout == '1')
					{
						if (!hashBang("#!/Employees"))
						{
							that.loadEmployees.call(that);
						}
					}else if(that.layout == '2'){
						if (!hashBang("#!/Services"))
						{
							that.loadServices.call(that);
						}
					}
					if (!hashBang("#!/Services")) {
						pjQ.$(window).trigger("loadServices");
					}
				}).fail(function () {
					log("Deferred is rejected");
				});
				return false;
			}).on("click.as", ".asSlotBlock", function (e) {	
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this),
					$holder = $this.closest(".asEmployeeInfo");
				if($this.hasClass('asSlotAvailable'))
				{
					if ($this.parent().hasClass("pjAsTimeSelected")) 
					{
						$this.parent().removeClass("pjAsTimeSelected");
						$holder.find(":submit").attr("disabled", "disabled")
							.end().find(".asEmployeeTime").hide()
							.end().find(".asEmployeeTimeValue").html("")
							.end().find("input[name='start_ts']").val("")
							.end().find("input[name='end_ts']").val("");
					} else {
						$holder.find('.pjAsTimeSelected').removeClass("pjAsTimeSelected");
						$this.parent().addClass("pjAsTimeSelected");
						$holder.find(":submit").removeAttr("disabled")
							.end().find(".asEmployeeTimeValue").eq(0).html($this.text())
							.end()
							.end().find(".asEmployeeTimeValue").eq(1).html($this.data("end"))
							.end()
							.end().find(".asEmployeeTime").show()
							.end().find("input[name='start_ts']").val($this.data("start_ts"))
							.end().find("input[name='end_ts']").val($this.data("end_ts"));
					}
				}
								
			}).on("submit.as", ".pjAsAddToCartForm", function (e) {
				
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				that.disableButtons.call(that);
				var arr = pjQ.$(this).serializeArray();
				that._addToCart.call(that, arr).done(function (data) {
					that.enableButtons.call(that);
					if(that.layout == '2')
					{
						that.loadService.call(that);
					}else if(that.layout == '1'){
						that.loadEmployee.call(that);
					}
				}).fail(function () {
					that.enableButtons.call(that);
				});
				
				return false;
				
			}).on("submit.as", ".pjAsAppointmentForm", function (e) {
				
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				that.addToCart.call(that, pjQ.$(this).serializeArray());
				return false;
				
			}).on("click.as", ".pjAsBtnRemoveFromCart", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this);
				that.disableButtons.call(that);
				that._removeFromCart.call(that, $this.data()).done(function (data) {
					that.enableButtons.call(that);
					if(that.layout == '2')
					{
						that.loadService.call(that);
					}else if(that.layout == '1'){
						that.loadEmployee.call(that);
					}
				}).fail(function () {
					that.enableButtons.call(that);
				});
				return false;
			}).on("click.as", ".pjAsBtnGotoCheckout", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				hashBang("#!/Checkout");
				return false;
			}).on("click.as", ".asSelectorRemoveFromCart", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this);
				that.removeFromCart.call(that, $this.data());
				return false;
			}).on("click.as", ".asSelectorCheckout", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				hashBang("#!/Checkout");
				return false;
			}).on("click.as", ".asSelectorPreview", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				hashBang("#!/Preview");
				return false;
			}).on("change.as", "select[name='payment_method']", function () {
				that.$container.find(".asSelectorCCard").hide();
				that.$container.find(".asSelectorBank").hide();
				switch (pjQ.$(this).find("option:selected").val()) {
				case 'creditcard':
					that.$container.find(".asSelectorCCard").show();
					break;
				case 'bank':
					that.$container.find(".asSelectorBank").show();
					break;
				}
			}).on("change.as", ".pjAsFilterServices", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var service_id = pjQ.$(this).val();
				that.disableButtons.call(that);
				pjQ.$.get([that.options.folder, "index.php?controller=pjFrontEnd&action=pjActionGetEmployees"].join(""), {
					"cid": that.options.cid,
					"layout": that.layout,
					"theme": that.options.theme,
					"service_id": service_id,
					"session_id": this.options.session_id
				}).done(function (data) {
					pjQ.$('.pjAsListElements').html(data);
					that.enableButtons.call(that);
				});
				return false;
			}).on("click.as", ".pjAsBackToService", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this),
					service_id = $this.data("sid"),
					employee_id = $this.data("eid"),
					slug = $this.data("slug"),
					iso = $this.data("iso"),
					d = null;
				that.disableButtons.call(that);
				if (that.options.seoUrl === 1 && slug.length > 0) {
					hashBang(["#!", slug].join("/"));
				} else {
					hashBang(["#!/Service/date:", encodeURIComponent(iso), "/service_id:", encodeURIComponent(service_id), "/employee_id:", encodeURIComponent(employee_id)].join(""));
				}
				return false;
			}).on("click.as", ".pjAsBackToEmployee", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this),
					service_id = $this.data("sid"),
					employee_id = $this.data("eid"),
					slug = $this.data("slug"),
					iso = $this.data("iso"),
					d = null;
				that.disableButtons.call(that);
				if (that.options.seoUrl === 1 && slug.length > 0) {
					hashBang(["#!", slug].join("/"));
				} else {
					hashBang(["#!/Employee/date:", encodeURIComponent(iso), "/employee_id:", encodeURIComponent(employee_id), "/service_id:", encodeURIComponent(service_id)].join(""));
				}
				return false;
			}).on("click.as", ".pjAsServiceAppointment", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this),
					service_id = $this.data("id"),
					iso = $this.data("iso"),
					slug = $this.data("slug");
				that.employee_id = null;
				if (that.options.seoUrl === 1 && slug.length > 0) {
					hashBang("#!/" + slug);
				} else {
					hashBang("#!/Service/date:" + encodeURIComponent(iso) + "/service_id:" + encodeURIComponent(service_id));
				}
				return false;
			}).on("click.as", ".pjAsEmployeeAppointment", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this),
					service_id = $this.data("sid"),
					employee_id = $this.data("eid"),
					slug = $this.data("slug"),
					iso = $this.data("iso"),
					d = null;
				that.service_id = null;
				that.scroll = true;
				that.disableButtons.call(that);
				if (that.options.seoUrl === 1 && slug.length > 0) {
					hashBang("#!/" + slug);
				} else {
					hashBang(["#!/Employee/date:", encodeURIComponent(iso), "/employee_id:", encodeURIComponent(employee_id)].join(""));
				}
				return false;
			}).on("click.as", ".pjAsCalendarDate", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				
				var d, iso = pjQ.$(this).data("iso");
				
				var param = 'Services';
				that.scroll = true;
				if(that.layout == '1')
				{
					param = 'Employees';
				}
				if (that.options.seoUrl === 1) {
					d = iso.split("-");
					if(that.hash_arr.hasOwnProperty(iso))
					{
						hashBang(that.hash_arr[iso]);
					}else{
						hashBang(["#!", param, d[0], d[1], d[2], 1].join("/"));
					}
					
				} else {
					if(that.hash_arr.hasOwnProperty(iso))
					{
						hashBang(that.hash_arr[iso]);
					}else{
						hashBang(["#!/"+param+"/date:", encodeURIComponent(iso), "/page:1"].join(""));	
					}
				}
				
				return false;
			}).on("click.as", ".pjAsCalendarLinkMonth", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $this = pjQ.$(this);
				that.getCalendar.call(that, $this.data("year"), $this.data("month"));
				return false;
			}).on("click.as", ".pjAsBtnBackToServices", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				if(that.options.tab == 'professional')
				{
					hashBang("#!/Employees");
				}else{
					hashBang("#!/Services");
				}
				return false;
			}).on("click.as", ".pjAsBtnBackToEmployees", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				hashBang("#!/Employees");
				return false;
			}).on("click.as", ".pjAsDatePickIcon", function (e) {
				var $dp = pjQ.$(this).siblings("input[type='text']");
				if ($dp.hasClass("hasDatepicker")) {
					$dp.datepicker("show");
				} else {
					if(!$dp.is('[disabled=disabled]'))
					{
						$dp.trigger("focusin").datepicker("show");
					}
				}
			}).on("change.as", ".pjAsSelectorEmployee", function (e) {
				var employee_id = pjQ.$(this).val(),
					$this = pjQ.$(this);
				
				var $this = pjQ.$(this),
					service_id = pjQ.$(this).attr('data-service_id'),
					employee_id = pjQ.$('option:selected', this).attr('data-eid'),
					slug = pjQ.$('option:selected', this).attr('data-slug'),
					iso = pjQ.$(this).attr('data-iso'),
					d = null;
				that.disableButtons.call(that);
				if($this.val() == '')
				{
					that.employee_id = null;
					if (that.options.seoUrl === 1 && slug.length > 0) {
						hashBang("#!/" + slug);
						that.hash_arr[iso] = "#!/" + slug;
					} else {
						hashBang("#!/Service/service_id:" + encodeURIComponent(service_id));
						that.hash_arr[iso] = "#!/Service/service_id:" + encodeURIComponent(service_id);
					}
				}else{
					if (that.options.seoUrl === 1 && slug.length > 0) {
						hashBang("#!/" + slug);
						that.hash_arr[iso] = "#!/" + slug;
					} else {
						hashBang(["#!/Service/date:", encodeURIComponent(iso), "/service_id:", encodeURIComponent(service_id), "/employee_id:", encodeURIComponent(employee_id)].join(""));
						that.hash_arr[iso] = ["#!/Service/date:", encodeURIComponent(iso), "/service_id:", encodeURIComponent(service_id), "/employee_id:", encodeURIComponent(employee_id)].join("");
					}
				}
				return false;
			}).on("click.as", ".pjAsBtnCart", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var cnt = pjQ.$(this).attr('data-cnt');
				if(cnt != '0')
				{
					hashBang("#!/Checkout");
				}
				return false;
			}).on("click.as", ".pjAsBtnBackToCheckout", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				hashBang("#!/Checkout");
				return false;
			}).on("change.as", ".pjAsSelectorService", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var service_id = pjQ.$(this).val(),
					$this = pjQ.$(this);
				
				var $this = pjQ.$(this),
					employee_id = pjQ.$(this).attr('data-employee_id'),
					service_id = pjQ.$('option:selected', this).attr('data-sid'),
					slug = pjQ.$('option:selected', this).attr('data-slug'),
					iso = pjQ.$(this).attr('data-iso'),
					d = null;
				that.disableButtons.call(that);
				if($this.val() == '')
				{
					that.service_id = null;
					if (that.options.seoUrl === 1 && slug.length > 0) {
						hashBang("#!/" + slug);
						that.hash_arr[iso] = "#!/" + slug;
					} else {
						hashBang("#!/Employee/employee_id:" + encodeURIComponent(employee_id));
						that.hash_arr[iso] = "#!/Employee/employee_id:" + encodeURIComponent(employee_id);
					}
				}else{
					if (that.options.seoUrl === 1 && slug.length > 0) {
						hashBang("#!/" + slug);
						that.hash_arr[iso] = "#!/" + slug;
					} else {
						hashBang(["#!/Employee/date:", encodeURIComponent(iso), "/employee_id:", encodeURIComponent(employee_id), "/service_id:", encodeURIComponent(service_id)].join(""));
						that.hash_arr[iso] = ["#!/Employee/date:", encodeURIComponent(iso), "/employee_id:", encodeURIComponent(employee_id), "/service_id:", encodeURIComponent(service_id)].join("");
					}
				}
				return false;
			}).on("click.as", ".pjAsSwitchLayout", function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				if(!pjQ.$(this).parent().hasClass('active'))
				{
					that.layout = pjQ.$(this).attr('data-layout');
					if(that.layout == '1')
					{
						if (!hashBang("#!/Employees"))
						{
							that.loadEmployees.call(that);
						}
					}else if(that.layout == '2'){
						if (!hashBang("#!/Services"))
						{
							that.loadServices.call(that);
						}
					}
				}
				return false;
			}).on("click.as", "#pjAsCaptchaImage_" + that.options.cid, function (e) {
				if (e && e.preventDefault) {
					e.preventDefault();
				}
				var $captcha = pjQ.$(this);
				$captcha.attr("src", $captcha.attr("src").replace(/(&rand=)\d+/g, '\$1' + Math.ceil(Math.random() * 99999)));
				pjQ.$("#pjAsCaptchaField_" + that.options.cid).val("").removeData('previousValue');
				return false;
			});
			
			//Custom events
			pjQ.$(window).on("loadServices", this.container, function (e) {
				that.layout = 2;
				switch (arguments.length) {
					case 3:
						that.date = arguments[1];
						that.page = arguments[2];
						break;
					case 5:
						that.date = [arguments[1], arguments[2], arguments[3]].join("-");
						that.page = arguments[4];
						break;
				}
				that.loadServices.call(that);
			}).on("loadService", this.container, function (e) {
				that.layout = 2;
				switch (arguments.length) {
					case 3:
						that.date = arguments[1];
						that.service_id = arguments[2];
						break;
					case 4:
						that.date = arguments[1];
						that.service_id = arguments[2];
						that.employee_id = arguments[3];
						break;
					case 5:
						that.date = [arguments[1], arguments[2], arguments[3]].join("-");
						that.service_id = arguments[4];
						break;
					case 6:
						that.date = [arguments[1], arguments[2], arguments[3]].join("-");
						that.service_id = arguments[4];
						that.employee_id = arguments[5];
						break;
				}
				that.loadService.call(that);
			}).on("loadEmployees", this.container, function (e) {
				that.layout = 1;
				switch (arguments.length) {
					case 3:
						that.date = arguments[1];
						that.page = arguments[2];
						break;
					case 5:
						that.date = [arguments[1], arguments[2], arguments[3]].join("-");
						that.page = arguments[4];
						break;
				}
				that.loadEmployees.call(that);
			}).on("loadEmployee", this.container, function (e) {
				that.layout = 1;				
				switch (arguments.length) {
					case 3:
						that.date = arguments[1];
						that.employee_id = arguments[2];
						break;
					case 4:
						that.date = arguments[1];
						that.employee_id = arguments[2];
						that.service_id = arguments[3];
						break;
					case 5:
						that.date = [arguments[1], arguments[2], arguments[3]].join("-");
						that.employee_id = arguments[4];
						that.service_id = arguments[5];
						break;
					case 6:
						that.date = [arguments[1], arguments[2], arguments[3]].join("-");
						that.employee_id = arguments[4];
						that.service_id = arguments[5];
						break;
				}
				that.loadEmployee.call(that);
			}).on("loadCheckout", this.container, function (e) {
				that.loadCheckout.call(that);
			}).on("loadPreview", this.container, function (e) {
				that.loadPreview.call(that);
			}).on("loadBooking", this.container, function (e, booking_uuid) {
				that.booking_uuid = booking_uuid;
				that.loadBooking.call(that);
			});
			
			if (window.location.hash.length === 0) {
				if(that.options.tab == 'both' || that.options.tab == 'service')
				{
					that.layout = 2;
					pjQ.$(window).trigger("loadServices");
				}else{
					that.layout = 1;
					pjQ.$(window).trigger("loadEmployees");
				}
			} else {
				onHashChange.call(null);
			}
			
			return this;
		},
		loadCheckout: function () {
			var that = this;
			this.disableButtons.call(this);
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionCheckout"].join(""), {
				"cid": this.options.cid,
				"locale": this.options.locale,
				"hide": this.options.hide,
				"layout": that.layout,
				"theme": this.options.theme,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.html(data);
				pjQ.$('.modal-dialog').css("z-index", "9999"); 
				
				var $reCaptcha = that.$container.find('#g-recaptcha_' + that.options.cid);
				if ($reCaptcha.length > 0)
	            {
	                grecaptcha.render($reCaptcha.attr('id'), {
	                    sitekey: $reCaptcha.data('sitekey'),
	                    callback: function(response) {
	                        var elem = pjQ.$("input[name='recaptcha']");
	                        elem.val(response);
	                        elem.valid();
	                    }
	                });
	            }
				
				if (validate) {
					that.$container.find(".asSelectorCheckoutForm").validate({
						rules: {
							"captcha" : {
								remote: that.options.folder + "index.php?controller=pjFrontEnd&action=pjActionCheckCaptcha&session_id=" + that.options.session_id,
								required: true
							},
							"recaptcha": {
		                        remote: that.options.folder + "index.php?controller=pjFrontEnd&action=pjActionCheckReCaptcha&session_id=" + that.options.session_id,
		                        required: true
		                    },
						},
						ignore: ".ignore",
						onkeyup: false,
						errorElement: 'li',
						errorPlacement: function (error, element) {
							if(element.attr('name') == 'captcha' || element.attr('name') == 'terms')
							{
								element.parent().parent().parent().parent().addClass('has-error');
								error.appendTo(element.parent().parent().next().find('ul'));
							}else{
								element.parent().parent().addClass('has-error');
								error.appendTo(element.next().find('ul'));
							}
						},
						highlight: function(ele, errorClass, validClass) {
			            	var element = pjQ.$(ele);
			            	if(element.attr('name') == 'captcha' || element.attr('name') == 'terms')
							{
								element.parent().parent().parent().parent().addClass('has-error');
							}else{
								element.parent().parent().addClass('has-error');
							}
			            },
			            unhighlight: function(ele, errorClass, validClass) {
			            	var element = pjQ.$(ele);
			            	if(element.attr('name') == 'captcha' || element.attr('name') == 'terms')
							{
								element.parent().parent().parent().parent().removeClass('has-error').addClass('has-success');
							}else{
								element.parent().parent().removeClass('has-error').addClass('has-success');
							}
			            },
						submitHandler: function (form) {
							that.disableButtons.call(that);
							var $form = pjQ.$(form);
							pjQ.$.post([that.options.folder, "index.php?controller=pjFrontPublic&action=pjActionCheckout", "&session_id=", that.options.session_id].join(""), $form.serialize()).done(function (data) {
								if (data.status == "OK") {
									hashBang("#!/Preview");
								} else if (data.status == "ERR") {
									that.enableButtons.call(that);
								}
							}).fail(function () {
								that.enableButtons.call(that);
							});
							return false;
						}
					});
				}
				pjQ.$('html, body').animate({
			        scrollTop: that.$container.offset().top
			    }, 500);
			}).fail(function () {
				that.enableButtons.call(that);
			});
		},
		loadService: function (employee_id) {
			var that = this,
				obj = {
					"cid": this.options.cid,
					"locale": this.options.locale,
					"hide": this.options.hide,
					"layout": that.layout,
					"service_id": this.service_id,
					"date": this.date,
					"theme": this.options.theme,
					"session_id": this.options.session_id
				};
			
			if (that.employee_id != null) {
				obj = pjQ.$.extend(obj, {
					"employee_id": that.employee_id
				});
			}

			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionService"].join(""), obj).done(function (data) {
				that.$container.html(data);
				pjQ.$(window).resize(res).trigger("resize");
			});
		},
		loadServices: function () {
			var that = this;
			this.disableButtons.call(this);
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionServices"].join(""), {
				"cid": this.options.cid,
				"locale": this.options.locale,
				"hide": this.options.hide,
				"layout": that.layout,
				"date": this.date,
				"theme": this.options.theme,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.html(data);
				if(that.scroll == true)
				{
					pjQ.$('html, body').animate({
				        scrollTop: pjQ.$("#pjAsServicesWrapper").offset().top
				    }, 500);
					that.scroll = false;
				}
				pjQ.$(window).resize(res).trigger("resize");
			}).fail(function () {
				this.enableButtons.call(this);
			});
		},
		loadEmployee: function (service_id) {
			var that = this,
				obj = {
					"cid": this.options.cid,
					"locale": this.options.locale,
					"hide": this.options.hide,
					"layout": that.layout,
					"employee_id": this.employee_id,
					"date": this.date,
					"theme": this.options.theme,
					"session_id": this.options.session_id
				};
			
			if (that.service_id != null) {
				obj = pjQ.$.extend(obj, {
					"service_id": that.service_id
				});
			}

			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionEmployee"].join(""), obj).done(function (data) {
				that.$container.html(data);
				pjQ.$(window).resize(res).trigger("resize");
				if(that.scroll == true)
				{
					pjQ.$('html, body').animate({
				        scrollTop: pjQ.$("#pjAsEmployeeWrapper_" + that.employee_id).offset().top
				    }, 500);
					that.scroll = false;
				}
			});
		},
		loadEmployees: function () {
			var that = this;
			this.disableButtons.call(this);
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionServices"].join(""), {
				"cid": this.options.cid,
				"locale": this.options.locale,
				"hide": this.options.hide,
				"layout": that.layout,
				"date": this.date,
				"theme": this.options.theme,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.html(data);
				if(that.scroll == true)
				{
					pjQ.$('html, body').animate({
				        scrollTop: pjQ.$("#pjAsEmployeesWrapper").offset().top
				    }, 500);
					that.scroll = false;
				}
				pjQ.$(window).resize(res).trigger("resize");
			}).fail(function () {
				this.enableButtons.call(this);
			});
		},
		loadPreview: function () {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionPreview"].join(""), {
				"cid": this.options.cid,
				"locale": this.options.locale,
				"hide": this.options.hide,
				"layout": that.layout,
				"theme": this.options.theme,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.html(data);
				that.view = 'pjActionPreview';
				
				if (validate) {
					that.$container.find(".asSelectorPreviewForm").validate({
						rules: {
							as_validate: {
								remote: [that.options.folder, "index.php?controller=pjFrontEnd&action=pjActionValidateCart", "&session_id=", that.options.session_id].join("")
							}
						},
						messages: {
							as_validate: {
								remote: that.options.fields.v_remote
							}
						},
						onkeyup: false,
						onclick: false,
						onfocusout: false,
						ignore: ".asIgnore",
						errorClass: "asError",
						validClass: "asValid",
						wrapper: "em",
						errorPlacement: function (error, element) {
							error.insertAfter(element.parent());
						},
						submitHandler: function (form) {
							that.disableButtons.call(that);
							var $form = pjQ.$(form);
							pjQ.$.post([that.options.folder, "index.php?controller=pjFrontEnd&action=pjActionProcessOrder", "&session_id=", that.options.session_id].join(""), $form.serialize()).done(function (data) {
								if (data.status == "OK") {
									hashBang("#!/Booking/" + data.booking_uuid);
								} else if (data.status == "ERR") {
									that.enableButtons.call(that);
									$form.find(".asSelectorError").html(data.text).show();
								}
							}).fail(function () {
								that.enableButtons.call(that);
							});
							return false;
						}
					});
				}
				pjQ.$('html, body').animate({
			        scrollTop: that.$container.offset().top
			    }, 500);
			});
		},
		loadBooking: function () {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionBooking"].join(""), {
				"cid": this.options.cid,
				"locale": this.options.locale,
				"hide": this.options.hide,
				"layout": that.layout,
				"theme": this.options.theme,
				"booking_uuid": this.booking_uuid,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.html(data);
				pjQ.$('html, body').animate({
			        scrollTop: that.$container.offset().top
			    }, 500);
				that.view = 'pjActionBooking';
				
				var $payment_form = that.$container.find("form[name='pjOnlinePaymentForm']").first();
				if ($payment_form.length > 0) {
					$payment_form.trigger('submit');
				}
			});
		},
		loadCart: function () {
			var that = this;
			pjQ.$.get([this.options.folder, "index.php?controller=pjFrontPublic&action=pjActionCart"].join(""), {
				"cid": this.options.cid,
				"locale": this.options.locale,
				"hide": this.options.hide,
				"layout": that.layout,
				"theme": this.options.theme,
				"session_id": this.options.session_id
			}).done(function (data) {
				that.$container.html(data);
				that.view = 'pjActionCart';
			});
		}
	};
	
	// expose
	window.AppScheduler = AppScheduler;	
})(window);