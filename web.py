from flask import Flask, render_template, request, redirect, url_for, session
from datetime import datetime, time
import calendar
from flask_mail import Mail, Message
from collections import deque  # DSA: Queue for waiting list
import heapq  # Priority Queue for future waiting list priority
# ─────────────────────────────────────────────
#  DSA: Dictionary used for in-memory caching
#  of station list and train data (O(1) lookup)
# ─────────────────────────────────────────────
station_cache = {}   # Dictionary: station_code -> station_name
train_cache   = {}   # Dictionary: trainno -> train details
import heapq  # DSA: Priority Queue
# ─────────────────────────────────────────────
# DSA: Dijkstra's Algorithm O((V+E) log V)
# Finds cheapest route between two stations
# V = number of stations, E = number of routes
# Uses priority queue (heapq) internally
# ─────────────────────────────────────────────
def dijkstra(graph, start, end):
    """
    Dijkstra's Shortest Path Algorithm
    graph = {station: [(cost, next_station), ...]}
    Returns (minimum_cost, path_list)
    Time: O((V+E) log V)
    Space: O(V)
    """
    # Priority queue: (cost, current_station, path)
    pq = [(0, start, [start])]    # DSA: heapq priority queue
    visited = set()                # DSA: Set for O(1) lookup

    while pq:
        cost, node, path = heapq.heappop(pq)  # O(log V)

        if node in visited:
            continue
        visited.add(node)          # Mark visited O(1)

        if node == end:
            return cost, path      # Found shortest path!

        # Explore neighbours
        for next_cost, neighbour in graph.get(node, []):
            if neighbour not in visited:
                heapq.heappush(pq, (cost + next_cost, neighbour, path + [neighbour]))

    return float('inf'), []        # No path found
# ─────────────────────────────────────────────
# DSA: Priority Queue using heapq O(log n)
# Used for waiting list — lower priority number
# means higher priority (e.g. senior citizens first)
# heappush: O(log n), heappop: O(log n)
# ─────────────────────────────────────────────
waiting_priority_queue = {}  # Dictionary of heaps

def priority_enqueue(trainno, date, category, passenger_id, priority=1):
    """
    DSA: Priority Queue Enqueue - O(log n)
    Lower priority number = served first
    priority=0: Senior citizen / differently abled
    priority=1: Normal passenger
    """
    key = f"{trainno}_{date}_{category}"
    if key not in waiting_priority_queue:
        waiting_priority_queue[key] = []
    # heapq stores (priority, passenger_id) tuples
    heapq.heappush(waiting_priority_queue[key], (priority, passenger_id))

def priority_dequeue(trainno, date, category):
    """
    DSA: Priority Queue Dequeue - O(log n)
    Always returns highest priority passenger first
    """
    key = f"{trainno}_{date}_{category}"
    if key in waiting_priority_queue and waiting_priority_queue[key]:
        priority, passenger_id = heapq.heappop(waiting_priority_queue[key])
        return passenger_id
    return None
# ─────────────────────────────────────────────
#  DSA: Queue (deque) for Waiting List Management
#  When seats are full, passengers are added to
#  a waiting list queue (FIFO). On cancellation,
#  the first passenger in queue gets the seat.
# ─────────────────────────────────────────────
waiting_list_queue = {}  # Dictionary of deques: key = "trainno_date_category"

def get_waiting_queue(trainno, date, category):
    """Returns the waiting list queue for a specific train/date/category."""
    key = f"{trainno}_{date}_{category}"
    if key not in waiting_list_queue:
        waiting_list_queue[key] = deque()  # DSA: Initialize empty queue
    return waiting_list_queue[key]

def enqueue_waiting(trainno, date, category, passenger_id):
    """DSA: Enqueue - Add passenger to waiting list (O(1))."""
    q = get_waiting_queue(trainno, date, category)
    q.append(passenger_id)
    return len(q)  # Return waiting list position

def dequeue_waiting(trainno, date, category):
    """DSA: Dequeue - Remove first passenger from waiting list (O(1))."""
    q = get_waiting_queue(trainno, date, category)
    if q:
        return q.popleft()
    return None

# ─────────────────────────────────────────────
#  DSA: Linear Search — O(n)
#  Search through train list to find trains
#  matching source and destination stations
# ─────────────────────────────────────────────
# ─────────────────────────────────────────────
# DSA: Binary Search O(log n)
# Searches sorted list of train numbers for a match
# Much faster than linear search for large datasets
# ─────────────────────────────────────────────
def binary_search(sorted_list, target):
    """
    Binary Search - O(log n)
    Requires sorted input list.
    Returns index if found, -1 if not found.
    """
    low  = 0
    high = len(sorted_list) - 1

    while low <= high:
        mid = (low + high) // 2        # Find middle index
        if sorted_list[mid] == target:
            return mid                  # Found!
        elif sorted_list[mid] < target:
            low = mid + 1              # Search right half
        else:
            high = mid - 1            # Search left half
    return -1                          # Not found

