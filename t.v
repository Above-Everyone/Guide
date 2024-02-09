
import time

import src
import src.db

fn main() 
{
        mut guide := src.build_guide()

        mut items := []db.FS{}
        for i in 1..3 {
                mut g := find_fs_items(mut guide, i)
                for c in g { items << c }
        }
        println("${items}")
}

/*
        find_all_fs() []db.FS

        Grabbing all items for sale to list on the 
        market page
*/
pub fn find_fs_items(mut g src.Guide, round int) []db.FS 
{
        mut items_fs := []db.FS{}
        for profile in g.profiles 
        {
                if profile.fs_list.len > round { 
                        items_fs << profile.fs_list[round-1]
                }
        }

        return items_fs
}