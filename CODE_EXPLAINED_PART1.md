# Beauty Salon Booking System — Full Code Explanation (Part 1)

---

## 1. Project Structure Overview

```
New folder (2)/
├── .gitignore           ← Tells Git which files/folders to ignore
├── pom.xml              ← Maven build config (dependencies, packaging)
├── README.md            ← Project documentation
├── data/                ← Seed .txt data files (users, appointments, etc.)
├── src/
│   └── main/
│       ├── java/com/salon/   ← All Java source files (Model + Servlets)
│       └── webapp/           ← All JSP pages + WEB-INF
└── target/              ← Maven build output (compiled .class + .war)
```

---

## 2. `.gitignore` — Git Ignore Rules

```
target/      ← Ignore the compiled build output folder
.idea/       ← Ignore IntelliJ project settings folder
*.iml        ← Ignore IntelliJ module files
out/         ← Ignore another IntelliJ output folder
*.log        ← Ignore all log files
.classpath   ← Ignore Eclipse classpath file
.project     ← Ignore Eclipse project file
.settings/   ← Ignore Eclipse settings folder
```

**What it does:** When you run `git add .`, Git skips all these files/folders.
They are either auto-generated (target/, out/) or IDE-specific (.idea/, .iml)
and don't need to be version-controlled.

---

## 3. `pom.xml` — Maven Project Configuration

```xml
<?xml version="1.0" encoding="UTF-8"?>
<!-- Root element of every Maven POM file -->
<project xmlns="http://maven.apache.org/POM/4.0.0" ...>

    <modelVersion>4.0.0</modelVersion>
    <!-- ^ Always 4.0.0 for Maven 2/3 projects -->

    <groupId>com.salon</groupId>
    <!-- ^ Your organization/package name (like a namespace) -->

    <artifactId>BeautySalonBookingSystem</artifactId>
    <!-- ^ The name of this project/module -->

    <version>1.0-SNAPSHOT</version>
    <!-- ^ Current version. SNAPSHOT = still in development -->

    <packaging>war</packaging>
    <!-- ^ Build a WAR file (Web ARchive) instead of a JAR.
           WAR files are deployed to Tomcat. -->

    <name>BeautySalonBookingSystem</name>

    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <!-- ^ Compile Java source code as Java 17 -->
        <maven.compiler.target>17</maven.compiler.target>
        <!-- ^ Produce bytecode compatible with Java 17 JVM -->
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        <!-- ^ Use UTF-8 encoding for all source files -->
    </properties>

    <dependencies>
        <!-- Jakarta Servlet API 6.0 (used by Tomcat 10) -->
        <dependency>
            <groupId>jakarta.servlet</groupId>
            <artifactId>jakarta.servlet-api</artifactId>
            <version>6.0.0</version>
            <scope>provided</scope>
            <!-- ^ "provided" = Tomcat already has this JAR at runtime,
                   so don't include it inside the WAR file -->
        </dependency>

        <!-- JSTL API for Jakarta (JSP Standard Tag Library) -->
        <dependency>
            <groupId>jakarta.servlet.jsp.jstl</groupId>
            <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
            <version>3.0.0</version>
            <!-- No scope = "compile", included in WAR -->
        </dependency>

        <!-- JSTL Implementation -->
        <dependency>
            <groupId>org.glassfish.web</groupId>
            <artifactId>jakarta.servlet.jsp.jstl</artifactId>
            <version>3.0.1</version>
        </dependency>
    </dependencies>

    <build>
        <finalName>BeautySalonBookingSystem</finalName>
        <!-- ^ The WAR file will be named BeautySalonBookingSystem.war -->

        <plugins>
            <!-- Maven WAR Plugin: packages the project as a WAR -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-war-plugin</artifactId>
                <version>3.4.0</version>
                <configuration>
                    <failOnMissingWebXml>false</failOnMissingWebXml>
                    <!-- ^ Don't fail if web.xml is missing (we use annotations) -->
                </configuration>
            </plugin>

            <!-- Maven Compiler Plugin: compiles Java source files -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
                <configuration>
                    <source>17</source>  <!-- compile as Java 17 -->
                    <target>17</target>
                </configuration>
            </plugin>
        </plugins>
    </build>
</project>
```

