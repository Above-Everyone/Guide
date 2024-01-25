<?php
ini_set('display_errors', 0);
ini_set('display_startup_errors', 0);
// error_reporting(E_ALL);
class Item 
{
	/*
		General Item Information
	*/
	public $name;
	public $id;
	public $url;
	public $price;
	public $update;

	/*
		Actions you h the ITEM
	*/
	public $is_tradable;
	public $is_giftable;

	/*
		In-store Inf
	*/
	public $in_store;
	public $store_price;
	public $gender;
	public $xp;
	public $category;

	/*
		Extra Info
	*/
	public $ywinfo_prices;

    function __construct(array $arr)
    {
        if(count($arr) > 5) {
            $this->name = $arr[0];
            $this->id = $arr[1]; 
            $this->url = $arr[2];
            $this->price = $arr[3]; 
            $this->update = $arr[4];
            $this->is_tradable = $arr[5]; $this->is_giftable = $arr[6]; $this->in_store = $arr[7];
            $this->store_price = $arr[8]; $this->gender = trim($arr[9]); $this->xp = trim($arr[10]);
            $this->category = trim($arr[11]);
        }
    }

    public function parse_prices(string $content) 
    {
        $this->yw_db_price = array();
        $lines = explode("\n", $content);

        foreach($lines as $line) 
        {
            if(strlen($line) > 3)
                array_push($this->yw_db_price, $line);
        }
    }
}

class price_log
{
    public $app_t;
    public $addy;
    public $query;
    public $old_price;
    public $new_price;
    public $timestamp;
    
    function __construct(array $arr)
    {
        if(count($arr) != 6)
            return;

        $this->app_t = $arr[0]; $this->addy = $arr[1];
        $this->query = $arr[2]; $this->old_price = $arr[3];
        $this->new_price = $arr[4]; $this->timestamp = $arr[5];
    }

}

class Response 
{
    public $type;
    public $result;
    function __construct(ResponseType $t, array | Item | int | string $r)
    {
        $this->type = $t;
        $this->result = $r;
    }
}

enum ResponseType
{
    case NONE;
    case EXACT;
    case EXTRA;
    case ITEM_UPDATED;
    case FAILED_TO_UPDATE;
    case API_FAILURE;
    case REQ_SUCCESS;

    public static function r2str(ResponseType $r): string 
    {
        switch($r)
        {
            case ResponseType::NONE:
                return "ResponseType::NONE";

            case ResponseType::EXACT:
                return "ResponseType::EXACT";

            case ResponseType::EXTRA:
                return "ResponseType::EXTRA";
        }
    }
}

class YoMarket
{
    public function searchItem(string $query, string $ip): Response
    {
        $this->found = array();
        $new = strtolower(str_replace(" ", "%20", $query));
        if(strlen($query) < 2) 
            return (new Response(ResponseType::NONE, 0));
        
        try {
            $api_resp = file_get_contents("http://api.yomarket.info/search?q=$new&ip=$ip");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return (new Response(ResponseType::API_FAILURE, 0));
        }

        
        if(str_contains($api_resp, "[ X ]"))
            return (new Response(ResponseType::NONE, 0));

        // if(!str_starts_with($api_resp, "[") && str_ends_with($api_resp, "]"))
        //     return (new Response(ResponseType::NONE, 0));
        
        if(!str_contains($api_resp, "\n"))
            return (new Response(ResponseType::EXACT,  (new Item(explode(",", YoMarket::remove_strings($api_resp, array("'", "]", "[")))))));

        
        $lines = explode("\n", $api_resp);
        if(str_contains($api_resp, "\n") && !str_starts_with($lines[1], "[") && !str_ends_with($line[1], "]"))
        {
            $item_info = explode("\n", $api_resp);

            $content = str_replace($item_info[0], "", $api_resp);
            
            $gg = explode(",", YoMarket::remove_strings($item_info[0], array("[", "]", "'")));
            $i = new Item($gg);
            
            $i->parse_prices($content);

            return (new Response(ResponseType::EXACT, $i));
        }

        foreach($lines as $line)
        {
            $info = explode(",", YoMarket::remove_strings($line, array("'", "]", "[")));
            if(count($info) >= 5) {

                array_push($this->found, (new Item($info)));
            }
        }

        if(count($this->found) > 1)
            return(new Response(ResponseType::EXTRA, $this->found));

        echo 'here';
        return (new Response(ResponseType::NONE, 0));
    }

