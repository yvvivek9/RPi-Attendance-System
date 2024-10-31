from pymongo import MongoClient
from dotenv import load_dotenv
import os

load_dotenv()
DB_URL = os.getenv('MONGODB_URI')
DB_NAME = os.getenv('MONGODB_DB')


async def get_database():
    # Create a connection using MongoClient. You can import MongoClient or use pymongo.MongoClient
    client = MongoClient(DB_URL)

    # Specify the name of the database to be used
    return client[DB_NAME]


async def check_database():
    dbo = await get_database()
    clc = dbo.list_collection_names()

    if 'timetable' not in clc:
        tb_clc = dbo['timetable']
        days = ['mon', 'tue', 'wed', 'thur', 'fri', 'sat']
        for day in days:
            tb_clc.insert_one({
                'day': day,
                'p1': ['08:00', '09:00'],
                'p2': ['09:00', '10:00'],
                'p3': ['10:00', '11:00'],
                'p4': ['11:00', '12:00'],
                'p5': ['13:00', '14:00'],
                'p6': ['14:00', '15:00'],
                'p7': ['15:00', '16:00'],
                'p8': ['16:00', '17:00']
            })


# async def check_database_schema():
#     dbo = await get_database()
#     clc = dbo.list_collection_names()
#
#     if 'columns' not in clc:
#         columns_clc = dbo['columns']
#         columns_clc.insert_one({
#             "collection_name": "patients",
#             "columns": []
#         })
#         columns_clc.insert_one({
#             "collection_name": "hardware",
#             "columns": []
#         })
#
#     if 'user_types' not in clc:
#         user_types_clc = dbo['user_types']
#         user_types_clc.insert_one({
#             "name": "admin",
#             "display": "Admin",
#             "canDelete": False,
#             "canRegister": False
#         })
#         user_types_clc.insert_one({
#             "name": "nurse",
#             "display": "Nurse",
#             "canDelete": False,
#             "canRegister": True
#         })


# This is added so that many files can reuse the function get_database()
if __name__ == "__main__":
    # Get the database
    db = get_database()
