import os
import time


fn main()
{
	for {
		mut check := os.execute("pgrep -f api").output.trim_space()
		mut current_time := "${time.now()}".replace("-", "/").replace(" ", "-")

		pids := check.split("\n")
		
		if check.trim_space().split("\n").len == 3 {
			println("\x1b[32m[ + ] ${current_time}\x1b[0m | YoMarket API application is still running....!")
		}

		if check.trim_space() == "" || check.trim_space().split("\n").len == 1 {
			println("\x1b[31m[ X ] ${current_time}\x1b[0m | YoMarket API is down!, Starting application in 3 seconds...!")
			time.sleep(3*time.second)
			os.execute("cd /root/guide; screen -dmS guide ./api").output
		}

		time.sleep(1*time.second)
	}
}