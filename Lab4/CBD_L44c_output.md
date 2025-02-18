# 112981

## Lab04 -  Ex 4.4.c)


### Load dos Dados

```sql
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
```


### Query 1 - Mostra os dados de um Device específico (incluindo as suas relações com o IP, Country e Organization)

#### Cypher:
```sql
MATCH (device:Device {name: 'Server20'})-[:LISTENING_ON]->(port:Port),
    (port)-[:ON]->(ip:IP),
    (ip)-[:LOCATED_IN]->(country:Country),
    (ip)<-[:OWNS]-(organization:Organization)
RETURN device.name AS device_name, device.banner AS banner, port.number AS port,
    ip.address AS ip_address, country.name AS country, organization.name AS organization
LIMIT 1;
```

#### Resultado:

```txt
Query 1: Device Details and Relationships:
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server20
  - Banner: Care sell base art miss write field design.
  - Port: 223
  - IP Address: 114.12.15.237
  - Country: Pakistan
  - Organization: Apple
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query1.json](resultados_4c_json/query1.json)


### Query 2 - Mostra os dados de um IP específico e as suas relações com o Device, Port, Country e Organization

#### Cypher:
```sql
MATCH (ip:IP {address: "185.214.183.126"})-[:LOCATED_IN]->(country:Country),
      (ip)<-[:OWNS]-(organization:Organization),
      (ip)<-[:ON]-(port:Port),
      (port)<-[:LISTENING_ON]-(device:Device)
RETURN device.name AS device_name, device.banner AS banner, port.number AS port,
       ip.address AS ip_address, country.name AS country, organization.name AS organization
```

#### Resultado:

```txt
Query 2: IP '185.214.183.126' Details and Relationships:
---------------------------------------------------------------------------
IP Details:
  - Device Name: Server92
  - Banner: Affect build large rather radio order conference couple.
  - Port: 425
  - IP Address: 185.214.183.126
  - Country: Vietnam
  - Organization: Citigroup
---------------------------------------------------------------------------
---------------------------------------------------------------------------
IP Details:
  - Device Name: Server8
  - Banner: Approach black scientist certain.
  - Port: 425
  - IP Address: 185.214.183.126
  - Country: Vietnam
  - Organization: Citigroup
---------------------------------------------------------------------------
---------------------------------------------------------------------------
IP Details:
  - Device Name: Server67
  - Banner: Effort hope sometimes example imagine student born.
  - Port: 425
  - IP Address: 185.214.183.126
  - Country: Vietnam
  - Organization: Citigroup
---------------------------------------------------------------------------
---------------------------------------------------------------------------
IP Details:
  - Device Name: Server51
  - Banner: Next level later little your ever.
  - Port: 425
  - IP Address: 185.214.183.126
  - Country: Vietnam
  - Organization: Citigroup
---------------------------------------------------------------------------
---------------------------------------------------------------------------
IP Details:
  - Device Name: Server17
  - Banner: Someone election seven hit.
  - Port: 425
  - IP Address: 185.214.183.126
  - Country: Vietnam
  - Organization: Citigroup
---------------------------------------------------------------------------
---------------------------------------------------------------------------
IP Details:
  - Device Name: Server39
  - Banner: Three history size along program store perform.
  - Port: 425
  - IP Address: 185.214.183.126
  - Country: Vietnam
  - Organization: Citigroup
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query2.json](resultados_4c_json/query2.json)


### Query 3 - Mostra o Device com mais IPs associados

#### Cypher:
```sql
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)-[:ON]->(ip:IP)
WITH device.name AS device_name, COUNT(DISTINCT ip) AS ip_count
ORDER BY ip_count DESC
RETURN device_name, ip_count
LIMIT 1;
```

#### Resultado:

