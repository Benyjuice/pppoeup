require("luci.tools.webadmin")

m = Map("pppoeup", translate("pppoeup","pppoeup"), translate("PPPOE Concurrent dial-up,please make virtaul wan use macvlan.Special thanks to Li Zhihong of two automated scripts of Change_Metric and mwan3_config."))

s = m:section(NamedSection,"settings" ,"pppoeup", translate("config","config"), translate("<p>如需帮助:<a target=\"_blank\" href=\"http://myop.ml/archives/category/firmware-guide/\">请查看使用教程</a></p>"))
s.anonymous = true
s.addremove = false


enable = s:option(Flag, "enable", translate("Enable"), translate("Enable or Disable pppoeup."))
enable.default = false
enable.optional = false
enable.rmempty = false

concurrent_dial = s:option(Flag, "concurrent_dial", translate("Concurrent-dial"),translate("Force concurrent dial-up."))
concurrent_dial.optional = false
concurrent_dial.rmempty = false

enable = s:option(Flag, "1mac", translate("Use the same mac"),translate("Use the same mac to dial--do not enable unless you know what your are doing."))
enable.default = false
enable.optional = false
enable.rmempty = false

n = s:option(Value, "n", translate("pppoe wan number"),translate("pppoe wan number."))
n:value("3", "3")
n:value("4", "4")
n:value("5", "5")
n:value("6", "6")
n:value("7", "7")
n:value("8", "8")
n:value("9", "9")
n:value("10", "10")

n.default = "4"
n.optional = true
n.rmempty = true

ok = s:option(Value, "ok", translate("Number of successful dial-up"),translate("Number of successful dial-up."))
ok:value("2", "2")
ok:value("3", "3")
ok:value("4", "4")
ok:value("5", "5")
ok:value("6", "6")
ok:value("7", "7")
ok:value("8", "8")
ok:value("9", "9")
ok:value("10", "10")

ok.default = "2"
ok.optional = true
ok.rmempty = true

sleep_time = s:option(Value, "sleep_time", translate("The number of seconds to wait before dialing"),translate("The number of seconds to wait before dialing(Seconds)."))
sleep_time:value("10", "10")
sleep_time:value("15", "15")
sleep_time:value("20", "20")
sleep_time:value("25", "25")
sleep_time:value("30", "30")
sleep_time.default = "20"
sleep_time.optional = true
sleep_time.rmempty = true

sleep_time = s:option(Value, "wait_time", translate("The number of seconds to wait after dialing"),translate("The number of seconds to wait after dialing(Seconds)."))
sleep_time:value("6", "6")
sleep_time:value("8", "8")
sleep_time:value("10", "10")
sleep_time:value("12", "12")
sleep_time:value("15", "15")
sleep_time.default = "12"
sleep_time.optional = true
sleep_time.rmempty = true

number = s:option(Value, "number", translate("Try dialing times"),translate("Try dialing times."))
number:value("1", "1")
number:value("2", "2")
number:value("3", "3")
number:value("4", "4")
number:value("5", "5")

number.default = "6"
number.optional = true
number.rmempty = true

enable = s:option(Flag, "offline_check", translate("Offline_check"),translate("Offline_check use to monitor wan(s) and redial."))
enable.default = false
enable.optional = false
enable.rmempty = false

offline_num = s:option(Value, "offline_num", translate("offline_num"),translate("If offline WAN(s) reach uppper-number,will redial."))
offline_num:value("1", "1")
offline_num:value("2", "2")
offline_num:value("3", "3")
offline_num.default = "1"
offline_num.optional = true
offline_num.rmempty = true

enable = s:option(Flag, "add_check", translate("add_check"),translate("Add_check use to monitor adding wan(s) and redial."))
enable.default = false
enable.optional = false
enable.rmempty = false

check_times = s:option(Value, "check_times", translate("check_times"),translate("Check times before starting redial."))
check_times:value("3", "3")
check_times:value("4", "4")
check_times:value("5", "5")
check_times:value("6", "6")
check_times:value("7", "7")
check_times:value("8", "8")
check_times.default = "6"
check_times.optional = true
check_times.rmempty = true

check_time = s:option(Value, "check_time", translate("check_time"),translate("The time wait for the next check."))
check_time:value("15", "15")
check_time:value("20", "20")
check_time:value("25", "25")
check_time:value("30", "30")
check_time:value("35", "35")
check_time:value("40", "40")
check_times.default = "25"
check_times.optional = true
check_times.rmempty = true

button_redial = s:option(Button, "_button", translate("Manual_Redial"), translate("Manual redial when WAN down."))
button_redial.inputtitle = translate("Manual_Redial")
button_redial.inputstyle = "apply"

function button_redial.write(self, section)
	os.execute("/lib/pppoeup/manual_dial start &")
	self.inputtitle = translate("Manual_Redial")
end


metric_begin = s:option(Value, "metric_begin", translate("metic_begin_number"),translate("The number gateway metric begin."))
metric_begin:value("10", "10")
metric_begin:value("20", "20")
metric_begin:value("40", "40")
metric_begin:value("60", "60")
metric_begin.default = "40"
metric_begin.widget = "select"
metric_begin.optional = true
metric_begin.rmempty = true

metric_switch = s:option(ListValue, "metric_switch", translate("metic_switch"),translate("Choose 1 to add or choose 0 to remove gateway metric of WAN."))
metric_switch:value("0", "0")
metric_switch:value("1", "1")
metric_switch.default = "1"
metric_switch.widget = "select"
metric_switch.optional = true
metric_switch.rmempty = true

button_metric = s:option(Button, "_metric", translate("Change_Metric"), translate("Change Gateway Metric of wans."))
button_metric.inputtitle = translate("Change_Metric")
button_metric.inputstyle = "apply"

function button_metric.write(self, section)
	os.execute("/lib/pppoeup/metric start &")
	self.inputtitle = translate("Change_Metric")
end


mwan3_number = s:option(Value, "mwan3_number", translate("mwan3_number"),translate("The numbermwan3_number enalbed,1 means 1 wan and is disabled,n(>1) means add n wan and enabled."))
mwan3_number:value("1", "1")
mwan3_number:value("2", "2")
mwan3_number:value("3", "3")
mwan3_number:value("4", "4")
mwan3_number:value("5", "5")
mwan3_number:value("6", "6")
mwan3_number:value("7", "7")
mwan3_number:value("8", "8")
mwan3_number:value("9", "9")
mwan3_number:value("10", "10")
mwan3_number.default = "5"
mwan3_number.widget = "select"
mwan3_number.optional = true
mwan3_number.rmempty = true

mwan3_config = s:option(Button, "_mwan3_config", translate("Config Mwan3"), translate("Config Mwan3 automatically."))
mwan3_config.inputtitle = translate("Config Mwan3")
mwan3_config.inputstyle = "apply"

function mwan3_config.write(self, section)
	os.execute("/lib/pppoeup/mwan3config.sh start &")
	self.inputtitle = translate("Config Mwan3")
end

return m