**What `target/` folder is:** When you run `mvn clean package`, Maven:
1. Compiles all `.java` → `.class` files into `target/classes/`
2. Copies JSP/HTML/CSS into `target/BeautySalonBookingSystem/`
3. Packages everything into `target/BeautySalonBookingSystem.war`

The `target/` folder is **auto-generated** and should never be committed to Git.

---

## 4. `data/` Folder — Seed Text Files

These plain `.txt` files are the "database" of this project.
Each line is one record in CSV format (comma-separated values).

| File | Format | Example |
|------|--------|---------|
| `users.txt` | `username,password,name,email,phone` | `alice,alice123,Alice Perera,alice@mail.com,0771112222` |
| `appointments.txt` | `id,username,service,date,time,status` | `1700000000001,alice,Hair Cut,2026-05-10,10:30,BOOKED` |
| `services.txt` | `id,name,price,duration` | `1700000000010,Hair Cut,1500.0,30 min` |
| `reviews.txt` | `id,username,service,rating,comment` | `1700000000020,alice,Hair Cut,5,Loved it!` |

---

## 5. Java Model Classes

### 5a. `Customer.java` — OOP Showcase (Inheritance, Encapsulation, Polymorphism)

```java
package com.salon;
// Line 1: Declares this file belongs to the "com.salon" package.
// Java uses packages like folders to organise classes.

public class Customer extends Person {
// Line 7: Customer INHERITS from Person (abstract class defined below).
// "extends" = inheritance. Customer gets all of Person's fields/methods.

    // ENCAPSULATION: all fields are private — hidden from outside
    private String username;   // Line 10: only accessible via getter/setter
    private String password;   // Line 11
    private String phone;      // Line 12

    public Customer() {
        super("", "");         // Line 15: calls Person's constructor with empty name/email
    }

    public Customer(String name, String email, String username, String password, String phone) {
        super(name, email);    // Line 19: pass name+email up to Person constructor
        this.username = username; // Line 20: "this." refers to the current object's field
        this.password = password;
        this.phone = phone;
    }

    // GETTERS & SETTERS — public methods to safely read/write private fields
    public String getUsername() { return username; }         // Line 25
    public void setUsername(String username) { this.username = username; } // Line 26

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    @Override                  // Line 35: Java annotation — confirms we are overriding
    public String getRole() {  // Line 36: POLYMORPHISM — overrides Person's abstract method
        return "CUSTOMER";     // Line 37: returns role string
    }

    public String toFileString() {
        // Line 42: Converts object to a CSV line for saving to users.txt
        return username + "," + password + "," + getName() + "," + getEmail() + "," + phone;
        // getName() and getEmail() come from the parent class Person
    }

    public static Customer fromFileString(String line) {
        // Line 46: "static" = belongs to class, not an instance. Called as Customer.fromFileString()
        String[] p = line.split(",", -1);
        // Line 47: split CSV line into array. -1 means keep empty trailing fields.
        if (p.length < 5) return null;
        // Line 48: if the line doesn't have 5 fields, it's invalid, skip it
        return new Customer(p[2], p[3], p[0], p[1], p[4]);
        // Line 49: username=p[0], password=p[1], name=p[2], email=p[3], phone=p[4]
    }
}

// ABSTRACTION — abstract class cannot be instantiated directly
abstract class Person {
    // Line 57: "abstract" means you can never do: new Person()
    // It exists only to be extended (inherited) by subclasses

    private String name;    // Line 58: encapsulated
    private String email;   // Line 59: encapsulated

    public Person(String name, String email) {
        this.name = name;   // Line 62
        this.email = email; // Line 63
    }

    public String getName() { return name; }        // Line 66: getter
    public void setName(String name) { this.name = name; } // Line 67: setter
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public abstract String getRole();
    // Line 73: abstract method — has NO body here.
    // Every subclass MUST provide its own implementation (POLYMORPHISM).
}
```