# ─────────────────────────────────────────────
#  DSA: Array/List operations
#  Used for storing passenger details,
#  seat numbers, and booking records
# ─────────────────────────────────────────────
def build_passenger_arrays(form, people):
    """
    DSA: Array construction O(n)
    Builds parallel arrays for passenger data:
    name_list[], age_list[], sex_list[], food_list[]
    Index i in each array = data for passenger i
    """
    name_list = []   # Array: passenger names
    age_list  = []   # Array: passenger ages
    sex_list  = []   # Array: passenger genders
    food_list = []   # Array: food preferences

    for i in range(people):           # O(n) - build arrays
        name_list.append(form.get(f"name{i+1}", ""))
        age_list.append(form.get(f"age{i+1}", ""))
        sex_list.append(form.get(f"sex{i+1}", ""))
        food_list.append(form.get(f"food{i+1}", ""))

    return name_list, age_list, sex_list, food_list

# ─────────────────────────────────────────────
#  DSA: Dictionary for user session management
#  session{} is a dictionary storing key-value
#  pairs for logged-in user state (O(1) access)
# ─────────────────────────────────────────────

SESSION_TYPE = 'filesystem'

app = Flask(__name__, template_folder="HTML", static_folder="static")

app.secret_key = 'super secret key'
app.config['SESSION_TYPE'] = 'filesystem'

app.config['MAIL_SERVER']   = 'smtp.gmail.com'
app.config['MAIL_PORT']     = 465
app.config['MAIL_USERNAME'] = 'axitk355@gmail.com'
app.config['MAIL_PASSWORD'] = 1234   # Security code - google (password)
app.config['MAIL_USE_TLS']  = False
app.config['MAIL_USE_SSL']  = True
mail = Mail(app)

import mysql.connector

connection = mysql.connector.connect(
    host="localhost", user="root", password="1234", database="Railway"
)
cursor = connection.cursor(buffered=True)

# ══════════════════════════════════════════════
#  ROUTES
# ══════════════════════════════════════════════

@app.route("/")
def homepage():
    return render_template("home.html")

@app.route("/t&c")
def tandc():
    return render_template("t&c.html")

@app.route("/privacypolicy")
def privacy():
    return render_template("privacypolicy.html")

@app.route("/register1")
def register1():
    return render_template("registration1.html")

@app.route('/cheapestroute', methods=['GET', 'POST'])
def cheapestroute():
    if request.method == 'POST':
        start    = request.form['start'].split("-")[0]
        end      = request.form['end'].split("-")[0]
        category = request.form.get('category', 'SL')

        # DSA: Build graph from DB for Dijkstra O(E)
        price_col_map = {
            "SL": "SLprice", "3A": "3Aprice",
            "2A": "2Aprice", "1A": "1Aprice", "CC": "CCprice"
        }
        price_col = price_col_map.get(category, "SLprice")

        cursor.execute(
            f"SELECT Deptstation, Arrivalstation, {price_col} FROM Generalrouteprices "
            f"JOIN Route ON Generalrouteprices.RouteID = Route.RouteID"
        )
        edges = cursor.fetchall()

        # DSA: Dictionary - adjacency list for graph O(V)
        graph = {}
        for dept, arrival, price in edges:
            if dept not in graph:
                graph[dept] = []
            graph[dept].append((price, arrival))  # (cost, neighbour)

        # DSA: Run Dijkstra O((V+E) log V)
        min_cost, path = dijkstra(graph, start, end)

        cursor.execute("SELECT * FROM station")
        z = cursor.fetchall()

        if min_cost == float('inf'):
            return render_template('search.html', z=z,
                msg="No route found between these stations.")

        return render_template('search.html', z=z,
            msg=f"Cheapest route: {' → '.join(path)} | Total price: ₹{min_cost}")

    cursor.execute("SELECT * FROM station")
    z = cursor.fetchall()
    return render_template('search.html', z=z)

@app.route("/register2", methods=["POST"])
def register2():
    username        = request.form["username"]
    password        = request.form["password"]
    securityquestion = request.form["securityquestion"]
    securityanswer  = request.form["securityanswer"]

    session['registername'] = username

    # DSA: Dictionary lookup via SQL - O(1) with indexed ID
    cursor.execute("SELECT ID FROM Userdetails WHERE ID=%s", (username,))
    validate = cursor.fetchall()

    # DSA: List length check O(1)
    if len(validate) == 0:
        cursor.execute(
            "INSERT INTO Userdetails(ID,Password,Securityquestion,Securityanswer) VALUES(%s,%s,%s,%s)",
            (username, password, securityquestion, securityanswer)
        )
        connection.commit()
        return render_template('registration2.html')
    else:
        return render_template('registration1.html', validuserid="(User Id already present)")

