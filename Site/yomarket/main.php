<?php
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);
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
		public $yw_info_price;
		public $yw_info_update;
		public $yw_info_approval;
		public $yw_db_price;

    function __construct(array $arr)
    {
        if(count($arr) > 5) {
            $this->name = $arr[0];
            $this->id = $arr[1]; 
            $this->url = $arr[2];
            $this->price = $arr[3]; 
            $this->update = $arr[4];
            $this->is_tradable = $arr[5]; $this->is_giftable = $arr[6]; $this->in_store = $arr[7];
            $this->store_price = $arr[8]; $this->gender = $arr[9]; $this->xp = $arr[10];
            $this->category = $arr[11];
        }
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
        $new = str_replace(" ", "%20", $query);
        if(strlen($query) < 2) 
            return (new Response(ResponseType::NONE, 0));

        $api_resp = file_get_contents("http://api.yomarket.info/search?q=$new");

        if(!str_starts_with($api_resp, "[") && str_ends_with($api_resp, "]"))
            return (new Response(ResponseType::NONE, 0));
        
        if(!str_contains($api_resp, "\n"))
            return (new Response(ResponseType::EXACT,  (new Item(explode(",", YoMarket::remove_strings($api_resp, array("'", "]", "[")))))));

        $lines = explode("\n", $api_resp);

        foreach($lines as $line)
        {
            $info = explode(",", YoGuide::remove_strings($line, array("'", "]", "[")));
            if(count($info) > 5) {

                array_push($this->found, (new Item($info)));
            }
        }

        if(count($this->found) > 1)
            return(new Response(ResponseType::EXTRA, $this->found));

        return (new Response(ResponseType::NONE, 0));
    }

    public function getResults(Response $r): array | Item 
    {
        if($r->type == ResponseType::NONE) return array();
        if($r->type == ResponseType::EXACT) return $this->found[0];
        if($r->type == ResponseType::EXTRA) return $this->found;
        return array();
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