---

### 5b. `Appointment.java` — Appointment Model

```java
package com.salon;

public class Appointment {
    // All fields private = ENCAPSULATION
    private String id;       // unique ID (timestamp-based)
    private String username; // which customer owns this
    private String service;  // service name e.g. "Hair Cut"
    private String date;     // yyyy-MM-dd format
    private String time;     // HH:mm format
    private String status;   // BOOKED / COMPLETED / CANCELLED

    public Appointment() {}  // Line 16: default no-arg constructor (required by some frameworks)

    public Appointment(String id, String username, String service,
                       String date, String time, String status) {
        // Line 18-26: parameterized constructor sets all fields
        this.id = id;
        this.username = username;
        this.service = service;
        this.date = date;
        this.time = time;
        this.status = status;
    }

    // Getters and setters for all 6 fields (lines 28-44)
    public String getId() { return id; }
    public void setId(String id) { this.id = id; }
    // ... (same pattern for username, service, date, time, status)

    public String toFileString() {
        // Line 46-48: join all fields with comma → one CSV line
        return id + "," + username + "," + service + "," + date + "," + time + "," + status;
    }

    public static Appointment fromFileString(String line) {
        // Line 50-54: parse a CSV line back into an Appointment object
        String[] p = line.split(",", -1);
        if (p.length < 6) return null; // need exactly 6 fields
        return new Appointment(p[0], p[1], p[2], p[3], p[4], p[5]);
    }
}
```

---

### 5c. `Service.java` — Service Model

```java
package com.salon;

public class Service {
    private String id;
    private String name;
    private double price;    // Line 11: double for decimal prices (e.g. 1500.0)
    private String duration; // e.g. "30 min"

    // constructors, getters, setters follow the same pattern as Appointment

    public String toFileString() {
        return id + "," + name + "," + price + "," + duration;
        // price auto-converts to String e.g. "1500.0"
    }

    public static Service fromFileString(String line) {
        String[] p = line.split(",", -1);
        if (p.length < 4) return null;
        try {
            return new Service(p[0], p[1], Double.parseDouble(p[2]), p[3]);
            // Double.parseDouble(p[2]) converts "1500.0" string → double 1500.0
        } catch (NumberFormatException e) {
            return null; // if price field is not a valid number, skip this record
        }
    }
}
```

---

### 5d. `Review.java` — Review Model

```java
package com.salon;

public class Review {
    private String id;
    private String username;
    private String service;
    private int rating;     // Line 12: int, values 1-5
    private String comment;

    public String toFileString() {
        String safe = comment == null ? "" : comment.replace(",", " ");
        // Line 42: IMPORTANT — replace any commas in the comment with spaces.
        // Otherwise the CSV parsing would break (a comment like "great, loved it"
        // would create an extra column when split by comma).
        return id + "," + username + "," + service + "," + rating + "," + safe;
    }

    public static Review fromFileString(String line) {
        String[] p = line.split(",", -1);
        if (p.length < 5) return null;
        try {
            return new Review(p[0], p[1], p[2], Integer.parseInt(p[3]), p[4]);
            // Integer.parseInt(p[3]) converts rating string "5" → int 5
        } catch (NumberFormatException e) {
            return null;
        }
    }
}
```

---

### 5e. `FileHandler.java` — All File I/O in One Place