@app.route("/register3", methods=["POST"])
def register3():
    username      = session.get('registername', None)
    fname         = request.form["fname"]
    mname         = request.form["mname"]
    lname         = request.form["lname"]
    occupation    = request.form["occupation"]
    dob           = request.form["DOB"]
    martialstatus = request.form["martialstatus"]
    country       = request.form["country"]
    sex           = request.form["sex"]
    email         = request.form["email"]
    mobileno      = request.form["mobileno"]

    cursor.execute(
        """UPDATE Userdetails SET Firstname=%s,Middlename=%s,Lastname=%s,
           Occupation=%s,DOB=%s,Martialstatus=%s,Nationality=%s,
           Gender=%s,Email=%s,Mobile=%s WHERE ID=%s""",
        (fname, mname, lname, occupation, dob, martialstatus,
         country, sex, email, mobileno, username)
    )
    connection.commit()
    return render_template('registration3.html')

@app.route("/login")
def login():
    return render_template("login.html")

@app.route("/login1", methods=["POST"])
def login1():
    # DSA: List - fetch all stations into a list array O(n)
    cursor.execute("SELECT * FROM station")
    z = cursor.fetchall()   # z is a List of tuples

    username = request.form.get("username")
    password = request.form.get("password")

    # DSA: Dictionary - store user ID in session dictionary O(1)
    session['ID'] = username

    cursor.execute(
        "SELECT * FROM Userdetails WHERE ID=%s AND Password=%s",
        (username, password)
    )
    validate = cursor.fetchall()

    cursor.execute("SELECT * FROM Userdetails WHERE ID=%s", (username,))
    validate1 = cursor.fetchall()

    if len(validate) > 0:
        return render_template('search.html', z=z)
    elif len(validate1) > 0:
        return render_template('login.html', validpassword="(Password incorrect)")
    else:
        return render_template('login.html', validuserid="(Wrong credentials)")

@app.route('/register', methods=["POST"])
def register():
    username = session.get('registername', None)
    fno      = request.form["fno"]
    lane     = request.form["lane"]
    area     = request.form["area"]
    state    = request.form["state"]
    pincode  = request.form["pincode"]
    city     = request.form["city"]

    cursor.execute(
        "UPDATE Userdetails SET Flatno=%s,Street=%s,Locality=%s,State=%s,Pincode=%s,City=%s WHERE ID=%s",
        (fno, lane, area, state, pincode, city, username)
    )
    connection.commit()
    return render_template('home.html')

@app.route('/selecttrains')
def Text():
    cursor.execute("SELECT * FROM station")
    z = cursor.fetchall()
    return render_template('search.html', z=z)

@app.route('/runningstatus')
def runningstatus():
    return render_template("runningstatus.html")

@app.route('/runningstatus1', methods=["POST"])
def runningstatus1():
    Trainno = request.form['running']
    Date    = request.form['Date']
    Date1   = Date.replace("-", ":")
    Date    = Date.split("-")
    a = int(Date[0])
    b = int(Date[1])
    c = int(Date[2])

    # DSA: Array (list) - days indexed by weekday number O(1)
    d   = datetime(a, b, c).weekday()
    lst = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    day = lst[d]   # O(1) array index access

    c    = datetime.now()
    time = c.strftime("%H:%M:%S")
    date = c.strftime("%Y-%m-%d")  

    date_format = "%Y:%m:%d"
    a = datetime.strptime(Date1, date_format)
    b = datetime.strptime(date, date_format)
    delta      = b - a
    difference = delta.days

    cursor.execute(
        "SELECT * FROM traindetails WHERE {}=1 AND trainno=%s".format(day),
        (Trainno,)
    )
    x = cursor.fetchall()

    if len(x) > 0 and date == Date1:
        cursor.execute(
            "SELECT Depttime FROM route WHERE trainno=%s AND stopnumber=1",
            (Trainno,)
        )
        m     = cursor.fetchall()
        time1 = m[0][0]
        cursor.execute(
            """SELECT Deptstation,Depttime,Arrivalstation,Arrivaltime FROM route
               WHERE trainno=%s AND depttime<=%s AND arrivaltime>=%s AND depttime>=%s""",
            (Trainno, time, time, time1)
        )
        z = cursor.fetchall()
        cursor.execute(
            "SELECT Startstation FROM traindetails WHERE trainno=%s AND starttime>%s",
            (Trainno, time)
        )
        y = cursor.fetchall()
        cursor.execute(
            "SELECT Endstation FROM traindetails WHERE trainno=%s AND endtime<%s",
            (Trainno, time)
        )
        x = cursor.fetchall()

        if len(z) > 0:
            return render_template("runningstatus.html", status=z)
        elif len(y) > 0:
            return render_template("runningstatus.html", notrunning="Train didn't start yet.")
        elif len(x) > 0:
            return render_template("runningstatus.html", notrunning="Train completed its journey.")

    elif len(x) > 0 and date > Date1:
        cursor.execute(
            """SELECT Deptstation,Depttime,Deptday,Arrivalstation,Arrivaltime,Arrivalday
               FROM route WHERE trainno=%s AND depttime<=%s AND arrivaltime>=%s""",
            (Trainno, time, time)
        )
        z = cursor.fetchall()
        if z == []:
            return render_template("runningstatus.html", notrunning="Train completed its journey.")
        elif z[0][5] - 1 >= difference and (z[0][5] - z[0][2]) >= 0:
            return render_template("runningstatus.html", status1=z)
        else:
            return render_template("runningstatus.html", notrunning="Train completed its journey.")

    elif len(x) > 0 and date < Date1:
        return render_template("runningstatus.html", notrunning="The day didn't arrive.")
    else:
        return render_template("runningstatus.html", notrunning="Train is not running on this day.")

