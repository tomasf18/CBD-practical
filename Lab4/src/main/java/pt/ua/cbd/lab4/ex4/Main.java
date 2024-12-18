package pt.ua.cbd.lab4.ex4;

import org.neo4j.driver.GraphDatabase;

import java.util.List;

import org.neo4j.driver.Driver;
import org.neo4j.driver.Result;
import org.neo4j.driver.Session;
import org.neo4j.driver.Value;
import org.neo4j.driver.Record;

public class Main {
    private static final String filePath = "resources/lab44.csv";
    private static final String uri = "bolt://localhost:7687";

    public static void main(String[] args) {
        Driver driver = GraphDatabase.driver(uri);

        // Load dataset to Neo4j
        load(driver);

        // Queries
        System.out.println("\n\n");
        query1(driver);
        System.out.println("\n\n");
        query2(driver, "185.214.183.126");
        System.out.println("\n\n");
        query3(driver);
        System.out.println("\n\n");
        query4(driver);
        System.out.println("\n\n");
        query5(driver, "Germany");
        System.out.println("\n\n");
        query6(driver, "St");
        System.out.println("\n\n");
        query7(driver);
        System.out.println("\n\n");
        query8(driver);
        System.out.println("\n\n");
        query9(driver);
        System.out.println("\n\n");
        query10(driver);
        System.out.println("\n\n");

        // Close driver
        driver.close();
    }

    private static void load(Driver driver) {
        try (Session session = driver.session()) {
            session.run("LOAD CSV WITH HEADERS FROM 'file:///" + filePath + "' AS row " +
                    "MERGE (ip:IP {address: row.IP}) " +
                    "SET ip.timestamp = row.Timestamp, ip.hostname = row.Hostnames " +
                    "MERGE (country:Country {name: row.Country}) " +
                    "MERGE (organization:Organization {name: row.Organization}) " +
                    "MERGE (port:Port {number: toInteger(row.Port)}) " +
                    "MERGE (device:Device {name: row.Device}) " +
                    "SET device.banner = row.Banner " +
                    "WITH ip, country, organization, port, device " +
                    "MERGE (ip)-[:LOCATED_IN]->(country) " +
                    "MERGE (port)-[:ON]->(ip) " +
                    "MERGE (device)-[:LISTENING_ON]->(port) " +
                    "MERGE (organization)-[:OWNS]->(ip)");

            System.out.println("Dataset loaded successfully");
        } catch (Exception e) {
            System.out.println("Error loading dataset: " + e.getMessage());
        }
    }

    public static void query1(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (device:Device {name: 'Server20'})-[:LISTENING_ON]->(port:Port), " +
                    "(port)-[:ON]->(ip:IP), " +
                    "(ip)-[:LOCATED_IN]->(country:Country), " +
                    "(ip)<-[:OWNS]-(organization:Organization) " +
                    "RETURN device.name AS device_name, device.banner AS banner, port.number AS port, " +
                    "ip.address AS ip_address, country.name AS country, organization.name AS organization " +
                    "LIMIT 1");
    