```txt
Query 3: Device with Most IPs:
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server93
  - Number of IPs: 188
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query3.json](resultados_4c_json/query3.json)


### Query 4 - Mostra os 10 países com mais IPs associados

#### Cypher:
```sql
MATCH (ip:IP)-[:LOCATED_IN]->(country:Country)
WITH country.name AS country_name, COUNT(ip) AS ip_count
ORDER BY ip_count DESC
RETURN country_name, ip_count
LIMIT 10;
```

#### Resultado:

```txt
Query 4: Top 10 Countries with Most IPs:
---------------------------------------------------------------------------
Country Details:
  - Country Name: Japan
  - Number of IPs: 83
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: South Korea
  - Number of IPs: 79
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: Chile
  - Number of IPs: 76
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: United Kingdom
  - Number of IPs: 74
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: South Africa
  - Number of IPs: 74
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: Brazil
  - Number of IPs: 74
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: Russia
  - Number of IPs: 73
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: Egypt
  - Number of IPs: 73
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: United Arab Emirates
  - Number of IPs: 72
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country Details:
  - Country Name: Argentina
  - Number of IPs: 71
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query4.json](resultados_4c_json/query4.json)


### Query 5 - Mostra as organizações de um determinado Country e os IPs associados

#### Cypher:
```sql
MATCH (organization:Organization)-[:OWNS]->(ip:IP)-[:LOCATED_IN]->(country:Country {name: "Germany"})
WITH country.name AS country_name, organization.name AS organization_name, COLLECT(ip.address) AS ip_addresses
RETURN country_name, organization_name, ip_addresses
```

#### Resultado:

```txt
Query 5: Organizations in 'Germany' and Associated IPs:
---------------------------------------------------------------------------
Country: Germany
Organization: KPMG
IP Addresses:
  - 88.98.57.90
  - 115.187.251.122
  - 65.97.171.98
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Citigroup
IP Addresses:
  - 47.101.149.113
  - 153.105.179.216
  - 78.168.171.21
  - 200.46.252.246
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: IBM
IP Addresses:
  - 196.175.99.55
  - 100.35.232.33
  - 109.72.53.53
  - 35.200.91.58
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Deloitte
IP Addresses:
  - 49.31.19.69
  - 75.106.3.28
  - 119.172.185.128
  - 113.78.173.97
  - 63.174.213.38
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Tesla
IP Addresses:
  - 44.7.10.158
  - 200.61.195.203
  - 110.235.77.54
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Google
IP Addresses:
  - 74.177.163.190
  - 154.123.7.21
  - 169.154.85.111
  - 24.70.188.223
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Toyota
IP Addresses:
  - 216.108.28.218
  - 11.241.37.225
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Barclays
IP Addresses:
  - 190.236.47.248
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Siemens
IP Addresses:
  - 196.0.202.72
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Accenture
IP Addresses:
  - 118.81.245.77
  - 205.116.147.250
  - 163.43.37.209
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Mercedes-Benz
IP Addresses:
  - 46.63.75.77
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Sony
IP Addresses:
  - 56.63.107.151
  - 159.237.98.226
  - 4.76.100.209
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Samsung
IP Addresses:
  - 151.51.104.88
  - 169.177.202.0
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: JPMorgan Chase
IP Addresses:
  - 50.153.24.244
  - 165.223.213.226
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Huawei
IP Addresses:
  - 38.9.252.230
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: HSBC
IP Addresses:
  - 48.41.177.35
  - 76.155.183.128
  - 7.142.213.33
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Apple
IP Addresses:
  - 41.191.188.44
  - 156.234.96.119
  - 199.40.116.20
  - 146.102.132.28
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: General Electric
IP Addresses:
  - 52.77.235.122
  - 87.179.119.209
  - 221.57.103.9
  - 68.194.74.70
  - 184.114.124.45
  - 142.144.162.16
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Goldman Sachs
IP Addresses:
  - 58.130.80.80
  - 117.129.251.57
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Intel
IP Addresses:
  - 218.226.34.118
  - 111.9.248.192
  - 152.22.23.237
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: BMW
IP Addresses:
  - 21.242.53.219
  - 94.242.231.171
  - 40.196.92.16
  - 89.124.251.87
  - 118.51.32.89
  - 98.155.104.5
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Facebook
IP Addresses:
  - 179.49.250.53
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Morgan Stanley
IP Addresses:
  - 133.16.87.135
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Volkswagen
IP Addresses:
  - 125.5.216.87
  - 39.178.122.241
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Cisco
IP Addresses:
  - 91.121.72.43
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Germany
Organization: Microsoft
IP Addresses:
  - 107.223.58.129
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query5.json](resultados_4c_json/query5.json)


### Query 6 - Mostra os Devices cujo banner começa com "St". Mostra o resultado na forma [Device, Banner]

#### Cypher:
```sql
MATCH (device:Device)
WHERE device.banner STARTS WITH "St"
WITH device.name AS Device, device.banner AS Banner
RETURN [Device, Banner] AS DeviceBanner
```

#### Resultado:

```txt
Query 6: Devices with Banners Starting with 'St':
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server69
  - Banner: Start old leg prevent.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server59
  - Banner: Stuff computer give stay other piece billion bill.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server13
  - Banner: Stuff ready big social writer article think.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server28
  - Banner: Style bar stuff.
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server66
  - Banner: Student former black none country rock able.
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query6.json](resultados_4c_json/query6.json)