@app.route('/search', methods=['GET', 'POST'])
def search():
    if request.method == 'POST' and 'Startstation' in request.form and 'Endstation' in request.form:
        cursor.execute("SELECT * FROM station")
        stations = cursor.fetchall()   # DSA: List of station tuples

        Startstation = request.form['Startstation'].split("-")[0]
        Endstation   = request.form['Endstation'].split("-")[0]
        Category     = request.form['category']
        Date         = request.form['Date']

        # ─────────────────────────────────────────────
        # DSA: Linear Search O(n*m)
        # Find trains that have BOTH source and
        # destination in their route stops.
        # Two lists 'a' and 'b' are fetched, then
        # intersection is computed using nested loop.
        # ─────────────────────────────────────────────
        cursor.execute("SELECT Trainno FROM Route WHERE Deptstation=%s", (Startstation,))
        a = cursor.fetchall()   # DSA: List of trains from source

        cursor.execute("SELECT Trainno FROM Route WHERE Arrivalstation=%s", (Endstation,))
        b = cursor.fetchall()   # DSA: List of trains to destination

        # DSA: Binary Search O(log n)
        # Sort list_a, then binary search each item from list_b
        list_a = sorted([row[0] for row in a])  # Sort for binary search O(n log n)
        list_b = [row[0] for row in b]

        z = []
        for trainno in list_b:                  # O(m) outer loop
            if binary_search(list_a, trainno) != -1:  # O(log n) binary search
                if trainno not in z:
                    z.append(trainno)
