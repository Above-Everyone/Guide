.PHONY: all

all:
	sudo apt update -y
	sudo apt install screen gcc git make -y
	git clone https://github.com/vlang/v.git
	cd v
	make
	./v symlink
	cd ..
	v api.v
	v watcher.v

clean:
	sudo rm -rf v
	sudo mv api /bin/
	sudo mv watcher /bin/