            System.out.println("\nQuery 1: Mostra os dados de um Device específico e as suas relações com o IP, Country e Organization:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Device Details:");
                System.out.println("  - Device Name: " + record.get("device_name").asString());
                System.out.println("  - Banner: " + record.get("banner").asString());
                System.out.println("  - Port: " + record.get("port").asInt());
                System.out.println("  - IP Address: " + record.get("ip_address").asString());
                System.out.println("  - Country: " + record.get("country").asString());
                System.out.println("  - Organization: " + record.get("organization").asString());
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 1: " + e.getMessage());
        }
    }

    public static void query2(Driver driver, String ip) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (ip:IP {address: '" + ip + "'})-[:LOCATED_IN]->(country:Country), " +
                    "(ip)<-[:OWNS]-(organization:Organization), " +
                    "(ip)<-[:ON]-(port:Port), " +
                    "(port)<-[:LISTENING_ON]-(device:Device) " +
                    "RETURN device.name AS device_name, device.banner AS banner, port.number AS port, " +
                    "ip.address AS ip_address, country.name AS country, organization.name AS organization");
    
            System.out.println("\nQuery 2: Mostra os dados de um IP específico e as suas relações com o Device, Port, Country e Organization:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("IP Details:");
                System.out.println("  - Device Name: " + record.get("device_name").asString());
                System.out.println("  - Banner: " + record.get("banner").asString());
                System.out.println("  - Port: " + record.get("port").asInt());
                System.out.println("  - IP Address: " + record.get("ip_address").asString());
                System.out.println("  - Country: " + record.get("country").asString());
                System.out.println("  - Organization: " + record.get("organization").asString());
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 2: " + e.getMessage());
        }
    }

    public static void query3(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (device:Device)-[:LISTENING_ON]->(port:Port)-[:ON]->(ip:IP) " +
                    "WITH device.name AS device_name, COUNT(DISTINCT ip) AS ip_count " +
                    "ORDER BY ip_count DESC " +
                    "RETURN device_name, ip_count " +
                    "LIMIT 1");
    
            System.out.println("\nQuery 3: Mostra o Device com mais IPs associados:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Device Details:");
                System.out.println("  - Device Name: " + record.get("device_name").asString());
                System.out.println("  - Number of IPs: " + record.get("ip_count").asInt());
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 3: " + e.getMessage());
        }
    }
    
    public static void query4(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (ip:IP)-[:LOCATED_IN]->(country:Country) " +
                    "WITH country.name AS country_name, COUNT(ip) AS ip_count " +
                    "ORDER BY ip_count DESC " +
                    "RETURN country_name, ip_count " +
                    "LIMIT 10");
    
            System.out.println("\nQuery 4: Mostra os 10 países com mais IPs associados:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Country Details:");
                System.out.println("  - Country Name: " + record.get("country_name").asString());
                System.out.println("  - Number of IPs: " + record.get("ip_count").asInt());
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 4: " + e.getMessage());
        }
    }

    public static void query5(Driver driver, String country) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (organization:Organization)-[:OWNS]->(ip:IP)-[:LOCATED_IN]->(country:Country {name: '" + country + "'}) " +
                    "WITH country.name AS country_name, organization.name AS organization_name, COLLECT(ip.address) AS ip_addresses " +
                    "RETURN country_name, organization_name, ip_addresses");

            System.out.println("\nQuery 5: Mostra as organizações de um determinado Country e os IPs associados:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Country: " + record.get("country_name").asString());
                System.out.println("Organization: " + record.get("organization_name").asString());
                System.out.println("IP Addresses:");
                for (String ip : record.get("ip_addresses").asList(Value::asString)) {
                    System.out.println("  - " + ip);
                }
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 5: " + e.getMessage());
        }
    }

    public static void query6(Driver driver, String prefix) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (device:Device) " +
                    "WHERE device.banner STARTS WITH '" + prefix + "' " +
                    "WITH device.name AS Device, device.banner AS Banner " +
                    "RETURN [Device, Banner] AS DeviceBanner");

            System.out.println("\nQuery 6: Mostra os Devices cujo banner começa com '" + prefix + "'. Mostra o resultado na forma [Device, Banner]:");
            while (result.hasNext()) {
                Record record = result.next();
                List<Object> deviceBanner = record.get("DeviceBanner").asList();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Device Details:");
                System.out.println("  - Device Name: " + deviceBanner.get(0));
                System.out.println("  - Banner: " + deviceBanner.get(1));
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 6: " + e.getMessage());
        }
    }

    public static void query7(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (device:Device)-[:LISTENING_ON]->(port:Port) " +
                    "WITH port.number AS PortNumber, COLLECT(device.name) AS Devices " +
                    "UNWIND Devices AS Device " +
                    "RETURN PortNumber, Device, SIZE(Devices) AS TotalDevices " +
                    "ORDER BY PortNumber ASC, Device ASC");
    
            System.out.println("\nQuery 7: Mostra a distribuição de Devices por Port, incluindo o número total de Devices por Port:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Port Details:");
                System.out.println("  - Port Number: " + record.get("PortNumber").asInt());
                System.out.println("  - Device Name: " + record.get("Device").asString());
                System.out.println("  - Total Devices on Port: " + record.get("TotalDevices").asInt());
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 7: " + e.getMessage());
        }
    }
    
    public static void query8(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (organization:Organization)-[:OWNS]->(ip:IP)<-[:ON]-(port:Port)<-[:LISTENING_ON]-(device:Device) " +
                    "WITH organization.name AS organization_name, COUNT(DISTINCT device) AS device_count " +
                    "ORDER BY device_count DESC " +
                    "RETURN organization_name, device_count " +
                    "LIMIT 5");
    
            System.out.println("\nQuery 8: Mostra as top 5 organizações com mais Devices associados:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Organization Details:");
                System.out.println("  - Organization Name: " + record.get("organization_name").asString());
                System.out.println("  - Number of Devices: " + record.get("device_count").asInt());
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 8: " + e.getMessage());
        }
    }    

    public static void query9(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (device:Device)-[:LISTENING_ON]->(port:Port)-[:ON]->(ip:IP)-[:LOCATED_IN]->(country:Country) " +
                    "WITH country.name AS country_name, port.number AS port_number, COLLECT(DISTINCT device.name) AS devices " +
                    "RETURN country_name, port_number, devices " +
                    "ORDER BY country_name ASC, port_number ASC");

            System.out.println("\nQuery 9: Mostra todos os Ports e os Devices que estão \"listening\" nesses Ports, agrupados (i.e., por ordem) por Country:");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Country: " + record.get("country_name").asString());
                System.out.println("Port Number: " + record.get("port_number").asInt());
                System.out.println("Devices:");
                for (String device : record.get("devices").asList(Value::asString)) {
                    System.out.println("  - " + device);
                }
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 9: " + e.getMessage());
        }
    }

    public static void query10(Driver driver) {
        try (Session session = driver.session()) {
            Result result = session.run("MATCH (device:Device)-[:LISTENING_ON]->(port:Port) " +
                    "WITH device.name AS device_name, COLLECT(port.number) AS ports " +
                    "WHERE SIZE(ports) > 20 " +
                    "RETURN device_name, ports " +
                    "ORDER BY SIZE(ports) DESC, device_name ASC");

            System.out.println("\nQuery 10: Mostra os Devices que estão \"listening\" em mais de 20 Ports, mostrando a lista de Ports onde cada Device está \"listening\":");
            while (result.hasNext()) {
                Record record = result.next();
                System.out.println("---------------------------------------------------------------------------");
                System.out.println("Device Details:");
                System.out.println("  - Device Name: " + record.get("device_name").asString());
                System.out.println("  - Ports: " + record.get("ports").asList(Value::asInt));
                System.out.println("---------------------------------------------------------------------------");
            }
        } catch (Exception e) {
            System.out.println("Error executing query 10: " + e.getMessage());
        }
    }
}