# Total: O(m log n) — better than O(n*m) linear search

        session['startstation'] = Startstation
        session['endstation']   = Endstation
        session['date']         = Date
        session['type']         = Category

        if Category == "General":
            # DSA: Parallel arrays to store price data for each train
            x = []   # SL prices list
            r = []   # 3A prices list
            w = []   # 2A prices list
            t = []   # CC prices list
            o = []   # 1A prices list
            y = []   # seat availability list

            for i in z:   # O(n) - iterate matching trains
                cursor.execute(
                    """SELECT Traindetails.Trainno,Trainname,Date,SLseats,SLWL,
                              3Aseats,3AWL,2Aseats,2AWL,1Aseats,1AWL,CCseats,CCWL
                       FROM Traindetails
                       INNER JOIN Generalseatavailability
                       ON Traindetails.Trainno = Generalseatavailability.Trainno
                       WHERE Traindetails.Trainno=%s AND Generalseatavailability.date=%s""",
                    (i, Date)
                )
                y.append(cursor.fetchall())

                cursor.execute("SELECT Trainno FROM Traindetails WHERE Trainno=%s", (i,))
                s = cursor.fetchall()

                cursor.execute("SELECT Trainname FROM Traindetails WHERE Trainno=%s", (i,))
                d = cursor.fetchall()
                session['trainname'] = d[0][0]

                cursor.execute(
                    "SELECT Stopnumber FROM Route WHERE Trainno=%s AND Deptstation=%s",
                    (s[0][0], Startstation)
                )
                p = cursor.fetchall()

                cursor.execute(
                    "SELECT Stopnumber FROM Route WHERE Trainno=%s AND Arrivalstation=%s",
                    (s[0][0], Endstation)
                )
                q = cursor.fetchall()

                # DSA: Array of route segment IDs between source and dest
                c = []
                for j in range(p[0][0], q[0][0] + 1):   # O(stops) loop
                    cursor.execute(
                        "SELECT RouteID FROM Route WHERE Trainno=%s AND Stopnumber=%s",
                        (s[0][0], j)
                    )
                    c.append(cursor.fetchall())

                # DSA: Array accumulation - sum prices across segments O(segments)
                def sum_price(col_name, table):
                    total = 0
                    for seg in c:
                        cursor.execute(
                            f"SELECT {col_name} FROM {table} WHERE RouteID=%s",
                            (seg[0][0],)
                        )
                        row = cursor.fetchall()
                        total += row[0][0]
                    return total

                x.append(sum_price("SLprice",  "Generalrouteprices"))
                r.append(sum_price("3Aprice",  "Generalrouteprices"))
                w.append(sum_price("2Aprice",  "Generalrouteprices"))
                o.append(sum_price("1Aprice",  "Generalrouteprices"))
                t.append(sum_price("CCprice",  "Generalrouteprices"))

            if y == [[]] or y == []:
                return render_template("search.html", z=stations,
                    msg="There is no train running on this date between these stations.")
            else:
                return render_template("search.html", c=y, z=stations,
                    x=x, r=r, w=w, o=o, t=t)

        elif Category == "Tatkal":
            x = []
            r = []
            w = []
            s = []
            t = []
            o = []
            y = []
            for i in z:
                cursor.execute(
                    """SELECT Traindetails.Trainno,Trainname,Date,SLseats,SLWL,
                              3Aseats,3AWL,2Aseats,2AWL,1Aseats,1AWL,CCseats,CCWL
                       FROM Traindetails
                       INNER JOIN Tatkalseatavailability
                       ON Traindetails.Trainno = Tatkalseatavailability.Trainno
                       WHERE Traindetails.Trainno=%s""",
                    (i,)
                )
                y_row = cursor.fetchall()
                y.append(y_row)

                cursor.execute("SELECT Trainno FROM Traindetails WHERE Trainno=%s", (i,))
                s = cursor.fetchall()

                cursor.execute("SELECT Trainname FROM Traindetails WHERE Trainno=%s", (i,))
                d = cursor.fetchall()
                session['trainname'] = d[0][0]

                cursor.execute(
                    "SELECT Stopnumber FROM Route WHERE Trainno=%s AND Deptstation=%s",
                    (s[0][0], Startstation)
                )
                p = cursor.fetchall()

                cursor.execute(
                    "SELECT Stopnumber FROM Route WHERE Trainno=%s AND Arrivalstation=%s",
                    (s[0][0], Endstation)
                )
                q = cursor.fetchall()

                c = []
                for j in range(p[0][0], q[0][0] + 1):
                    cursor.execute(
                        "SELECT RouteID FROM Route WHERE Trainno=%s AND Stopnumber=%s",
                        (s[0][0], j)
                    )
                    c.append(cursor.fetchall())

                def sum_price_t(col_name):
                    total = 0
                    for seg in c:
                        cursor.execute(
                            f"SELECT {col_name} FROM Tatkalrouteprices WHERE RouteID=%s",
                            (seg[0][0],)
                        )
                        row = cursor.fetchall()
                        total += row[0][0]
                    return total

                x.append(sum_price_t("SLprice"))
                r.append(sum_price_t("3Aprice"))
                w.append(sum_price_t("2Aprice"))
                o.append(sum_price_t("1Aprice"))
                t.append(sum_price_t("CCprice"))

            # Re-fetch y for Tatkal properly
            y2 = []
            for i in z:
                cursor.execute(
                    """SELECT Traindetails.Trainno,Trainname,Date,SLseats,SLWL,
                              3Aseats,3AWL,2Aseats,2AWL,1Aseats,1AWL,CCseats,CCWL
                       FROM Traindetails
                       INNER JOIN Tatkalseatavailability
                       ON Traindetails.Trainno = Tatkalseatavailability.Trainno
                       WHERE Traindetails.Trainno=%s""",
                    (i,)
                )
                y2.append(cursor.fetchall())

            if y2 == [[]] or y2 == []:
                return render_template("search.html", z=stations,
                    msg="There is no train running on this date between these stations.")
            else:
                return render_template("search.html", c=y2, z=stations,
                    x=x, r=r, w=w, o=o, t=t)

    cursor.execute("SELECT * FROM station")
    z = cursor.fetchall()
    return render_template('search.html', z=z)

