package com.salon;

import java.io.*;
import java.util.ArrayList;
import java.util.List;


public class FileHandler {

    /** Resolve absolute path of the data directory. Creates it if missing. */
    public static String dataDir(String contextRealPath) {
        // Place data folder at the project root if running in IntelliJ,
        // or under <webapp>/data when deployed.
        File dir;
        if (contextRealPath != null) {
            dir = new File(contextRealPath, "data");
        } else {
            dir = new File("data");
        }
        if (!dir.exists()) dir.mkdirs();
        return dir.getAbsolutePath();
    }

    public static String filePath(String contextRealPath, String fileName) {
        return dataDir(contextRealPath) + File.separator + fileName;
    }

    /** Append a single line to a file (creates file if not exists). */
    public static void appendLine(String filePath, String line) throws IOException {
        ensureFile(filePath);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, true))) {
            bw.write(line);
            bw.newLine();
        }
    }

    /** Read all lines from a file. Returns empty list if file doesn't exist. */
    public static List<String> readAllLines(String filePath) throws IOException {
        List<String> lines = new ArrayList<>();
        File f = new File(filePath);
        if (!f.exists()) return lines;
        try (BufferedReader br = new BufferedReader(new FileReader(filePath))) {
            String line;
            while ((line = br.readLine()) != null) {
                if (!line.trim().isEmpty()) lines.add(line);
            }
        }
        return lines;
    }

    /** Overwrite a file with given lines. */
    public static void writeAllLines(String filePath, List<String> lines) throws IOException {
        ensureFile(filePath);
        try (BufferedWriter bw = new BufferedWriter(new FileWriter(filePath, false))) {
            for (String l : lines) {
                bw.write(l);
                bw.newLine();
            }
        }
    }

    /** Delete a line whose first CSV field equals id. Returns true if removed. */
    public static boolean deleteById(String filePath, String id) throws IOException {
        List<String> lines = readAllLines(filePath);
        boolean removed = lines.removeIf(l -> l.split(",", -1)[0].equals(id));
        if (removed) writeAllLines(filePath, lines);
        return removed;
    }

    /** Update a line by id with newLine. Returns true if updated. */
    public static boolean updateById(String filePath, String id, String newLine) throws IOException {
        List<String> lines = readAllLines(filePath);
        boolean updated = false;
        for (int i = 0; i < lines.size(); i++) {
            if (lines.get(i).split(",", -1)[0].equals(id)) {
                lines.set(i, newLine);
                updated = true;
                break;
            }
        }
        if (updated) writeAllLines(filePath, lines);
        return updated;
    }

    /** Generate a simple unique id based on current millis. */
    public static String newId() {
        return String.valueOf(System.currentTimeMillis());
    }

    private static void ensureFile(String filePath) throws IOException {
        File f = new File(filePath);
        File parent = f.getParentFile();
        if (parent != null && !parent.exists()) parent.mkdirs();
        if (!f.exists()) f.createNewFile();
    }
}

