<?php

class Test 
{
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
}