@app.route('/book', methods=['GET', 'POST'])
def book():
    if request.method == 'POST':
        ID          = session.get('ID', None)
        trainno     = session.get('trainno', None)
        startstation = session.get('startstation', None)
        endstation  = session.get('endstation', None)
        date        = session.get('date', None)
        trainname   = session.get('trainname', None)
        ticket_type = session.get('type', None)
        category    = request.form.get('category')
        people      = int(request.form.get('people', 1))

        session['category'] = category

        # DSA: Check seat availability using DB query
        seat_col_map = {
            "SL": "SLseats", "3A": "3Aseats", "2A": "2Aseats",
            "1A": "1Aseats", "CC": "CCseats"
        }
        wl_col_map = {
            "SL": "SLWL", "3A": "3AWL", "2A": "2AWL",
            "1A": "1AWL", "CC": "CCWL"
        }

        seat_table = "Generalseatavailability" if ticket_type == "General" else "Tatkalseatavailability"
        seat_col   = seat_col_map.get(category, "SLseats")
        wl_col     = wl_col_map.get(category, "SLWL")

        cursor.execute(
            f"SELECT {seat_col}, {wl_col} FROM {seat_table} WHERE trainno=%s AND date=%s",
            (trainno, date)
        )
        seat_row = cursor.fetchone()

        if not seat_row:
            return render_template('search.html', msg="Seat data not found.")

        Nseats   = seat_row[0]
        wl_count = seat_row[1]

        # ─────────────────────────────────────────────
        # DSA: Queue — Waiting List Management
        # If seats available: book normally
        # If seats = 0: add to waiting list queue (FIFO)
        # On cancellation: dequeue first waiting passenger
        # ─────────────────────────────────────────────
        if Nseats <= 0:
        # DSA: Priority Queue - add to waiting list O(log n)
        # Check if senior citizen for higher priority
            age = int(request.form.get('age1', 30))
            priority = 0 if age >= 60 else 1  # Senior citizens get priority 0

            priority_enqueue(trainno, date, category, ID, priority)

            wl_position = wl_count + people
            cursor.execute(
                f"UPDATE {seat_table} SET {wl_col}=%s WHERE trainno=%s AND date=%s",
                (wl_position, trainno, date)
            )
            connection.commit()
            return render_template('search.html',
                msg=f"No seats available. Added to Priority Waiting List. Position: WL{wl_position}")

        # DSA: Build parallel arrays for passenger details O(n)
        name_l = []
        age_l  = []
        sex_l  = []
        food_l = []
        for i in range(people):
            name_l.append(request.form.get(f"name{i+1}", ""))
            age_l.append(request.form.get(f"age{i+1}", ""))
            sex_l.append(request.form.get(f"sex{i+1}", ""))
            food_l.append(request.form.get(f"food{i+1}", ""))

        # DSA: Array for seat assignment
        seats = []   # Array of seat numbers assigned
        ids   = []   # Array of passenger IDs

        # Get next PNR using list length O(1)
        cursor.execute("SELECT MAX(PNR) FROM ticket")  # O(1) space
        last = cursor.fetchone()
        PNR = 1 if not last[0] else last[0] + 1

        # Get route times
        cursor.execute(
            "SELECT Depttime FROM route WHERE trainno=%s AND Deptstation=%s",
            (trainno, startstation)
        )
        dept_row = cursor.fetchone()
        depttime = dept_row[0] if dept_row else "00:00:00"

        cursor.execute(
            "SELECT Arrivaltime FROM route WHERE trainno=%s AND Arrivalstation=%s",
            (trainno, endstation)
        )
        arr_row     = cursor.fetchone()
        arrivaltime = arr_row[0] if arr_row else "00:00:00"

        # Calculate base price
        cursor.execute(
            "SELECT Stopnumber FROM Route WHERE Trainno=%s AND Deptstation=%s",
            (trainno, startstation)
        )
        p = cursor.fetchall()
        cursor.execute(
            "SELECT Stopnumber FROM Route WHERE Trainno=%s AND Arrivalstation=%s",
            (trainno, endstation)
        )
        q = cursor.fetchall()

        price = 0
        if p and q:
            price_col_map = {
                "SL": "SLprice", "3A": "3Aprice", "2A": "2Aprice",
                "1A": "1Aprice", "CC": "CCprice"
            }
            price_col   = price_col_map.get(category, "SLprice")
            price_table = "Generalrouteprices" if ticket_type == "General" else "Tatkalrouteprices"

            # DSA: Array accumulation - sum prices O(segments)
            c = []
            for j in range(p[0][0], q[0][0] + 1):
                cursor.execute(
                    "SELECT RouteID FROM Route WHERE Trainno=%s AND Stopnumber=%s",
                    (trainno, j)
                )
                c.append(cursor.fetchall())

            for seg in c:
                if seg:
                    cursor.execute(
                        f"SELECT {price_col} FROM {price_table} WHERE RouteID=%s",
                        (seg[0][0],)
                    )
                    row = cursor.fetchone()
                    if row:
                        price += row[0]

        # DSA: Array iteration - insert each passenger O(n)
        for i in range(people):
            cursor.execute(
                "INSERT INTO Passengerdetails(Id,Name,Gender,Foodtype,Age) VALUES(%s,%s,%s,%s,%s)",
                (ID, name_l[i], sex_l[i], food_l[i], age_l[i])
            )
            connection.commit()
            cursor.execute(
                "SELECT passengerId FROM passengerdetails WHERE passengerid=(SELECT MAX(passengerid) FROM passengerdetails WHERE Id=%s)",
                (ID,)
            )
            f = cursor.fetchone()
            ids.append(f[0])
            seats.append(Nseats)   # DSA: Array append O(1)
            Nseats -= 1

        # Update available seats
        cursor.execute(
            f"UPDATE {seat_table} SET {seat_col}=%s WHERE trainno=%s AND date=%s",
            (Nseats, trainno, date)
        )
        connection.commit()

        # DSA: Array iteration - insert each ticket O(n)
        for i in range(len(seats)):
            cursor.execute(
                "INSERT INTO ticket VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)",
                (PNR, ids[i], ID, category, ticket_type, trainno, "CNF",
                 seats[i], startstation, depttime, endstation, arrivaltime, date, price)
            )
            connection.commit()
        # ─────────────────────────────────────────────
        # DSA: OrderedDict — maintains insertion order
        # Stores booking summary in ordered key-value pairs
        # O(1) access, preserves the order of booking details
        # ─────────────────────────────────────────────
        from collections import OrderedDict
        booking_record = OrderedDict([
            ('PNR',          PNR),
            ('trainno',      trainno),
            ('trainname',    trainname),
            ('category',     category),
            ('type',         ticket_type),
            ('startstation', startstation),
            ('endstation',   endstation),
            ('date',         date),
            ('passengers',   people),
            ('price',        price),
        ])
        # Store in session dictionary for receipt/ticket page O(1)
        session['last_booking'] = dict(booking_record)
        
        # Send confirmation email
        try:
            cursor.execute("SELECT Email FROM userdetails WHERE ID=%s", (ID,))
            user_row = cursor.fetchone()
            if user_row:
                email = user_row[0]
                msg = Message('Booking Confirmation',
                              sender='axitk355@gmail.com',
                              recipients=[email])
                msg.body = (f"Booking confirmed! PNR={PNR}, Train={trainno} {trainname}, "
                            f"Date={date}, From={startstation}, To={endstation}, "
                            f"Passengers={people}, Price=₹{price}")
                mail.send(msg)
        except Exception:
            pass  # Email failure should not break booking

        return render_template("ticket.html", PNR=PNR, c=people,
            name=name_l, age=age_l, sex=sex_l, food=food_l,
            trainno=trainno, startstation=startstation,
            endstation=endstation, date=date, trainname=trainname,
            Nseats=Nseats, seatno=seats, price=price)

    return redirect(url_for('search'))