### Query 7 - Mostra a distribuição de Devices por Port, incluindo o número total de Devices por Port

#### Cypher:
```sql
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)
WITH port.number AS PortNumber, COLLECT(device.name) AS Devices
UNWIND Devices AS Device
RETURN PortNumber, Device, SIZE(Devices) AS TotalDevices
ORDER BY PortNumber ASC, Device ASC
```

#### Resultado:

```txt
Query 7: Device Distribution by Port:
---------------------------------------------------------------------------
Port Details:
  - Port Number: 200
  - Device Name: Server39
  - Total Devices on Port: 5
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 200
  - Device Name: Server42
  - Total Devices on Port: 5
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 200
  - Device Name: Server43
  - Total Devices on Port: 5
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 200
  - Device Name: Server6
  - Total Devices on Port: 5
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 200
  - Device Name: Server77
  - Total Devices on Port: 5
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 201
  - Device Name: Server5
  - Total Devices on Port: 3
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 201
  - Device Name: Server58
  - Total Devices on Port: 3
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 201
  - Device Name: Server98
  - Total Devices on Port: 3
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 202
  - Device Name: Server12
  - Total Devices on Port: 9
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 202
  - Device Name: Server35
  - Total Devices on Port: 9
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 202
  - Device Name: Server36
  - Total Devices on Port: 9
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 202
  - Device Name: Server51
  - Total Devices on Port: 9
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Port Details:
  - Port Number: 202
  - Device Name: Server78
  - Total Devices on Port: 9
---------------------------------------------------------------------------
(...)
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query7.json](resultados_4c_json/query7.json)


### Query 8 - Mostra as top 5 organizações com mais Devices associados

#### Cypher:
```sql
MATCH (organization:Organization)-[:OWNS]->(ip:IP)<-[:ON]-(port:Port)<-[:LISTENING_ON]-(device:Device)
WITH organization.name AS organization_name, COUNT(DISTINCT device) AS device_count
ORDER BY device_count DESC
RETURN organization_name, device_count
LIMIT 5;
```

#### Resultado:

```txt
Query 8: Top 5 Organizations with Most Devices:
---------------------------------------------------------------------------
Organization Details:
  - Organization Name: General Electric
  - Number of Devices: 100
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Organization Details:
  - Organization Name: Sony
  - Number of Devices: 100
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Organization Details:
  - Organization Name: PwC
  - Number of Devices: 99
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Organization Details:
  - Organization Name: Volkswagen
  - Number of Devices: 99
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Organization Details:
  - Organization Name: KPMG
  - Number of Devices: 99
---------------------------------------------------------------------------
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query8.json](resultados_4c_json/query8.json)


### Query 9 - Mostra todos os Ports e os Devices que estão "listening" nesses Ports,  por ordem de Country

#### Cypher:
```sql
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)-[:ON]->(ip:IP)-[:LOCATED_IN]->(country:Country)
WITH country.name AS country_name, port.number AS port_number, COLLECT(DISTINCT device.name) AS devices
RETURN country_name, port_number, devices
ORDER BY country_name ASC, port_number ASC;
```

#### Resultado:

