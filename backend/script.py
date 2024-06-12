from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from fastapi.staticfiles import StaticFiles
from fastapi.middleware.cors import CORSMiddleware
from openai import OpenAI
from apscheduler.schedulers.background import BackgroundScheduler
import json
import uvicorn
import uuid
import datetime
import pythonmonkey

jsonrepair = pythonmonkey.require('jsonrepair').jsonrepair

with open("./assets/secrets.json", "r", encoding="utf-8") as file: 
    secrets = json.load(file)

client = OpenAI(api_key=secrets["api_key"])
app = FastAPI()

app.mount("/assets", StaticFiles(directory="assets"), name="assets")

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

sessions = {}

def retrieve_data():
    def assign_cID(data, parent_cIDs=None):
        if parent_cIDs is None:
            parent_cIDs = []
        if isinstance(data, dict):
            for key in data:
                if key == "cID":
                    cID = len(col_dict)
                    data[key] = cID
                    col_dict[cID] = parent_cIDs.copy()
                elif isinstance(data[key], dict) or isinstance(data[key], list):
                    new_parent_cIDs = parent_cIDs.copy()
                    if "cID" in data:
                        new_parent_cIDs.append(data["cID"])
                    assign_cID(data[key], new_parent_cIDs)
        elif isinstance(data, list):
            for item in data:
                assign_cID(item, parent_cIDs.copy())
        return data

    with open("./assets/content.json", "r", encoding="utf-8") as file: 
        data = json.load(file)
    col_dict = {}
    data = assign_cID(data)
    data["collapsible parents"] = col_dict
    return data

def update_assistant(data):
    with open("./assets/secrets.json", "r", encoding="utf-8") as file: 
        secrets = json.load(file)
    assistant = secrets["assistant_id"]

    payload = data.copy()

    payload["contact"]["email"] = "email"
    payload["contact"]["phone"] = "phone"
    payload["contact"]["linkedin"] = "linkedin"
    payload["contact"]["address"] = "address"
    del payload["collapsible parents"]
    del payload["bot"]

    sysmes = "\n\n".join([
        "You are a chatbot in a smart CV Dan built for hiring managers to use. The actual document is given below in JSON format:",
        json.dumps(payload, ensure_ascii=False, indent=2),
        "Other useful information:\n - There are 'Download PDF' and 'Share' buttons in the top right of the screen, and a 'source code' button in the top left.\n - Dan built this app from scratch using Flutter, with a small Python backend to connect to the OpenAI API.",
        "Your job is to assist the hiring manager user in building a case for Dan as a candidate for the roles and organisations they're hiring for, or any other ways he could help them. Be a zealous advocate for Dan, but be honest, truthful and admit when you don't know the answer: users' trust is essential.",
        "Be clear, straightforward and substantive in your responses. Use professional idiomatic British English. Respond in sentences and paragraphs, not headings and lists.",
        "Respond entirely in JSON format with two headers: 'message' and 'cIDs'. Sections of the CV have been assigned 'cID' numbers. At the end of your message, if relevant, append a generous list of cID numbers, and the frontend will use this to highlight the relevant sections. Do not include cID numbers anywhere else."
    ])
    client.beta.assistants.update(assistant, instructions=sysmes)

@app.get("/")
def read_root():
    session_id = str(uuid.uuid4())
    sessions[session_id] = {"active": datetime.datetime.now()}
    data = retrieve_data()
    update_assistant(data)
    thread_id = client.beta.threads.create().id
    sessions[session_id]["thread"] = thread_id
    client.beta.threads.messages.create(
        thread_id=thread_id,
        role="assistant",
        content=data["bot"]["opening message"]
    )
    data["session_id"] = session_id
    return data

@app.post("/sendMessage")
async def send_message(request: Request):
    try:
        data = await request.json()
        message = data.get("message")
        session_id = data.get("session_id")

        if session_id not in sessions:
            return JSONResponse(status_code=400, content={"error": "Invalid session ID"})

        sessions[session_id]["active"] = datetime.datetime.now()

        with open("./assets/secrets.json", "r", encoding="utf-8") as secrets_file:
            secrets = json.load(secrets_file)

        client.beta.threads.messages.create(
            thread_id=sessions[session_id]["thread"],
            role="user",
            content=message,
        )

        client.beta.threads.runs.create_and_poll(
            thread_id=sessions[session_id]["thread"],
            assistant_id=secrets["assistant_id"],
        )

        response = jsonrepair(client.beta.threads.messages.list(thread_id=sessions[session_id]["thread"]).data[0].content[0].text.value)

        return JSONResponse(status_code=200, content=json.loads(response))

    except Exception as e:
        return JSONResponse(status_code=500, content={"message": str(e), "cIDs": []})


def clean_up_sessions():
    now = datetime.datetime.now()
    to_delete = [session_id for session_id, data in sessions.items() if (now - data["active"]).seconds > 3600]
    for session_id in to_delete: del sessions[session_id]

scheduler = BackgroundScheduler()
scheduler.add_job(clean_up_sessions, "interval", seconds=3600)
scheduler.start()

if __name__ == "__main__":
    uvicorn.run("script:app", host="localhost", port=8000, reload=True)