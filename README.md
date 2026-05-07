# 🚆 Railway Database Management System

A full-stack web-based Railway Management System built with **Flask (Python)** and **MySQL**. This college project allows users to register, search trains, book tickets, cancel bookings, check PNR status, and find the cheapest route between stations using **Dijkstra's Algorithm**.
---

## 📁 Project Structure

```
PROJECT/
├── web.py                  # Main Flask backend application
├── HTML/                   # HTML templates + SQL files
│   ├── home.html
│   ├── registration1.html
│   ├── pnr.html
│   ├── cancel.html
│   ├── adminlogin.html
│   ├── adminrights.html
│   ├── t&c.html
│   ├── privacypolicy.html
│   ├── Railway.sql         # Main database schema
│   ├── Railway database.sql
│   └── seed_data.sql       # Sample data
├── static/                 # Images
├── FINAL/                  # Final build files
├── Individual ppt/         # Project presentation
└── README.md
```

---

## 🛠️ Technologies Used

| Technology | Purpose |
|------------|---------|
| Python + Flask | Backend web framework |
| MySQL | Relational database |
| HTML | Web page templates (Jinja2) |
| CSS (imported) | Styling and layout |
| JavaScript (imported) | Frontend interactivity |
| Flask-Mail | Email notifications |

---

## 🧠 DSA Concepts Implemented

| Concept | Usage |
|--------|-------|
| **Dijkstra's Algorithm** | Find cheapest route between stations O((V+E) log V) |
| **Priority Queue (heapq)** | Waiting list — senior citizens served first |
| **Queue (deque)** | FIFO waiting list when seats are full |
| **Binary Search** | Fast train number lookup O(log n) |
| **Dictionary** | O(1) caching of station and train data |
| **Arrays / Lists** | Passenger data storage |

---

## ⚙️ Prerequisites

Make sure you have the following installed:

- Python 3.x → https://www.python.org/downloads/
- MySQL Server → https://dev.mysql.com/downloads/
- pip (comes with Python)

---

## 🚀 How to Run

### Step 1: Clone the Repository
```bash
git clone https://github.com/your-username/your-repo-name.git
cd your-repo-name
```

### Step 2: Install Python Dependencies
```bash
pip install flask flask-mail mysql-connector-python
```

### Step 3: Set Up the Database
1. Open **MySQL Workbench** or **MySQL command line**
2. Run the SQL files in this order:
```sql
source HTML/Railway.sql;
source HTML/seed_data.sql;
```
Or import via MySQL Workbench:
- Go to **Server → Data Import → Import from Self-Contained File**
- Select `Railway.sql` first, then `seed_data.sql`

### Step 4: Configure `web.py`
Open `web.py` and update your MySQL credentials:
```python
connection = mysql.connector.connect(
    host="localhost",
    user="root",
    password="YOUR_MYSQL_PASSWORD",  # ← change this
    database="Railway"
)
```

### Step 5: Run the Application
```bash
python web.py
```

### Step 6: Open in Browser
```
http://127.0.0.1:5000
```

---

## 🌐 Key Features & Routes

| Route | Feature |
|-------|---------|
| `/` | Home page |
| `/register1` | User registration |
| `/cheapestroute` | Find cheapest route (Dijkstra's Algorithm) |
| `/pnr` | PNR status check |
| `/cancel` | Ticket cancellation |
| `/adminlogin` | Admin panel login |
| `/releaseg` | Release General seats |
| `/releaset` | Release Tatkal seats |
| `/t&c` | Terms & Conditions |
| `/privacypolicy` | Privacy Policy |

---

## 🗄️ Database Tables

- **Traindetails** — Train info, running days, pricing per category
- **Ticket** — Booking records with PNR, status, seat info
- **Generalseatavailability** — Available seats per train per date
- **Tatkalseatavailability** — Tatkal seat availability
- **Admin** — Admin user credentials

---

## 👥 Developed By

- College Project — Amrita University
- For academic and educational purposes
- AXIT KANDWAL, ABDUL JABBAR M, M ASHWIN KUMAR, RITESH KUMAR

## ⚠️ Notes

- Make sure MySQL service is **running** before starting the app
- Default admin credentials are stored in the `Admin` table in the database
- Tatkal ticket cancellations are **not allowed** (as per Indian Railways policy)
- Waiting list uses a **Priority Queue** — senior citizens get higher priority

---

## 📄 License

This project is for educational purposes only.
