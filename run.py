import os
import asyncio
import uvicorn
from dotenv import load_dotenv

from app.config.database import check_database


load_dotenv()
port = os.getenv('PORT')
asyncio.run(check_database())
# uvicorn.run("server:fastAPI", host="0.0.0.0", port=5000)
uvicorn.run("server:fastAPI", host="0.0.0.0", port=443, ssl_certfile='certificates/cert.pem', ssl_keyfile='certificates/key.pem')
