# Beauty Salon Appointment Booking System

A simple Java Web Application built with **JSP + Servlets + File Handling (.txt)** for the Glamour Beauty Salon. No database — all data is stored in plain text files.

---

## Tech Stack

- Java 17
- JSP & Servlets (Jakarta Servlet 6 — Tomcat 10)
- HTML, CSS, Bootstrap 5 (CDN)
- File Handling using `FileReader / FileWriter / BufferedReader / BufferedWriter`
- Maven (WAR packaging)
- IntelliJ IDEA Ultimate
- Apache Tomcat 10

---

## Project Structure

```
BeautySalonBookingSystem/
├── pom.xml
├── data/                          (sample seed text files)
│   ├── users.txt
│   ├── appointments.txt
│   ├── services.txt
│   └── reviews.txt
├── src/main/java/
│   ├── Customer.java       (extends abstract Person — Inheritance + Abstraction)
│   ├── Appointment.java
│   ├── Service.java
│   ├── Review.java
│   ├── FileHandler.java
│   ├── RegisterServlet.java
│   ├── LoginServlet.java
│   ├── BookingServlet.java
│   ├── UpdateAppointmentServlet.java
│   └── DeleteAppointmentServlet.java
└── src/main/webapp/
    ├── index.jsp
    ├── register.jsp
    ├── login.jsp
    ├── dashboard.jsp
    ├── booking.jsp
    ├── appointments.jsp
    ├── updateAppointment.jsp
    ├── services.jsp
    ├── reviews.jsp
    ├── logout.jsp
    ├── data/                     (txt files served from deployed app)
    └── WEB-INF/web.xml
```

> `services.jsp` and `reviews.jsp` perform CRUD inline (POST/GET to themselves) so we keep the exact servlet list requested.

---

## Features

### 1. Customer Management
- Register, Login, Logout (session based)
- Customer data stored in `users.txt`

### 2. Appointment Booking (Full CRUD)
- Book appointment (`BookingServlet`)
- View own appointments (`appointments.jsp`)
- Update appointment (`UpdateAppointmentServlet`)
- Cancel/Delete appointment (`DeleteAppointmentServlet`)

### 3. Service Management (Full CRUD)
- Add / View / Update / Delete services from `services.jsp`

### 4. Reviews Management (Full CRUD)
- Add / View / Update / Delete reviews from `reviews.jsp`
- Users can only edit/delete their own reviews

---

## OOP Concepts Used

| Concept       | Where |
|---------------|-------|
| **Encapsulation** | All model classes (`Customer`, `Appointment`, `Service`, `Review`) — private fields with getters/setters |
| **Inheritance**   | `Customer extends Person` (in `Customer.java`) |
| **Abstraction**   | `abstract class Person` with abstract `getRole()` |
| **Polymorphism**  | `Customer.getRole()` overrides `Person.getRole()` |

---

## File Handling

`FileHandler.java` uses:
- `FileWriter` + `BufferedWriter` to write/append
- `FileReader` + `BufferedReader` to read
- Helpers: `appendLine`, `readAllLines`, `writeAllLines`, `updateById`, `deleteById`

Each line in a `.txt` file is one record using comma-separated values.

### File formats

| File | Format |
|------|--------|
| `users.txt`        | `username,password,name,email,phone` |
| `appointments.txt` | `id,username,service,date,time,status` |
| `services.txt`     | `id,name,price,duration` |
| `reviews.txt`      | `id,username,service,rating,comment` |

> Files are read from the deployed web app folder: `<webapp>/data/*.txt`.
> Sample seed files are provided at both `/data/` (project root) and `/src/main/webapp/data/` so they ship inside the WAR.

---

## How to Run in IntelliJ IDEA Ultimate

