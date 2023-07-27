extends GutTest

#class TestINT:
#	extends GutTest
var SME: SmartLineEdit

func before_each():
	SME = autoqfree(SmartLineEdit.new())

#
#
#	func before_all():
#		SME.type = SmartLineEdit.Types.INT

func assert_is_ok(text: String, expected):
	var result = SME.is_ok(text)
	
	if typeof(result) != typeof(expected) or result != expected:
		var msg: String
		match result:
			true:
				msg = "OK "
			false:
				msg = "WRONG "
			_:
				msg = "CORRECTED as \"%s\" " % result
			
		match expected:
			true:
				msg += "instead of OK."
			false:
				msg += "instead of WRONG."
			_:
				msg += "instead of CORRECTED as \"%s\"." % expected
		
		fail_test(msg)
	else:
		pass_test("Good answer")

func test_int():
	SME.type = SmartLineEdit.Types.INT
	assert_is_ok("1", true)
	assert_is_ok("1 + 1", "2")
	assert_is_ok("10 / 2", "5")
	assert_is_ok("10 / 2", "5")
	assert_is_ok("abs(-1)", "1")
	assert_is_ok("a", false)
	
	SME.minimum = -5
	SME.maximum = 5
	assert_is_ok("1", true)
	assert_is_ok("1.", "1")
	assert_is_ok("1.4", "1")
	assert_is_ok(".4", "0")
	assert_is_ok("3.7", "4")
	assert_is_ok("-1", true)
	
	assert_is_ok("-6", "-5")
	assert_is_ok("6", "5")
	
	SME.minimum = -5000000
	SME.maximum = 5000000
	SME.step = 10
	assert_is_ok("20", true)
	assert_is_ok("33", "30")
	assert_is_ok("35", "40")
	assert_is_ok("37", "40")


func test_float():
	SME.type = SmartLineEdit.Types.FLOAT
	
	assert_is_ok("1 + 1", "2")
	assert_is_ok("10 / 2", "5")
	assert_is_ok("10 / 2", "5")
	assert_is_ok("abs(-1)", "1")
	assert_is_ok("a", false)
	
	SME.minimum = -5
	SME.maximum = 5
	assert_is_ok("1", true)
	assert_is_ok("1.", "1")
	assert_is_ok("1.4", true)
	assert_is_ok(".4", "0.4")
	assert_is_ok("-1", true)
	
	assert_is_ok("-6", "-5")
	assert_is_ok("6", "5")
	
	SME.minimum = -5000000
	SME.maximum = 5000000
	SME.step = 10
	assert_is_ok("20", true)
	assert_is_ok("33", "30")
	assert_is_ok("37", "40")
	
	SME.step = 0.2
	assert_is_ok("1.4", true)
	assert_is_ok("1.21", "1.2")
	assert_is_ok("1.25", "1.2")
	assert_is_ok("1.3", "1.4")
	
func test_file():
	SME.type = SmartLineEdit.Types.FILE
	assert_is_ok("res://test/unit/test_is_ok.gd", true)
	assert_is_ok("res://i_totally_dont_exist.gd", false)
	assert_is_ok("res://test/../test/unit/test_is_ok.gd", "res://test/unit/test_is_ok.gd")
	assert_is_ok("res://test/../test/unit/i_totally_dont_exist.gd", false)
	
	SME.must_exist = false
	assert_is_ok("res://test/unit/test_is_ok.gd", true)
	assert_is_ok("res://i_totally_dont_exist.gd", true)
	assert_is_ok("res://test/../test/unit/test_is_ok.gd", "res://test/unit/test_is_ok.gd")
	assert_is_ok("res://test/../test/unit/i_totally_dont_exist.gd", "res://test/unit/i_totally_dont_exist.gd")
	
	SME.file_patterns = PackedStringArray(["*.md"])
	assert_is_ok("res://README.md", true)
	assert_is_ok("res://README.txt", false)
	
	SME.file_patterns = PackedStringArray(["*.md ; Desc"])
	assert_is_ok("res://README.md", true)
	assert_is_ok("res://README.txt", false)
	
	SME.file_patterns = PackedStringArray(["*.md, *.txt ; Desc"])
	assert_is_ok("res://README.md", true)
	assert_is_ok("res://README.txt", true)
	
	SME.file_patterns = PackedStringArray(["*.md, *.txt ; Desc", "*.png ; otherdesc"])
	assert_is_ok("res://README.md", true)
	assert_is_ok("res://README.txt", true)
	assert_is_ok("res://README.png", true)
	
	SME.file_patterns = PackedStringArray(["*M?.md"])
	assert_is_ok("res://README.md", true)
	assert_is_ok("res://ME.md", true)
	assert_is_ok("res://READMEE.md", false)
	assert_is_ok("res://READM.md", false)

func test_directory():
	SME.type = SmartLineEdit.Types.DIRECTORY
	assert_is_ok("res://test/unit", true)
	assert_is_ok("res://test/unit/", "res://test/unit")
	assert_is_ok("res://i_totally_dont_exist/nor_me", false)
	assert_is_ok("res://test/../test/unit/", "res://test/unit")
	assert_is_ok("res://test/../test/i_totally_dont_exist/", false)
	
	SME.must_exist = false
	assert_is_ok("res://test/unit", true)
	assert_is_ok("res://test/unit/", "res://test/unit")
	assert_is_ok("res://i_totally_dont_exist/nor_me", true)
	assert_is_ok("res://test/../test/unit/", "res://test/unit")
	assert_is_ok("res://test/../test/i_totally_dont_exist/", "res://test/i_totally_dont_exist")
	
	
func test_regex():
	SME.type = SmartLineEdit.Types.CUSTOM
	SME.regex = "[a-y]"
	assert_is_ok("t", true)
	assert_is_ok("z", false)