    public static function all_suggestions(): array
    {
        try {
            $api_resp = file_get_contents("https://api.yomarket.info/all_suggestion");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return (new Response(ResponseType::API_FAILURE, 0));
        }
        return explode("\n", YoMarket::remove_strings($api_resp, array("'", "[", "]", "(", ")")));
    }

    public function price_logs(): Response 
    {
        $this->logs = array();

        try {
            $api_resp = file_get_contents("https://api.yomarket.info/price_logs");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return (new Response(ResponseType::API_FAILURE, 0));
        }

        $lines = explode("\n", YoMarket::remove_strings($api_resp, array("'", "[", "]", "(", ")")));

        foreach($lines as $line)
        {
            $log_info = explode(",", YoMarket::remove_strings($line, array("'", "]", "[", "(", ")")));
            if(count($log_info) >= 5) {
                array_push($this->logs, (new price_log($log_info)));
            }
        }

        if(count($this->logs) > 0)
            return (new Response(ResponseType::REQ_SUCCESS, $this->logs));

        return (new Response(ResponseType::API_FAILURE, 0));
    }

    public static function stats(): Response 
    {
        try {
            $api_resp = file_get_contents("https://api.yomarket.info/statistics");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return (new Response(ResponseType::API_FAILURE, 0));
        }

        return (new Response(ResponseType::API_FAILURE, $api_resp));
    }

    public static function change_price(Item $item, string $new_price, string $ip): Response
    {
        $api_res = file_get_contents("https://api.yomarket.info/change?id=$item->id&price=$new_price&ip=$ip");
        
        if(str_contains($api_res, "[ X ]"))
            return (new Response(ResponseType::FAILED_TO_UPDATE, $api_res));

        return (new Response(ResponseType::ITEM_UPDATED, $api_res));
    }

    public static function suggest_price(Item $itm, string $new_price, string $ip): bool
    {
        try {
            $api_resp = file_get_contents("https://api.yomarket.info/suggestion?id=$itm->id&price=$price&ip=$ip");
            if(empty($api_resp))
               throw new Exception("failed to open stream ", 1);
        } catch (Exception $e) {
            return false;
        }

        if(str_contains($api_resp, "[ + ]"))
            return true;

        return false;
    }

    public function getResults(Response $r): array | Item 
    {
        if($r->type == ResponseType::NONE) return array();
        if($r->type == ResponseType::EXACT) return $this->found[0];
        if($r->type == ResponseType::EXTRA) return $this->found;
        return array();
    }

    public static function generateRow(array $arr): string 
    {
        $table = '<table style="width:100%">{ROWS}</table>';
        $row = "<tr>{ITEMS}</tr>";
        $item = "<td>{ITEM_DATA}</td>";

        $imgTag = '<img img width="150" height="150" src="{IMG_URL}"/>';
        $nameTag = '<p>{ITEM_NAME}</p>';
        $priceTag = '<p>{ITEM_PRICE}</p>';
        $updateTag = '<p>{ITEM_UPDATE}</p>';

        $items = "";

        foreach($arr as $i)
        {
            $new_imgTag = $imgTag;
            $new_nameTag = $nameTag;
            $new_priceTag = $priceTag;
            $new_updateTag = $updateTag;
            $new_item = $item;
            if($i->name === "") continue;
            $new_imgTag = str_replace("{ITEM_URL}", $i->url, $new_imgTag);
            $new_nameTag = str_replace("{ITEM_NAME}", $i->name, $new_nameTag);
            $new_priceTag = str_replace("{ITEM_PRICE}", $i->price, $new_priceTag);
            $new_updateTag = str_replace("{ITEM_UPDATE}", $i->update, $new_updateTag);

            $new_item = str_replace("{ITEM_DATA}", $new_imgTag. $new_nameTag. $new_priceTag. $new_updateTag, $new_imgTag);
            $items = $items. $new_item;
        }

        $row = str_replace("{ITEMS}", $items, $row);
        $table = str_replace("{ROWS}", $row, $table);

        return $table;
    }

    public static function remove_strings(string $str, array $arr): string 
    {
        $gg = $str;
        foreach($arr as $i)
        { $gg = str_replace("$i", "", $gg); }
        return $gg;
    }
}

?>