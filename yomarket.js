// const fetch = require('node-fetch');

// const response = await fetch('https://yoworlddb.com/items/page/');
// const body = await response.text();

// fetch("https://yoworlddb.com/items/page/")
//   .then(err, data => {
//      console.log(data);
//   })
//   .catch(err => {
//      console.log(err);
// })

function req(x) {
    return new Promise((resolve) => {
        setTimeout(() => {
            console.log(fetch("https://yoworlddb.com/items/page/").body)
        }, 2000);
    });
}

async function test()
{
    let t = await req("https://yoworlddb.com/items/page/")
    console.log(t)
}

test()