```txt
Query 9: All Ports and the Devices listening on them, grouped by Country:
---------------------------------------------------------------------------
Country: Argentina
Port Number: 203
Devices:
  - Server96
  - Server9
  - Server87
  - Server48
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Argentina
Port Number: 205
Devices:
  - Server8
  - Server36
  - Server4
  - Server67
  - Server95
  - Server46
  - Server53
  - Server93
  - Server44
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Argentina
Port Number: 209
Devices:
  - Server25
  - Server84
  - Server38
  - Server27
  - Server53
  - Server95
  - Server80
  - Server24
  - Server15
  - Server74
  - Server62
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Argentina
Port Number: 210
Devices:
  - Server92
  - Server34
  - Server50
  - Server57
  - Server95
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Country: Argentina
Port Number: 218
Devices:
  - Server92
  - Server82
  - Server58
  - Server12
  - Server45
---------------------------------------------------------------------------
(...)
```

**Nota:** O resultado completo e formatado pode ser encontrado em [query9.json](resultados_4c_json/query9.json)


### Query 10 - Mostra os Devices que estão "listening" em mais de 20 Ports, mostrando a lista de Ports onde cada Device está "listening"

#### Cypher:
```sql
MATCH (device:Device)-[:LISTENING_ON]->(port:Port)
WITH device.name AS device_name, COLLECT(port.number) AS ports
WHERE SIZE(ports) > 20
RETURN device_name, ports
ORDER BY SIZE(ports) DESC, device_name ASC;
```

#### Resultado:

