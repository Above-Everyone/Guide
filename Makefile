.PHONY: dependencies build clean

dependencies:
	sudo apt update -y
	sudo apt install screen gcc git make -y; cd
	git clone https://github.com/vlang/v.git
	cd v
	make
	./v symlink

build:
	cd; git clone https://github.com/Above-Everyone/YoMarket
	cd YoMarket
	v api.v -prod -o yomarket 
	v watcher.v -prod -o watcher

clean:
	sudo rm -rf /root/v
	sudo mv /root/YoMarket/api /bin/
	sudo mv /root/YoMarket/watcher /bin/