@app.route("/adminlogin")
def adminlogin():
    return render_template("adminlogin.html")

@app.route("/login2", methods=["POST"])
def login2():
    username = request.form.get("username")
    password = request.form.get("password")

    cursor.execute(
        "SELECT * FROM Admin WHERE UserID=%s AND Password=%s",
        (username, password)
    )
    validate = cursor.fetchall()

    cursor.execute("SELECT * FROM Admin WHERE UserID=%s", (username,))
    validate1 = cursor.fetchall()

    if len(validate) > 0:
        return render_template("adminrights.html")
    elif len(validate1) > 0:
        return render_template('adminlogin.html', validpassword="(Password incorrect)")
    else:
        return render_template('adminlogin.html', validuserid="(Wrong credentials)")

@app.route("/releaseg")
def releaseg():
    cursor.execute("SELECT Trainno FROM Traindetails")
    z = cursor.fetchall()
    return render_template("releaseg.html", z=z)

@app.route("/releasegtickets", methods=["POST"])
def releasegtickets():
    cursor.execute("SELECT Trainno FROM Traindetails")
    z       = cursor.fetchall()
    trainno = request.form["trainno"]
    Date2   = request.form["Date"]
    Date1   = Date2.replace("-", ":")
    Date    = Date2.split("-")
    a, b, c = int(Date[0]), int(Date[1]), int(Date[2])

    d   = datetime(a, b, c).weekday()
    lst = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    day = lst[d]

    cursor.execute(
        "SELECT * FROM traindetails WHERE {}=1 AND trainno=%s".format(day),
        (trainno,)
    )
    run = cursor.fetchall()

    if len(run) > 0:
        # DSA: List manipulation - copy and update seat records
        cursor.execute(
            "SELECT * FROM Generalseatavailability WHERE trainno=%s AND date='2021:10:24'",
            (trainno,)
        )
        x = cursor.fetchall()
        x = [list(row) for row in x]   # DSA: Convert to list of lists

        for row in x:
            row[2] = Date2   # Update date in each row

        for row in x:
            cursor.execute(
                """INSERT INTO Generalseatavailability VALUES
                   (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)""",
                tuple(row)
            )
            connection.commit()

        return render_template("releaseg.html", k="Successfully released", z=z)
    else:
        return render_template("releaseg.html", k="Train doesn't run on this day", z=z)

@app.route("/releaset")
def releaset():
    cursor.execute("SELECT Trainno FROM Traindetails")
    z = cursor.fetchall()
    return render_template("releaset.html", z=z)