```txt
Query 10: Devices Listening on More Than 20 Ports:
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server93
  - Ports: [280, 244, 220, 598, 428, 281, 399, 437, 508, 409, 206, 362, 382, 532, 537, 225, 524, 358, 461, 549, 256, 566, 459, 257, 589, 406, 207, 298, 205, 417]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server70
  - Ports: [243, 220, 554, 254, 245, 409, 482, 227, 547, 287, 571, 531, 328, 265, 230, 463, 451, 214, 563, 257, 242, 284, 484, 226, 590, 256, 308, 600]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server82
  - Ports: [452, 256, 339, 202, 337, 257, 539, 591, 493, 275, 282, 218, 221, 351, 422, 325, 296, 592, 429, 541, 354, 308, 558, 459, 455, 590, 229, 532]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server84
  - Ports: [403, 319, 209, 359, 531, 487, 438, 394, 450, 517, 273, 298, 228, 214, 499, 496, 431, 414, 355, 444, 566, 556, 334, 512, 299, 506, 397, 272]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server72
  - Ports: [401, 544, 296, 456, 501, 448, 591, 563, 424, 393, 361, 286, 322, 545, 546, 549, 362, 293, 582, 554, 277, 486, 428, 227, 547, 224, 240]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server95
  - Ports: [229, 481, 535, 355, 587, 585, 316, 421, 430, 410, 581, 209, 305, 207, 544, 205, 247, 215, 210, 245, 352, 543, 572, 386, 499, 510, 365]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server34
  - Ports: [262, 564, 386, 547, 210, 574, 524, 531, 333, 503, 251, 411, 294, 467, 263, 375, 476, 362, 586, 363, 422, 319, 423, 313, 348, 513]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server60
  - Ports: [245, 569, 283, 326, 470, 518, 354, 321, 474, 573, 385, 341, 228, 528, 262, 465, 247, 381, 576, 420, 370, 351, 363, 350, 427, 258]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server66
  - Ports: [393, 305, 487, 385, 247, 293, 439, 566, 441, 363, 516, 347, 331, 287, 238, 223, 523, 414, 409, 451, 418, 476, 282, 489, 515, 313]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server25
  - Ports: [320, 209, 380, 335, 548, 261, 417, 582, 238, 439, 277, 455, 596, 574, 302, 418, 508, 304, 408, 214, 412, 490, 390, 495, 307]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server62
  - Ports: [219, 275, 363, 556, 232, 484, 260, 582, 544, 534, 320, 273, 329, 584, 359, 563, 286, 593, 261, 551, 328, 209, 478, 494, 253]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server78
  - Ports: [202, 489, 376, 217, 442, 227, 356, 517, 384, 226, 366, 599, 486, 466, 390, 257, 246, 410, 495, 281, 394, 280, 264, 575, 399]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server13
  - Ports: [597, 535, 442, 217, 213, 474, 578, 302, 511, 524, 386, 221, 379, 452, 254, 449, 214, 536, 281, 356, 389, 480, 251, 568]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server65
  - Ports: [321, 505, 359, 300, 507, 291, 514, 471, 364, 385, 339, 256, 571, 583, 285, 377, 567, 310, 532, 580, 593, 239, 439, 313]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server67
  - Ports: [453, 358, 287, 297, 425, 302, 551, 467, 550, 225, 462, 581, 205, 560, 363, 416, 426, 445, 434, 588, 333, 530, 314, 561]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server1
  - Ports: [246, 256, 453, 268, 507, 249, 363, 375, 245, 280, 220, 353, 229, 226, 469, 252, 445, 470, 403, 284, 538, 260, 576]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server11
  - Ports: [391, 431, 289, 235, 532, 281, 518, 493, 394, 363, 325, 299, 250, 488, 385, 274, 257, 544, 434, 510, 230, 255, 357]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server30
  - Ports: [268, 385, 359, 419, 270, 402, 566, 452, 279, 553, 281, 468, 477, 275, 298, 548, 372, 302, 592, 285, 329, 311, 560]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server31
  - Ports: [307, 430, 436, 212, 466, 227, 386, 282, 349, 554, 452, 447, 450, 598, 293, 304, 339, 530, 535, 225, 504, 305, 462]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server41
  - Ports: [357, 526, 370, 520, 390, 572, 582, 363, 592, 367, 556, 381, 343, 484, 273, 283, 260, 228, 221, 593, 364, 478, 577]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server6
  - Ports: [538, 271, 234, 335, 498, 341, 251, 439, 282, 238, 468, 435, 562, 529, 362, 200, 245, 450, 225, 422, 401, 569, 311]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server12
  - Ports: [242, 305, 426, 202, 289, 291, 360, 286, 312, 578, 431, 250, 550, 486, 238, 271, 253, 562, 218, 363, 494, 369]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server27
  - Ports: [523, 247, 346, 439, 258, 209, 588, 577, 292, 373, 233, 468, 467, 594, 379, 272, 320, 540, 464, 344, 251, 296]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server61
  - Ports: [245, 396, 321, 364, 250, 258, 366, 212, 266, 339, 436, 578, 524, 589, 378, 391, 360, 340, 329, 372, 600, 465]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server85
  - Ports: [434, 302, 404, 355, 346, 534, 537, 588, 322, 584, 374, 478, 215, 246, 354, 311, 242, 225, 592, 505, 508, 343]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server99
  - Ports: [223, 390, 335, 303, 330, 503, 533, 274, 511, 546, 272, 563, 327, 572, 293, 365, 341, 230, 378, 232, 395, 436]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server35
  - Ports: [376, 528, 272, 233, 235, 588, 343, 590, 350, 214, 417, 202, 563, 540, 294, 338, 366, 244, 450, 261, 332]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server37
  - Ports: [257, 357, 231, 380, 396, 476, 533, 562, 236, 478, 416, 510, 342, 552, 442, 480, 297, 228, 477, 410, 555]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server40
  - Ports: [504, 470, 215, 586, 432, 314, 268, 524, 298, 564, 584, 568, 211, 516, 480, 427, 310, 536, 255, 327, 426]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server74
  - Ports: [544, 354, 434, 356, 517, 418, 283, 221, 220, 437, 318, 510, 588, 209, 478, 546, 413, 384, 547, 538, 327]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server80
  - Ports: [453, 564, 290, 557, 431, 408, 300, 249, 209, 382, 549, 584, 531, 329, 556, 512, 222, 516, 543, 599, 468]
---------------------------------------------------------------------------
---------------------------------------------------------------------------
Device Details:
  - Device Name: Server9
  - Ports: [267, 203, 403, 304, 594, 545, 548, 244, 248, 553, 547, 370, 551, 479, 500, 514, 385, 307, 475, 228, 381]
---------------------------------------------------------------------------

```

**Nota:** O resultado completo e formatado pode ser encontrado em [query10.json](resultados_4c_json/query10.json)