```java
package com.salon;

import java.io.*;         // Line 3: import File, FileReader, FileWriter, IOException etc.
import java.util.ArrayList;
import java.util.List;

public class FileHandler {

    public static String dataDir(String contextRealPath) {
        // Line 18: "static" = no object needed, call as FileHandler.dataDir(...)
        // contextRealPath = absolute path of the deployed webapp on disk
        File dir;
        if (contextRealPath != null) {
            dir = new File(contextRealPath, "data");
            // Line 23: creates a File object pointing to <webapp>/data/
        } else {
            dir = new File("data"); // Line 25: fallback to relative path
        }
        if (!dir.exists()) dir.mkdirs();
        // Line 27: if the data/ folder doesn't exist, create it (including parents)
        return dir.getAbsolutePath(); // Line 28: return full absolute path as String
    }

    public static String filePath(String contextRealPath, String fileName) {
        // Line 31-33: helper to get full path to a specific .txt file
        return dataDir(contextRealPath) + File.separator + fileName;
        // File.separator = "\" on Windows, "/" on Linux — keeps it cross-platform
    }

    public static void appendLine(String filePath, String line) throws IOException {
        // Line 36: add one line to the END of a file (used for CREATE operations)
        ensureFile(filePath); // make sure file exists before writing
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
            // Line 38: FileWriter(path, true) = open in APPEND mode (true = don't overwrite)
            // BufferedWriter wraps FileWriter for efficiency (buffers writes in memory)
            // "try-with-resources" automatically closes bw when done
            bw.write(line);   // write the text
            bw.newLine();     // write a newline character (\r\n on Windows)
        }
    }

    public static List<String> readAllLines(String filePath) throws IOException {
        // Line 45: read every non-blank line from a file → returns a List<String>
        List<String> lines = new ArrayList<>();
        File f = new File(filePath);
        if (!f.exists()) return lines; // Line 48: if file missing, return empty list
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            // Line 49: FileReader reads chars, BufferedReader adds readLine() convenience
            String line;
            while ((line = br.readLine()) != null) {
                // Line 51: read one line at a time until end-of-file (null)
                if (!line.trim().isEmpty()) lines.add(line);
                // Line 52: skip blank/whitespace-only lines
            }
        }
        return lines;
    }

    public static void writeAllLines(String filePath, List<String> lines) throws IOException {
        // Line 59: OVERWRITE the entire file with a new list of lines
        ensureFile(filePath);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
            // Line 61: false = overwrite mode (NOT append)
            for (String l : lines) {
                bw.write(l);
                bw.newLine();
            }
        }
    }

    public static boolean deleteById(String filePath, String id) throws IOException {
        // Line 70: remove the line whose first CSV field equals id
        List<String> lines = readAllLines(filePath);
        boolean removed = lines.removeIf(l -> l.split(",", -1)[0].equals(id));
        // Line 72: lambda — for each line l, split it, take field[0], compare to id
        // removeIf removes all matching lines and returns true if any were removed
        if (removed) writeAllLines(filePath, lines); // rewrite file without deleted line
        return removed;
    }

    public static boolean updateById(String filePath, String id, String newLine) throws IOException {
        // Line 78: find the line with matching id and replace it with newLine
        List<String> lines = readAllLines(filePath);
        boolean updated = false;
        for (int i = 0; i < lines.size(); i++) {
            if (lines.get(i).split(",", -1)[0].equals(id)) {
                lines.set(i, newLine); // Line 83: replace old line with new line
                updated = true;
                break; // Line 85: stop searching after first match
            }
        }
        if (updated) writeAllLines(filePath, lines);
        return updated;
    }

    public static String newId() {
        // Line 93: generate a unique ID using current time in milliseconds
        return String.valueOf(System.currentTimeMillis());
        // e.g. returns "1716099600000" — unique enough for a teaching project
    }

    private static void ensureFile(String filePath) throws IOException {
        // Line 97: create the file (and parent dirs) if they don't exist
        File f = new File(filePath);
        File parent = f.getParentFile();
        if (parent != null && !parent.exists()) parent.mkdirs();
        if (!f.exists()) f.createNewFile(); // Line 101: create empty file
    }
}
```