@app.route("/releasettickets", methods=["POST"])
def releasettickets():
    cursor.execute("SELECT Trainno FROM Traindetails")
    z       = cursor.fetchall()
    trainno = request.form["trainno"]
    Date2   = request.form["Date"]
    Date1   = Date2.replace("-", ":")
    Date    = Date2.split("-")
    a, b, c = int(Date[0]), int(Date[1]), int(Date[2])

    d   = datetime(a, b, c).weekday()
    lst = ["Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday"]
    day = lst[d]

    cursor.execute(
        "SELECT * FROM traindetails WHERE {}=1 AND trainno=%s".format(day),
        (trainno,)
    )
    run = cursor.fetchall()

    if len(run) > 0:
        cursor.execute(
            "SELECT * FROM Tatkalseatavailability WHERE trainno=%s AND date='2021:10:24'",
            (trainno,)
        )
        x = cursor.fetchall()
        x = [list(row) for row in x]

        for row in x:
            row[2] = Date2

        for row in x:
            cursor.execute(
                """INSERT INTO Tatkalseatavailability VALUES
                   (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)""",
                tuple(row)
            )
            connection.commit()

        return render_template("releaset.html", k="Successfully released", z=z)
    else:
        return render_template("releaset.html", k="Train doesn't run on this day", z=z)

@app.route("/pnr")
def pnr():
    return render_template("pnr.html")

@app.route("/pnr1", methods=['POST'])
def pnr1():
    PNR = request.form['PNR']
    session['PNR'] = PNR
    ID  = session.get('ID', None)

    cursor.execute("SELECT * FROM Ticket WHERE PNR=%s", (PNR,))
    q = cursor.fetchall()   # DSA: List of ticket rows

    if not q:
        return render_template("pnr.html", msg="PNR not found.")

    nseats          = len(q)   # DSA: List length O(1)
    Trainno         = q[0][5]
    Boardingstation = q[0][8]
    Arrivalstation  = q[0][10]
    Date            = q[0][12]
    category        = q[0][3]
    ticket_type     = q[0][4]

    Date = Date.strftime("%Y:%m:%d")

    cursor.execute("SELECT * FROM ticket WHERE PNR=%s AND ID=%s", (PNR, ID))
    z = cursor.fetchall()

    # DSA: Dictionary - store values in session O(1)
    session['nseats']   = nseats
    session['category'] = category
    session['type']     = ticket_type
    session['Trainno']  = Trainno
    session['Date']     = Date

    if len(z) > 0:
        return render_template("cancel.html", PNR=PNR, nseats=nseats,
            Trainno=Trainno, b=Boardingstation, a=Arrivalstation, Date=Date)
    else:
        return render_template("pnr.html", msg="The ticket is not booked from your account.")

@app.route("/cancel")
def cancel():
    PNR         = session.get('PNR', None)
    nseats      = session.get('nseats', None)
    category    = session.get('category', None)
    ticket_type = session.get('type', None)
    Trainno     = session.get('Trainno', None)
    Date        = session.get('Date', None)

    cursor.execute("UPDATE Ticket SET Status=%s WHERE PNR=%s", ("CXL", PNR))
    connection.commit()

    msg = "Cancellation complete"

    if ticket_type == "Tatkal":
        msg = "Cancellation not allowed for Tatkal tickets"
        return render_template("pnr.html", msg=msg)

    # DSA: Dictionary mapping category to DB column name O(1)
    seat_col_map = {
        "CC": "CCseats", "3A": "3Aseats", "2A": "2Aseats",
        "SL": "SLseats", "1A": "1Aseats"
    }
    wl_col_map = {
        "CC": "CCWL", "3A": "3AWL", "2A": "2AWL",
        "SL": "SLWL", "1A": "1AWL"
    }

    seat_col = seat_col_map.get(category)
    wl_col   = wl_col_map.get(category)

    if seat_col and ticket_type == "General":
        cursor.execute(
            f"SELECT {seat_col}, {wl_col} FROM Generalseatavailability WHERE trainno=%s AND date=%s",
            (Trainno, Date)
        )
        row      = cursor.fetchone()
        Nseats   = row[0] + nseats
        wl_count = row[1]

        cursor.execute(
            f"UPDATE Generalseatavailability SET {seat_col}=%s WHERE trainno=%s AND date=%s",
            (Nseats, Trainno, Date)
        )
        connection.commit()

        # DSA: Queue — check waiting list after cancellation
        # If someone is waiting, reduce WL count (FIFO)
        if wl_count > 0:
            # DSA: Priority Queue Dequeue - O(log n)
            # Next highest priority passenger gets the seat
            next_passenger = priority_dequeue(Trainno, Date, category)
            new_wl = wl_count - 1
            cursor.execute(
                f"UPDATE Generalseatavailability SET {wl_col}=%s WHERE trainno=%s AND date=%s",
                (new_wl, Trainno, Date)
            )
            connection.commit()
            msg = f"Cancelled. Passenger {next_passenger} from waiting list confirmed."
        else:
            msg = "Successfully Cancelled"

    return render_template("pnr.html", msg=msg)

if __name__ == "__main__":
    app.run(debug=True)