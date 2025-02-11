extends Node

var db

func b():
	
	Database.create_database()
	db = Database.db
	
	db.open_db()
	
	Database.add_photo("res://test photos/59274989_p0.jpg")
	Database.add_photo("res://test photos/59810770_p0.jpg")
	Database.add_photo("res://test photos/62979889_p0.jpg")
	Database.add_photo("res://test photos/63964902_p0.jpg")
	Database.add_photo("res://test photos/64337772_p0.jpg")
	Database.add_photo("res://test photos/66103386_p0.jpg")
	Database.add_photo("res://test photos/68085513_p0.jpg")
	Database.add_photo("res://test photos/71315620_p0.jpg")
	

	print(Database.get_photo(1).get_size())
	
	db.close_db()
