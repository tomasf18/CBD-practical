LOAD CSV WITH HEADERS FROM 'file:///resources/lab44.csv' AS row
MERGE (ip:IP {address: row.IP})
SET ip.timestamp = row.Timestamp, ip.hostname = row.Hostnames
MERGE (country:Country {name: row.Country})
MERGE (organization:Organization {name: row.Organization})
MERGE (port:Port {number: toInteger(row.Port)})
MERGE (device:Device {name: row.Device})
SET device.banner = row.Banner
WITH ip, country, organization, port, device
MERGE (ip)-[:LOCATED_IN]->(country)
MERGE (port)-[:ON]->(ip)
MERGE (device)-[:LISTENING_ON]->(port)
MERGE (organization)-[:OWNS]->(ip)


# Query 1
## Mostra os dados de um Device específico e as suas relações com o IP, Country e Organization
MATCH (device:Device {name: 'Server20'})-[:LISTENING_ON]->(port:Port),
      (port)-[:ON]->(ip:IP),
      (ip)-[:LOCATED_IN]->(country:Country),
      (ip)<-[:OWNS]-(organization:Organization)
RETURN device.name AS device_name, device.banner AS banner, port.number AS port,
       ip.address AS ip_address, country.name AS country, organization.name AS organization
LIMIT 1;


# Query 2
## Mostra os dados de um IP específico e as suas relações com o Device, Port, Country e Organization
MATCH (ip:IP {address: "185.214.183.126"})-[:LOCATED_IN]->(country:Country),
      (ip)<-[:OWNS]-(organization:Organization),
      (ip)<-[:ON]-(port:Port),
      (port)<-[:LISTENING_ON]-(device:Device)
RETURN device.name AS device_name, device.banner AS banner, port.number AS port,
       ip.address AS ip_address, country.name AS country, organization.name AS organization


# Query 3
## Mostra o Device com mais IPs associados
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)-[:ON]->(ip:IP)
WITH device.name AS device_name, COUNT(DISTINCT ip) AS ip_count
ORDER BY ip_count DESC
RETURN device_name, ip_count
LIMIT 1;


# Query 4
## Mostra os 10 países com mais IPs associados
MATCH (ip:IP)-[:LOCATED_IN]->(country:Country)
WITH country.name AS country_name, COUNT(ip) AS ip_count
ORDER BY ip_count DESC
RETURN country_name, ip_count
LIMIT 10;


# Query 5
## Mostra as organizações de um determinado Country e os IPs associados
MATCH (organization:Organization)-[:OWNS]->(ip:IP)-[:LOCATED_IN]->(country:Country {name: "Germany"})
WITH country.name AS country_name, organization.name AS organization_name, COLLECT(ip.address) AS ip_addresses
RETURN country_name, organization_name, ip_addresses


# Query 6
## Mostra os Devices cujo banner começa com "St". Mostra o resultado na forma [Device, Banner]
MATCH (device:Device)
WHERE device.banner STARTS WITH "St"
WITH device.name AS Device, device.banner AS Banner
RETURN [Device, Banner] AS DeviceBanner


# Query 7
## Mostra a distribuição de Devices por Port, incluindo o número total de Devices por Port
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)
WITH port.number AS PortNumber, COLLECT(device.name) AS Devices
UNWIND Devices AS Device
RETURN PortNumber, Device, SIZE(Devices) AS TotalDevices
ORDER BY PortNumber ASC, Device ASC


# Query 8
## Mostra as top 5 organizações com mais Devices associados
MATCH (organization:Organization)-[:OWNS]->(ip:IP)<-[:ON]-(port:Port)<-[:LISTENING_ON]-(device:Device)
WITH organization.name AS organization_name, COUNT(DISTINCT device) AS device_count
ORDER BY device_count DESC
RETURN organization_name, device_count
LIMIT 5;


# Query 9
## Mostra todos os Ports e os Devices que estão "listening" nesses Ports, agrupados (i.e., por ordem) por Country
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)-[:ON]->(ip:IP)-[:LOCATED_IN]->(country:Country)
WITH country.name AS country_name, port.number AS port_number, COLLECT(DISTINCT device.name) AS devices
RETURN country_name, port_number, devices
ORDER BY country_name ASC, port_number ASC;


# Query 10
## Mostra os Devices que estão "listening" em mais de 20 Ports, mostrando a lista de Ports onde cada Device está "listening"
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)
WITH device.name AS device_name, COLLECT(port.number) AS ports
WHERE SIZE(ports) > 20
RETURN device_name, ports
ORDER BY SIZE(ports) DESC, device_name ASC;




