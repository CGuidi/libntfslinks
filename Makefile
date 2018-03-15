all : buildJunction buildChar

buildJunction : libntfslinks/source/Junction.cpp	
	gcc -D"LIBNTFS_EXPORTS" -D"UNICODE" -I"libntfslinks/include" -c libntfslinks/source/Junction.cpp -o Junction.o	

buildChar : libntfslinks/source/CharUtils.cpp	
	gcc -D"LIBNTFS_EXPORTS" -D"UNICODE" -I"libntfslinks/include" -c libntfslinks/source/CharUtils.cpp -o CharUtils.o	