### 1. Install prerequisites
- JDK 17+
- Apache Tomcat **10.x** (download from https://tomcat.apache.org/)
- IntelliJ IDEA **Ultimate**

### 2. Open the project
1. `File → Open` → select the `BeautySalonBookingSystem` folder.
2. IntelliJ will detect Maven and import dependencies automatically.
3. Wait for indexing to finish.

### 3. Configure Tomcat 10
1. `Run → Edit Configurations… → + → Tomcat Server → Local`
2. **Application server**: click *Configure…* → choose your Tomcat 10 home folder.
3. Tab **Deployment** → click `+` → **Artifact** → choose `BeautySalonBookingSystem:war exploded`.
4. **Application context**: `/BeautySalonBookingSystem` (or `/`).
5. JRE: 17.
6. Click OK.

### 4. Run
- Click the green ▶ button.
- Browser opens at `http://localhost:8080/BeautySalonBookingSystem/`.

### Sample Login (from seed data)
- Username: `alice`  Password: `alice123`
- Username: `bob`    Password: `bob123`

---

## How to Create the .txt Files Manually

If the `data` folder is empty, create these files inside `src/main/webapp/data/`:

**users.txt** (can be empty)
```
alice,alice123,Alice Perera,alice@mail.com,0771112222
```

**appointments.txt** (can be empty)
```
1700000000001,alice,Hair Cut,2026-05-10,10:30,BOOKED
```

**services.txt**
```
1700000000010,Hair Cut,1500.0,30 min
1700000000011,Facial,3500.0,45 min
1700000000012,Manicure,2000.0,40 min
1700000000013,Pedicure,2200.0,45 min
1700000000014,Hair Coloring,5500.0,90 min
```

**reviews.txt** (can be empty)
```
1700000000020,alice,Hair Cut,5,Loved my new hairstyle!
```

> Files are auto-created by `FileHandler` on first write, so they don't need to exist beforehand — but keeping `services.txt` populated lets the booking page show options immediately.

---

## Deploy WAR Manually to Tomcat (Optional)

1. Run `mvn clean package`.
2. Copy `target/BeautySalonBookingSystem.war` into `<TOMCAT_HOME>/webapps/`.
3. Start Tomcat: `<TOMCAT_HOME>/bin/startup.bat`.
4. Open `http://localhost:8080/BeautySalonBookingSystem/`.

---

## GitHub Upload Guidance

```bash
# inside the project folder
git init
git add .
git commit -m "Beauty Salon Appointment Booking System"
git branch -M main
git remote add origin https://github.com/<your-username>/BeautySalonBookingSystem.git
git push -u origin main
```

Recommended `.gitignore`:
```
target/
.idea/
*.iml
out/
*.log
```

---

## Viva Preparation — Quick Answers

**Q1. Why use JSP and Servlets instead of Spring Boot?**
The requirement was to demonstrate core Java EE / Jakarta EE skills — JSP for the view, Servlets for the controller, and plain Java classes for the model (an MVC pattern without any framework).

**Q2. Why are you storing data in `.txt` files instead of a database?**
The assignment specifies file handling. Each entity is serialized as a CSV line and managed with `BufferedReader` / `BufferedWriter`. This shows understanding of low-level I/O.

**Q3. Where is encapsulation in your code?**
Every model class — `Customer`, `Appointment`, `Service`, `Review` — keeps its fields `private` and exposes them through getters and setters.

**Q4. Where is inheritance?**
`Customer extends Person` (declared in `Customer.java`). `Person` is an abstract base class.

**Q5. Where is abstraction?**
`abstract class Person` defines an abstract method `getRole()` that subclasses must implement.

**Q6. Where is polymorphism?**
`Customer.getRole()` overrides the abstract method in `Person`. A `Person` reference can hold a `Customer` object — the JVM dispatches the correct overridden method at runtime.

**Q7. How does login work?**
`LoginServlet` reads `users.txt`, looks for a matching `username,password`, and on success stores the username in the `HttpSession`. JSP pages check `session.getAttribute("username")`.

**Q8. How does CRUD work for appointments?**
- **Create:** `BookingServlet` appends a new line to `appointments.txt`.
- **Read:** `appointments.jsp` reads all lines and shows the user's rows.
- **Update:** `UpdateAppointmentServlet` calls `FileHandler.updateById`.
- **Delete:** `DeleteAppointmentServlet` calls `FileHandler.deleteById`.

**Q9. How is concurrency handled?**
This is a teaching project. Each request fully reads/writes the file. For a real production system, we would use a database with transactions or `synchronized` blocks around file operations.

**Q10. Why Tomcat 10 (not 9)?**
Tomcat 10 implements **Jakarta EE 9+**, which uses the `jakarta.servlet` package (instead of `javax.servlet`). The `pom.xml` declares `jakarta.servlet-api 6.0.0` for that reason.

**Q11. Why Bootstrap 5?**
For a modern responsive UI with minimal CSS — loaded from CDN, no build tools needed.

**Q12. What design pattern is used?**
A simple **MVC** pattern: JSP = View, Servlets = Controller, plain Java classes + `FileHandler` = Model.

---

## License

Educational project — free to use and modify.
