
from fastapi import FastAPI, HTTPException
from pydantic import BaseModel, Field
from typing import Literal
from datetime import datetime, timezone
import sqlite3


# ==================================================
# APPLICATION CONFIGURATION
# ==================================================

app = FastAPI(
    title="Home App Backend",
    description="Backend API for the Home iPhone application",
    version="1.0.0"
)

DATABASE = "tickets.db"


# ==================================================
# DATABASE CONNECTION
# ==================================================

def get_connection():

    connection = sqlite3.connect(DATABASE)
    connection.row_factory = sqlite3.Row

    return connection


# ==================================================
# DATABASE INITIALISATION AND MIGRATION
# ==================================================

def initialise_database():

    with get_connection() as connection:

        connection.execute("""
            CREATE TABLE IF NOT EXISTS tickets (

                id INTEGER PRIMARY KEY AUTOINCREMENT,
                reference TEXT UNIQUE,
                title TEXT NOT NULL,
                description TEXT NOT NULL,
                location TEXT NOT NULL DEFAULT '',
                category TEXT NOT NULL,
                priority TEXT NOT NULL,
                status TEXT NOT NULL,
                submitted_by_id TEXT NOT NULL,
                submitted_by_name TEXT NOT NULL,
                created_at TEXT NOT NULL

            )
        """)

        # Check whether the location column exists.
        # This allows us to update an older database.

        columns = [
            row["name"]
            for row in connection.execute(
                "PRAGMA table_info(tickets)"
            ).fetchall()
        ]

        if "location" not in columns:

            connection.execute("""
                ALTER TABLE tickets
                ADD COLUMN location TEXT NOT NULL DEFAULT ''
            """)


# Create the database when the application starts.

initialise_database()


# ==================================================
# DATA MODELS
# ==================================================

class TicketCreate(BaseModel):

    title: str = Field(
        min_length=3,
        max_length=150
    )

    description: str = Field(
        min_length=5,
        max_length=5000
    )

    location: str = Field(
        default="",
        max_length=200
    )

    category: Literal[
        "IT Support",
        "Equipment",
        "Building Maintenance",
        "Facilities",
        "Other"
    ]

    priority: Literal[
        "Low",
        "Normal",
        "High",
        "Urgent"
    ]

    submitted_by_id: str

    submitted_by_name: str


class TicketStatusUpdate(BaseModel):

    status: Literal[
        "Open",
        "In Progress",
        "Awaiting Response",
        "Resolved",
        "Closed"
    ]


# ==================================================
# HOME / HEALTH CHECK
# ==================================================

@app.get("/")
def home():

    return {
        "message": "Home App Backend is running!",
        "status": "online"
    }


# ==================================================
# SUBMIT A NEW TICKET
# ==================================================

@app.post("/tickets", status_code=201)
def create_ticket(ticket: TicketCreate):

    created_at = datetime.now(
        timezone.utc
    ).isoformat()

    with get_connection() as connection:

        cursor = connection.execute("""

            INSERT INTO tickets (

                title,
                description,
                location,
                category,
                priority,
                status,
                submitted_by_id,
                submitted_by_name,
                created_at

            )

            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)

        """, (

            ticket.title,
            ticket.description,
            ticket.location,
            ticket.category,
            ticket.priority,
            "Open",
            ticket.submitted_by_id,
            ticket.submitted_by_name,
            created_at

        ))

        ticket_id = cursor.lastrowid

        reference = f"TKT-{ticket_id:05d}"

        connection.execute("""

            UPDATE tickets
            SET reference = ?
            WHERE id = ?

        """, (
            reference,
            ticket_id
        ))

        result = connection.execute("""

            SELECT *
            FROM tickets
            WHERE id = ?

        """, (
            ticket_id,
        )).fetchone()

        return dict(result)


# ==================================================
# RETRIEVE ALL TICKETS
# ==================================================

@app.get("/tickets")
def get_tickets():

    with get_connection() as connection:

        tickets = connection.execute("""

            SELECT *
            FROM tickets
            ORDER BY created_at DESC

        """).fetchall()

        return [
            dict(ticket)
            for ticket in tickets
        ]


# ==================================================
# RETRIEVE ONE TICKET
# ==================================================

@app.get("/tickets/{ticket_id}")
def get_ticket(ticket_id: int):

    with get_connection() as connection:

        ticket = connection.execute("""

            SELECT *
            FROM tickets
            WHERE id = ?

        """, (
            ticket_id,
        )).fetchone()

        if ticket is None:

            raise HTTPException(
                status_code=404,
                detail="Ticket not found"
            )

        return dict(ticket)


# ==================================================
# UPDATE TICKET STATUS
# ==================================================

@app.patch("/tickets/{ticket_id}/status")
def update_ticket_status(
    ticket_id: int,
    update: TicketStatusUpdate
):

    with get_connection() as connection:

        result = connection.execute("""

            UPDATE tickets
            SET status = ?
            WHERE id = ?

        """, (
            update.status,
            ticket_id
        ))

        if result.rowcount == 0:

            raise HTTPException(
                status_code=404,
                detail="Ticket not found"
            )

        ticket = connection.execute("""

            SELECT *
            FROM tickets
            WHERE id = ?

        """, (
            ticket_id,
        )).fetchone()

        return dict(ticket)


# ==================================================
# STARTUP MESSAGE
# ==================================================

@app.on_event("startup")
def startup_message():

    print("===================================")
    print(" Home App Backend Started")
    print(" Ticket API is ready")
    print("===================================")

