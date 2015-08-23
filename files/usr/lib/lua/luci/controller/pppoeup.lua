module("luci.controller.pppoeup", package.seeall)

function index()
	require("luci.i18n")
	luci.i18n.loadc("pppoeup")
	if not nixio.fs.access("/etc/config/pppoeup") then
		return
	end
	
	local page = entry({"admin", "network", "pppoeup"}, cbi("pppoeup"), luci.i18n.translate("pppoeup"), 48)
	page.i18n = "pppoeup"
	page.dependent = true
	
end
