default["postgresql"]["database_name"] = "testobase"
default["postgresql"]["password"]["postgres"] = data_bag_item("postgres", "user")["password"]
