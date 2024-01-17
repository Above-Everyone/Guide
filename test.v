import net.http
import x.json2 as jsn

fn main()
{
    id := "26295"
    mut check := http.get_text("https://api.yoworld.info/api/items/${id}")

    lines := check.split(",")

    for line in lines
    {
		mut check_ch := false
        mut line_arg := line.replace("{", "\n{\n").replace("}", "\n}\n").replace("\"", "").replace("[", "\n[\n").replace("\n]\n", "").split(":")
		for i in ['{', '}', '{', '}', ' ', '}}']
		{
			if line_arg.contains(i) { check_ch = true } 
		}

		if !check_ch { 
        println("${line_arg}") }
    }
}
