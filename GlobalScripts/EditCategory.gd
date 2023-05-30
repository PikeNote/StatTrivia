extends Node

# Template exists in category_btn
var data = {

}

var path = "";

var currentCat = -1;

func saveData():
	var file = FileAccess.open(path, FileAccess.WRITE_READ);
	file.store_string(JSON.stringify(data));
