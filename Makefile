
.PHONY: build

build:
	rm -f svnfiles.tar
	tar cvf svnfiles.tar -C files .
	docker build -t svn-ldapauth .
