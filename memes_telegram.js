const TelegramBot = require('node-telegram-bot-api')

// node-fetch v2
const fetch = require('node-fetch')

const redditBaseUrl = "https://api.reddit.com/r"
const redditSearchTypes = ['hot', 'top', 'new', 'rising']
const memesSubReddit = [
  // put your fav sub reddit (pic only)
] 


const getImgUrls = async () => {

  // the data from reddit 
  const redditData = []

  // getting random shit
  const randomSubReddit = memesSubReddit[Math.floor(Math.random() * memesSubReddit.length)]
  const randomSearchType = redditSearchTypes[Math.floor(Math.random() * redditSearchTypes.length)]
  const url = `${redditBaseUrl}/${randomSubReddit}/${randomSearchType}`

  // calling the api
  const res = await fetch(url)
  const data = await res.json()

  const imgChildern = data.data.children

  if (imgChildern) {

    imgChildern.forEach(child => {

      const data = child.data
      const imgUrl = data.url_overridden_by_dest

      if (imgUrl){
        if (imgUrl.endsWith('.png') || imgUrl.endsWith('.jpg') || imgUrl.endsWith('.jpeg') || imgUrl.endsWith('.gifv') || imgUrl.endsWith('.gif') ){
          // data to be sent to telegram
          const title = data.title
          redditData.push({
            subName : randomSubReddit,
            title : title,
            url : imgUrl
          })
        }
      }
    })
  }

  return redditData
}

// sending to telegram
const token = ''

// Create a bot that uses 'polling' to fetch new updates
const bot = new TelegramBot(token, {polling: true});

// Matches "/echo [whatever]"
bot.onText(/\/start/, (msg, match) => {
  // 'msg' is the received Message from Telegram
  // 'match' is the result of executing the regexp above on the text content
  // of the message

  const usageMsg = "To get memes : memes"

  const chatId = msg.chat.id;

  // send back the matched "whatever" to the chat
  bot.sendMessage(chatId, usageMsg);

  bot.on('message', async (msg) => {
    const chatId = msg.chat.id;

    if (msg.text === "memes") {

      // getting the memes
      const memes = await getImgUrls()

      memes.forEach(async (meme) => {

        // sending 
        bot.sendMessage(chatId, `${meme.subName}\n\n${meme.title}\n\n${meme.url}\n`);
        await new Promise(resolve => setTimeout(resolve, 500));
      })
    }else {
        bot.sendMessage(chatId, usageMsg);
    }
  })

})
