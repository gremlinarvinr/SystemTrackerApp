extends Node

# mainly for determining how big to scale text
# based on width
enum ViewportSizes { 
	EXTRASMALL, # phones, 600px-
	SMALL, # portrait tablets & large phones, 600px+
	MEDIUM, # landscape tablets & older laptops, 768px+
	LARGE, # laptops/desktops, 992px+
	EXTRALARGE, # large laptops/desktops, 1200px+
}
