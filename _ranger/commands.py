import asyncio
from ranger.api.commands import *
from telethon import TelegramClient
from config import configs

api_id = configs['api_id']
api_hash = configs['api_hash']

client = TelegramClient("homies", api_id, api_hash)
client.start()

# return the username
async def get_homie_username(name='ahmed'):
    homies = await client.get_dialogs()
    for homie in homies:
        try:
            if name.lower() in f"{homie.entity.first_name} {homie.entity.last_name}".lower():
                return homie.entity.username
        except AttributeError:
            pass

async def send_to_homie(name, file_path):
    homie_name = await get_homie_username(name)

    await client.send_file(homie_name, file_path)


class send_to(Command):
    def execute(self):
        if not self.arg(1):
            return self.fm.notify("Username is required")

        # send the current file to telegram
        # if it's a folder, zip and send
        current_path = self.fm.thistab.get_selection()[0]

        asyncio.get_event_loop().run_until_complete(send_to_homie(self.arg(1), str(current_path)))

